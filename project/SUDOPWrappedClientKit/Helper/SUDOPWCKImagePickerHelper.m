//
//  SUDOPWCKImagePickerHelper.m
//  SUDGI
//
//  Created by kaniel on 5/14/26.
//

#import "SUDOPWCKImagePickerHelper.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

static NSString * const SUDImageSourceTypeAlbum = @"album";
static NSString * const SUDImageSourceTypeCamera = @"camera";

@interface SUDOPWCKImagePickerHelper () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate>

@property (nonatomic, weak) UIViewController *presentViewController;
@property (nonatomic, strong) NSArray<NSString *> *sourceTypes;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, copy) void(^completion)(NSArray<UIImage *> * _Nullable images, NSError * _Nullable error);

@end

@implementation SUDOPWCKImagePickerHelper

+ (void)chooseImagesFromViewController:(UIViewController * _Nullable)viewController
                           sourceTypes:(NSArray<NSString *> *)sourceTypes
                              maxCount:(NSInteger)maxCount
                         allowsEditing:(BOOL)allowsEditing
                            completion:(void(^ _Nullable)(NSArray<UIImage *> * _Nullable images, NSError * _Nullable error))completion {
    UIViewController *targetVC = viewController ?: [self sud_topViewController];
    if (!targetVC) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"SUDImagePickerHelperErrorDomain"
                                                 code:-100
                                             userInfo:@{NSLocalizedDescriptionKey : @"Cannot find top view controller"}];
            completion(nil, error);
        }
        return;
    }
    
    NSArray<NSString *> *validSourceTypes = [self sud_validSourceTypes:sourceTypes];
    if (validSourceTypes.count == 0) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"SUDImagePickerHelperErrorDomain"
                                                 code:-101
                                             userInfo:@{NSLocalizedDescriptionKey : @"sourceTypes is empty or invalid"}];
            completion(nil, error);
        }
        return;
    }
    
    SUDOPWCKImagePickerHelper *helper = [[SUDOPWCKImagePickerHelper alloc] init];
    helper.presentViewController = targetVC;
    helper.sourceTypes = validSourceTypes;
    helper.maxCount = maxCount > 0 ? maxCount : 1;
    helper.allowsEditing = allowsEditing;
    helper.completion = completion;
    
    objc_setAssociatedObject(targetVC,
                             @selector(chooseImagesFromViewController:sourceTypes:maxCount:allowsEditing:completion:),
                             helper,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [helper startChoose];
}

#pragma mark - Start

- (void)startChoose {
    if (self.sourceTypes.count == 1) {
        NSString *type = self.sourceTypes.firstObject;
        if ([type isEqualToString:SUDImageSourceTypeCamera]) {
            [self chooseFromCamera];
            return;
        }
        if ([type isEqualToString:SUDImageSourceTypeAlbum]) {
            [self chooseFromPhotoLibrary];
            return;
        }
    }
    
    [self showImageSourceSheet];
}

#pragma mark - SourceTypes

+ (NSArray<NSString *> *)sud_validSourceTypes:(NSArray<NSString *> *)sourceTypes {
    NSMutableArray<NSString *> *array = [NSMutableArray array];
    for (NSString *type in sourceTypes) {
        if (![type isKindOfClass:[NSString class]]) {
            continue;
        }
        if ([type isEqualToString:SUDImageSourceTypeAlbum] ||
            [type isEqualToString:SUDImageSourceTypeCamera]) {
            if (![array containsObject:type]) {
                [array addObject:type];
            }
        }
    }
    return array.copy;
}

#pragma mark - Present

- (void)presentController:(UIViewController *)controller {
    UIViewController *targetVC = self.presentViewController ?: [SUDOPWCKImagePickerHelper sud_topViewController];
    targetVC = [SUDOPWCKImagePickerHelper sud_topViewControllerFrom:targetVC];
    
    if (!targetVC || !targetVC.view.window) {
        [self callbackWithImages:nil error:[self errorWithMessage:@"Cannot present controller"]];
        return;
    }
    
    [targetVC presentViewController:controller animated:YES completion:nil];
}

#pragma mark - ActionSheet

- (void)showImageSourceSheet {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    
    if ([self.sourceTypes containsObject:SUDImageSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(__unused UIAlertAction * _Nonnull action) {
            [weakSelf chooseFromCamera];
        }];
        [alert addAction:cameraAction];
    }
    
    if ([self.sourceTypes containsObject:SUDImageSourceTypeAlbum]) {
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从手机相册选择"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(__unused UIAlertAction * _Nonnull action) {
            [weakSelf chooseFromPhotoLibrary];
        }];
        [alert addAction:albumAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(__unused UIAlertAction * _Nonnull action) {
            [weakSelf callbackWithImages:nil error:[weakSelf errorWithMessage:@"User cancelled"]];
        }];
    [alert addAction:cancelAction];
    
    UIPopoverPresentationController *popover = alert.popoverPresentationController;
    if (popover) {
        UIViewController *targetVC = self.presentViewController ?: [SUDOPWCKImagePickerHelper sud_topViewController];
        targetVC = [SUDOPWCKImagePickerHelper sud_topViewControllerFrom:targetVC];
        popover.sourceView = targetVC.view;
        popover.sourceRect = CGRectMake(CGRectGetMidX(targetVC.view.bounds),
                                        CGRectGetMidY(targetVC.view.bounds),
                                        1,
                                        1);
        popover.permittedArrowDirections = 0;
    }
    
    [self presentController:alert];
}

