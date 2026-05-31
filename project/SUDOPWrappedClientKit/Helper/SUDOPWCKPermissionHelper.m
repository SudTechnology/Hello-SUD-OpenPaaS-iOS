//
//  SUDOPWCKPermissionHelper.m
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/24/26.
//

#import "SUDOPWCKPermissionHelper.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SUDOPWCKLocationPermissionProxy : NSObject <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) void(^completion)(BOOL granted);
@end

@implementation SUDOPWCKLocationPermissionProxy

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return self;
}

- (void)requestPermission {
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager API_AVAILABLE(ios(14.0)) {
    if (self.completion) {
        BOOL granted = (manager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
                        manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse);
        self.completion(granted);
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (self.completion) {
        BOOL granted = (status == kCLAuthorizationStatusAuthorizedAlways ||
                        status == kCLAuthorizationStatusAuthorizedWhenInUse);
        self.completion(granted);
    }
}

@end

@implementation SUDOPWCKPermissionHelper

+ (void)requestPhotoAddPermission:(void(^)(BOOL granted))completion {
    if (@available(iOS 14, *)) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
        if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited) {
            if (completion) {
                completion(YES);
            }
            return;
        }
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelAddOnly handler:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL granted = (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited);
                    if (completion) {
                        completion(granted);
                    }
                });
            }];
            return;
        }
        if (completion) {
            completion(NO);
        }
    } else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized) {
            if (completion) {
                completion(YES);
            }
            return;
        }
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL granted = (status == PHAuthorizationStatusAuthorized);
                    if (completion) {
                        completion(granted);
                    }
                });
            }];
            return;
        }
        if (completion) {
            completion(NO);
        }
    }
}

+ (void)requestCameraPermission:(void(^)(BOOL granted))completion {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        if (completion) {
            completion(YES);
        }
        return;
    }
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(granted);
                }
            });
        }];
        return;
    }
    if (completion) {
        completion(NO);
    }
}

+ (void)requestMicrophonePermission:(void(^)(BOOL granted))completion {
    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
    if (permission == AVAudioSessionRecordPermissionGranted) {
        if (completion) {
            completion(YES);
        }
        return;
    }
    if (permission == AVAudioSessionRecordPermissionUndetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(granted);
                }
            });
        }];
        return;
    }
    if (completion) {
        completion(NO);
    }
}

+ (void)requestLocationPermission:(void(^)(BOOL granted))completion {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        if (completion) {
            completion(YES);
        }
        return;
    }
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        SUDOPWCKLocationPermissionProxy *proxy = [[SUDOPWCKLocationPermissionProxy alloc] init];
        
        static NSMutableArray *proxyHolders;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            proxyHolders = [NSMutableArray array];
        });
        [proxyHolders addObject:proxy];
        
        __weak SUDOPWCKLocationPermissionProxy *weakProxy = proxy;
        proxy.completion = ^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(granted);
                }
                if (weakProxy) {
                    [proxyHolders removeObject:weakProxy];
                }
            });
        };
        
        [proxy requestPermission];
        return;
    }
    
    if (completion) {
        completion(NO);
    }
}

@end


