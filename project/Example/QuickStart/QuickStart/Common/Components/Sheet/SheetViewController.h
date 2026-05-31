//
//  SheetViewController.h
//  HelloSud-iOS
//
//  Created by kaniel on 4/18/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 操作项模型
@interface SheetAction : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;
/// 标题颜色（默认黑色）
@property (nonatomic, strong) UIColor *titleColor;
/// 字体（默认系统字体17号）
@property (nonatomic, strong) UIFont *font;
/// 图标（可选）
@property (nonatomic, strong, nullable) UIImage *icon;
/// 是否高亮样式（红色）
@property (nonatomic, assign) BOOL isDestructive;
/// 自定义数据（方便传递额外信息）
@property (nonatomic, strong, nullable) id userInfo;

/// 便捷初始化方法
+ (instancetype)actionWithTitle:(NSString *)title;

@end

/// Sheet弹窗控制器
@interface SheetViewController : UIViewController

/// 标题（可选）
@property (nonatomic, copy, nullable) NSString *sheetTitle;
/// 消息/描述（可选）
@property (nonatomic, copy, nullable) NSString *message;
/// 取消按钮标题（默认"取消"）
@property (nonatomic, copy) NSString *cancelButtonTitle;
/// 点击空白区域是否关闭（默认YES）
@property (nonatomic, assign) BOOL dismissOnTapBackground;
/// 圆角半径（默认20）
@property (nonatomic, assign) CGFloat cornerRadius;

/// 显示Sheet弹窗
/// @param viewController 在哪个控制器上展示
/// @param actions 操作列表
/// @param completion 选中后的回调（action为nil表示点击取消或空白区域关闭）
+ (void)showInViewController:(UIViewController *)viewController
                     actions:(NSArray<SheetAction *> *)actions
                  completion:(void(^)(SheetAction * _Nullable action))completion;

/// 显示带标题和消息的Sheet弹窗
/// @param viewController 在哪个控制器上展示
/// @param title 标题
/// @param message 消息
/// @param actions 操作列表
/// @param completion 选中后的回调
+ (void)showInViewController:(UIViewController *)viewController
                       title:(NSString * _Nullable)title
                     message:(NSString * _Nullable)message
                     actions:(NSArray<SheetAction *> *)actions
                  completion:(void(^)(SheetAction * _Nullable action))completion;

@end

NS_ASSUME_NONNULL_END
