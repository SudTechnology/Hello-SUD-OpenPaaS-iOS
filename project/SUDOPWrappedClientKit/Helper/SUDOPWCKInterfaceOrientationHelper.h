//
//  SUDOPWCKInterfaceOrientationHelper.h
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 6/17/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKInterfaceOrientationHelper : NSObject
+ (void)rotateToOrientation:(UIInterfaceOrientation)orientation
             viewController:(UIViewController *)viewController
               errorHandler:(void(^_Nullable)(NSError *error))errorHandler;
@end

NS_ASSUME_NONNULL_END
