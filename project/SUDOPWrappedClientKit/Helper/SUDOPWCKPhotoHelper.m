//
//  SUDOPWCKPhotoHelper.m
//  Pods
//
//  Created by kaniel on 5/13/26.
//

#import "SUDOPWCKPhotoHelper.h"
#import <Photos/Photos.h>
#import "SUDOPWCKCommon.h"
@implementation SUDOPWCKPhotoHelper

+ (void)saveImageToPhotosAlbum:(UIImage *)image
                    completion:(void(^ _Nullable)(BOOL success, NSError * _Nullable error))completion {
    if (!image) {
        if (completion) {
            NSError *error = [SUDOPWCKCommon errorWithCode:-1 msg:@"image is nil"];
            completion(NO, error);
        }
        return;
    }
    
    if (@available(iOS 14, *)) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
        if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited) {
            [self saveImage:image completion:completion];
        } else if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelAddOnly handler:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited) {
                        [self saveImage:image completion:completion];
                    } else {
                        if (completion) {
                            NSError *error = [SUDOPWCKCommon errorWithCode:-1 msg:@"photo library permission denied"];
                            completion(NO, error);
                        }
                    }
                });
            }];
        } else {
            if (completion) {
                NSError *error = [SUDOPWCKCommon errorWithCode:-1 msg:@"photo library permission denied"];
                completion(NO, error);
            }
        }
    } else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized) {
            [self saveImage:image completion:completion];
        } else if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        [self saveImage:image completion:completion];
                    } else {
                        if (completion) {
                            NSError *error = [SUDOPWCKCommon errorWithCode:-1 msg:@"photo library permission denied"];
                            completion(NO, error);
                        }
                    }
                });
            }];
        } else {
            if (completion) {
                NSError *error = [SUDOPWCKCommon errorWithCode:-1 msg:@"photo library permission denied"];
                completion(NO, error);
            }
        }
    }
}

+ (void)saveImage:(UIImage *)image
       completion:(void(^ _Nullable)(BOOL success, NSError * _Nullable error))completion {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(success, error);
            }
        });
    }];
}

@end