#pragma mark - Camera

- (void)chooseFromCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        [self presentCameraPicker];
    } else if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [self presentCameraPicker];
                } else {
                    [self callbackWithImages:nil error:[self errorWithMessage:@"Camera permission denied"]];
                }
            });
        }];
    } else {
        [self callbackWithImages:nil error:[self errorWithMessage:@"Camera permission denied"]];
    }
}

- (void)presentCameraPicker {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self callbackWithImages:nil error:[self errorWithMessage:@"Camera is not available"]];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing = self.allowsEditing;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentController:picker];
}

#pragma mark - Photo Library

- (void)chooseFromPhotoLibrary {
    if (@available(iOS 14, *)) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
        if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited) {
            [self presentPhotoLibraryPicker];
        } else if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited) {
                        [self presentPhotoLibraryPicker];
                    } else {
                        [self callbackWithImages:nil error:[self errorWithMessage:@"Photo library permission denied"]];
                    }
                });
            }];
        } else {
            [self callbackWithImages:nil error:[self errorWithMessage:@"Photo library permission denied"]];
        }
    } else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized) {
            [self presentPhotoLibraryPicker];
        } else if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        [self presentPhotoLibraryPicker];
                    } else {
                        [self callbackWithImages:nil error:[self errorWithMessage:@"Photo library permission denied"]];
                    }
                });
            }];
        } else {
            [self callbackWithImages:nil error:[self errorWithMessage:@"Photo library permission denied"]];
        }
    }
}

- (void)presentPhotoLibraryPicker {
    if (@available(iOS 14, *)) {
        PHPickerConfiguration *config = [[PHPickerConfiguration alloc] init];
        config.selectionLimit = self.maxCount;
        config.filter = [PHPickerFilter imagesFilter];
        
        PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:config];
        picker.delegate = self;
        [self presentController:picker];
        return;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self callbackWithImages:nil error:[self errorWithMessage:@"Photo library is not available"]];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = self.allowsEditing;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentController:picker];
}

#pragma mark - PHPicker Delegate

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14)) {
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) return;
        
        if (results.count == 0) {
            [self callbackWithImages:nil error:[self errorWithMessage:@"User cancelled"]];
            return;
        }
        
        dispatch_group_t group = dispatch_group_create();
        NSMutableArray<UIImage *> *images = [NSMutableArray array];
        __block NSError *loadError = nil;
        
        for (PHPickerResult *result in results) {
            NSItemProvider *provider = result.itemProvider;
            if (![provider canLoadObjectOfClass:[UIImage class]]) {
                continue;
            }
            
            dispatch_group_enter(group);
            [provider loadObjectOfClass:[UIImage class] completionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                @synchronized (images) {
                    if (image) {
                        [images addObject:image];
                    } else if (!loadError) {
                        loadError = error ?: [self errorWithMessage:@"Failed to load image"];
                    }
                }
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (images.count > 0) {
                [self callbackWithImages:images.copy error:nil];
            } else {
                [self callbackWithImages:nil error:loadError ?: [self errorWithMessage:@"No valid images"]];
            }
        });
    }];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = nil;
    if (self.allowsEditing) {
        image = info[UIImagePickerControllerEditedImage];
    }
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (image) {
            [self callbackWithImages:@[image] error:nil];
        } else {
            [self callbackWithImages:nil error:[self errorWithMessage:@"Failed to get image"]];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self callbackWithImages:nil error:[self errorWithMessage:@"User cancelled"]];
    }];
}

#pragma mark - Callback

- (void)callbackWithImages:(NSArray<UIImage *> * _Nullable)images
                     error:(NSError * _Nullable)error {
    if (self.completion) {
        self.completion(images, error);
    }
    
    UIViewController *targetVC = self.presentViewController;
    if (targetVC) {
        objc_setAssociatedObject(targetVC,
                                 @selector(chooseImagesFromViewController:sourceTypes:maxCount:allowsEditing:completion:),
                                 nil,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (NSError *)errorWithMessage:(NSString *)message {
    return [NSError errorWithDomain:@"SUDImagePickerHelperErrorDomain"
                               code:-1
                           userInfo:@{NSLocalizedDescriptionKey : message ?: @"Unknown error"}];
}

#pragma mark - Top ViewController

+ (UIViewController *)sud_topViewController {
    UIWindow *keyWindow = nil;
    
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) {
                continue;
            }
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            if (windowScene.activationState != UISceneActivationStateForegroundActive) {
                continue;
            }
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    keyWindow = window;
                    break;
                }
            }
            if (keyWindow) {
                break;
            }
        }
    } else {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
    }
    
    UIViewController *rootVC = keyWindow.rootViewController;
    return [self sud_topViewControllerFrom:rootVC];
}

+ (UIViewController *)sud_topViewControllerFrom:(UIViewController *)viewController {
    if (!viewController) {
        return nil;
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *topVC = ((UINavigationController *)viewController).topViewController;
        return [self sud_topViewControllerFrom:topVC];
    }
    
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedVC = ((UITabBarController *)viewController).selectedViewController;
        return [self sud_topViewControllerFrom:selectedVC];
    }
    
    if (viewController.presentedViewController) {
        return [self sud_topViewControllerFrom:viewController.presentedViewController];
    }
    
    return viewController;
}

@end


