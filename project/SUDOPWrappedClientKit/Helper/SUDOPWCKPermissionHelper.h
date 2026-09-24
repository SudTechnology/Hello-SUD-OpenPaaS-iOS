//
//  SUDOPWCKPermissionHelper.h
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/24/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKPermissionHelper : NSObject

/// Requests permission to add items to the photo library.
+ (void)requestPhotoAddPermission:(void(^)(BOOL granted))completion;

/// Requests camera access.
+ (void)requestCameraPermission:(void(^)(BOOL granted))completion;

/// Requests microphone access.
+ (void)requestMicrophonePermission:(void(^)(BOOL granted))completion;

/// Requests location access while the app is in use.
+ (void)requestLocationPermission:(void(^)(BOOL granted))completion;

@end

NS_ASSUME_NONNULL_END

