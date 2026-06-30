//
//  SUDOPWCKInterfaceOrientationHelper.m
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 6/17/26.
//

#import "SUDOPWCKInterfaceOrientationHelper.h"

@implementation SUDOPWCKInterfaceOrientationHelper
+ (void)rotateToOrientation:(UIInterfaceOrientation)orientation
             viewController:(UIViewController *)viewController
               errorHandler:(void(^_Nullable)(NSError *error))errorHandler
{
    if (@available(iOS 16.0, *)) {
        UIWindowScene *windowScene = nil;

        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive &&
                [scene isKindOfClass:UIWindowScene.class]) {
                windowScene = (UIWindowScene *)scene;
                break;
            }
        }

        if (!windowScene) {
            return;
        }

        UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskPortrait;

        switch (orientation) {
            case UIInterfaceOrientationPortrait:
                mask = UIInterfaceOrientationMaskPortrait;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                mask = UIInterfaceOrientationMaskLandscapeLeft;
                break;
            case UIInterfaceOrientationLandscapeRight:
                mask = UIInterfaceOrientationMaskLandscapeRight;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                mask = UIInterfaceOrientationMaskPortraitUpsideDown;
                break;
            default:
                break;
        }

        UIWindowSceneGeometryPreferencesIOS *preferences =
        [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:mask];

        [windowScene requestGeometryUpdateWithPreferences:preferences
                                            errorHandler:^(NSError * _Nonnull error) {
            if (errorHandler) {
                errorHandler(error);
            }
        }];

        [viewController setNeedsUpdateOfSupportedInterfaceOrientations];

    } else {
        NSNumber *orientationValue = @(orientation);
        [[UIDevice currentDevice] setValue:orientationValue forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
    }
}
@end
