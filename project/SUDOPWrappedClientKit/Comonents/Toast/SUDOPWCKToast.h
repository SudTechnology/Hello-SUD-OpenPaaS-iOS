//
//  SUDOPDefaultToast.h
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/13/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKToast : UIView

/// 显示 loading
+ (instancetype)showLoadingInView:(UIView *)view
                             text:(nullable NSString *)text
                             mask:(BOOL)mask;

/// 显示成功
+ (instancetype)showSuccessInView:(UIView *)view
                             text:(nullable NSString *)text
                             mask:(BOOL)mask;

/// 显示成功（支持自定义图片）
+ (instancetype)showSuccessInView:(UIView *)view
                             text:(nullable NSString *)text
                            image:(nullable UIImage *)image
                             mask:(BOOL)mask;

/// 隐藏
- (void)hide;

/// 延迟隐藏
- (void)hideAfterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END


