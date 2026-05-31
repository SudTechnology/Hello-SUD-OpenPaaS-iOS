//
//  SUDOPWCKPermissionHelper.h
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/24/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKPermissionHelper : NSObject

/// 相册保存权限
+ (void)requestPhotoAddPermission:(void(^)(BOOL granted))completion;

/// 相机权限
+ (void)requestCameraPermission:(void(^)(BOOL granted))completion;

/// 录音权限
+ (void)requestMicrophonePermission:(void(^)(BOOL granted))completion;

/// 位置权限（前台使用）
+ (void)requestLocationPermission:(void(^)(BOOL granted))completion;

@end

NS_ASSUME_NONNULL_END


