//
//  SUDOPDefaultToast.h
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/13/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKToast : UIView

/// Shows a loading toast.
+ (instancetype)showLoadingInView:(UIView *)view
                             text:(nullable NSString *)text
                             mask:(BOOL)mask;

/// Shows a success toast.
+ (instancetype)showSuccessInView:(UIView *)view
                             text:(nullable NSString *)text
                             mask:(BOOL)mask;

/// Shows a success toast with an optional custom image.
+ (instancetype)showSuccessInView:(UIView *)view
                             text:(nullable NSString *)text
                            image:(nullable UIImage *)image
                             mask:(BOOL)mask;

/// Hides the toast.
- (void)hide;

/// Hides the toast after the specified delay.
- (void)hideAfterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END

