//
//  SUDOPDefaultWrappedClient.m
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/13/26.
//

#import "SUDOPWCKDefaultWrappedClient.h"

#import "SUDOPWCKPhotoHelper.h"
#import "SUDOPWCKImagePickerHelper.h"
#import "SUDOPWCKImageFileHelper.h"
#import "SUDOPWCKChooseImageResult.h"
#import "SUDOPWCKToast.h"
#import "SUDOPWCKPermissionHelper.h"
#import "SUDOPWCKActionSheet.h"
#import "SUDOPWCKActionSheetResult.h"
#import "SUDOPWCKModalView.h"
#import "SUDOPWCKPreviewImageViewController.h"
#import "SUDOPWCKShowModalResult.h"

@interface SUDOPWCKDefaultWrappedClient()
@property(nonatomic, weak)SUDOPWCKToast *toast;

@end

@implementation SUDOPWCKDefaultWrappedClient
- (void)saveImageToPhotosAlbum:(id<SUDOPStateHandle>)stateHandle options:(SUDOPSaveImageToPhotosAlbumOptions *)options {
    if (options.filePath.length == 0) {
        [stateHandle failure:[SUDOPWCKCommon errorWithCode:-1 msg:@"file path is empty"]];
        return;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:options.filePath];
    [SUDOPWCKPhotoHelper saveImageToPhotosAlbum:image completion:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            [stateHandle failure:error];
            return;
        }
        [stateHandle success:@""];
    }];
}

- (void)chooseImage:(id<SUDOPStateHandle>)stateHandle options:(SUDOPChooseImageOptions *)options {
    [SUDOPWCKImagePickerHelper chooseImagesFromViewController:self.viewController
                                                  sourceTypes:options.sourceType
                                                     maxCount:options.count
                                                allowsEditing:NO
                                                   completion:^(NSArray<UIImage *> * _Nullable images, NSError * _Nullable error) {
        
        if (error) {
            [stateHandle failure:error];
            return;
        }
        BOOL bCompressed = NO;
        for (NSString *item in options.sizeType) {
            if ([item isEqualToString:kSUDOPImageSizeTypeCompressed]) {
                bCompressed = YES;
                break;
            }
        }
        NSMutableArray *tempFilePaths = [[NSMutableArray alloc]init];
        for (UIImage *image in images) {
            
            NSError *error = nil;
            
            NSString *filePath = [SUDOPWCKImageFileHelper saveJPEGImageToTemporaryDirectory:image
                                                                         compressionQuality:bCompressed ? 0.8 : 1.0
                                                                                      error:&error];
            if (filePath) {
                NSLog(@"save successfully: %@", filePath);
                [tempFilePaths addObject:filePath];
            } else {
                NSLog(@"save failed: %@", error.localizedDescription);
            }
        }
        SUDOPWCKChooseImageResult *result = [[SUDOPWCKChooseImageResult alloc]init];
        result.tempFilePaths = tempFilePaths;
        [stateHandle success:result.mj_JSONString];
        

    }];

}

- (void)previewImage:(id<SUDOPStateHandle>)stateHandle options:(SUDOPPreviewImageOptions *)options {
    [SUDOPWCKPreviewImageViewController showFromViewController:self.viewController
                                                       current:options.current
                                                          urls:options.urls];
    [stateHandle success:@""];
}

- (void)showLoading:(id<SUDOPStateHandle>)stateHandle options:(SUDOPShowLoadingOptions *)options {
    self.toast = [SUDOPWCKToast showLoadingInView:self.viewController.view text:options.title mask:options.mask];
    [stateHandle success:@""];
}

- (void)hideLoading:(id<SUDOPStateHandle>)stateHandle options:(SUDOPHideLoadingOptions *)options {
    if (self.toast) {
        [self.toast hide];
        self.toast = nil;
    }
    [stateHandle success:@""];
}

