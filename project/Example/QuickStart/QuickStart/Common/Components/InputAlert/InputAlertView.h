//
//  InputAlertView.h
//  HelloSudTest-iOS
//
//  Created by kaniel on 4/23/26.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface InputAlertView : UIView

/**
 显示输入弹窗
 
 @param title 弹窗标题
 @param placeholder 输入框占位文字
 @param confirmHandler 确认回调，返回输入的内容
 */
+ (void)showWithTitle:(NSString *)title
          placeholder:(NSString *)placeholder
       confirmHandler:(void(^)(NSString *inputText))confirmHandler;

/**
 显示输入弹窗（带取消按钮回调）
 
 @param title 弹窗标题
 @param placeholder 输入框占位文字
 @param confirmHandler 确认回调
 @param cancelHandler 取消回调
 */
+ (void)showWithTitle:(NSString *)title
          placeholder:(NSString *)placeholder
       confirmHandler:(void(^)(NSString *inputText))confirmHandler
        cancelHandler:(nullable void(^)(void))cancelHandler;

/**
 关闭弹窗
 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