- (void)showToast:(id<SUDOPStateHandle>)stateHandle options:(SUDOPShowToastOptions *)options {
    UIImage *image = nil;
    // options image higher than icon
    if (options.image) {
        image = [UIImage imageWithContentsOfFile:options.image];
    } else {
        if ([options.icon isEqualToString:kSUDOPShowToastOptionsIconTypeSuccess]) {
            image = [SUDOPWCKCommon imageWithName:@"success@3x.png"];
        } else if ([options.icon isEqualToString:kSUDOPShowToastOptionsIconTypeFail]) {
            image = [SUDOPWCKCommon imageWithName:@"error@3x.png"];
        }else if ([options.icon isEqualToString:kSUDOPShowToastOptionsIconTypeLoading]) {
            image = [SUDOPWCKCommon imageWithName:@"loading@3x.png"];
        }
    }
     
    self.toast = [SUDOPWCKToast showSuccessInView:self.viewController.view
                                             text:options.title
                                            image:image
                                             mask:options.mask];
    CGFloat duration = 1500;
    if (options.duration > 0) {
        duration = options.duration;
    }
    [self.toast hideAfterDelay:duration/1000.0];
    [stateHandle success:@""];
}

- (void)hideToast:(id<SUDOPStateHandle>)stateHandle options:(SUDOPHideToastOptions *)options {
    if (self.toast) {
        [self.toast hide];
        self.toast = nil;
    }
    [stateHandle success:@""];
}

- (void)onQueryPermission:(id<SUDRTGameQueryPermissionHandle>)handle permission:(NSString *)permission appId:(NSString *)appId authStatus:(SUDRTPermissionAuthStatus)authStatus {
    if ([permission isEqualToString:SUDRT_KEY_PERMISSION_SAVE_TO_ALBUM]) {
        [SUDOPWCKPermissionHelper requestPhotoAddPermission:^(BOOL granted) {
            [handle completeQueryPermission:permission authStatus:granted ? SUD_RT_PERMISSION_AUTH_STATUS_GRANTED : SUD_RT_PERMISSION_AUTH_STATUS_DENIED];
        }];
    } else if ([permission isEqualToString:SUDRT_KEY_PERMISSION_LOCATION]) {
        [SUDOPWCKPermissionHelper requestLocationPermission:^(BOOL granted) {
            [handle completeQueryPermission:permission authStatus:granted ? SUD_RT_PERMISSION_AUTH_STATUS_GRANTED : SUD_RT_PERMISSION_AUTH_STATUS_DENIED];
        }];
    } else if ([permission isEqualToString:SUDRT_KEY_PERMISSION_CAMERA]) {
        [SUDOPWCKPermissionHelper requestCameraPermission:^(BOOL granted) {
            [handle completeQueryPermission:permission authStatus:granted ? SUD_RT_PERMISSION_AUTH_STATUS_GRANTED : SUD_RT_PERMISSION_AUTH_STATUS_DENIED];
        }];
    } else {
        [handle completeQueryPermission:permission authStatus:SUD_RT_PERMISSION_AUTH_STATUS_UNDETERMINED];
    }
}

- (void)beforeQuerySystemPermission:(id<SUDRTGameQuerySystemPermissionHandle>)handle fromJSMethod:(NSString *)methodName permission:(NSString *)permission appId:(NSString *)appId authStatus:(SUDRTSystemPermissionAuthStatus)authStatus serviceStatus:(BOOL)enabled {
    [handle continueQuerySystemPermission:permission];
}

- (void)showActionSheet:(id<SUDOPStateHandle>)stateHandle options:(SUDOPShowActionSheetOptions *)options {
    [SUDOPWCKActionSheet showInViewController:self.viewController
                                    alertText:options.alertText
                                     itemList:options.itemList
                                    itemColor:options.itemColor
                                   completion:^(NSInteger index) {
        SUDOPWCKActionSheetResult *result = [[SUDOPWCKActionSheetResult alloc]init];
        result.tapIndex = index;
        [stateHandle success:result.mj_JSONString];
    }];
}

- (void)showModal:(id<SUDOPStateHandle>)stateHandle options:(SUDOPShowModalOptions *)options {
    SUDOPWCKModalOptions *tempOptions = [SUDOPWCKModalOptions mj_objectWithKeyValues:options.mj_JSONObject];
    [SUDOPWCKModalView showInViewController:self.viewController options:tempOptions cancel:^{
        SUDOPWCKShowModalResult *result = [[SUDOPWCKShowModalResult alloc]init];
        result.cancel = YES;
        [stateHandle success:result.mj_JSONString];
    } confirm:^(NSString * _Nullable inputText) {
        SUDOPWCKShowModalResult *result = [[SUDOPWCKShowModalResult alloc]init];
        result.content = inputText;
        result.confirm = YES;
        [stateHandle success:result.mj_JSONString];
    }];
}
@end
