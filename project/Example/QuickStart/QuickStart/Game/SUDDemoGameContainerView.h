//
//  SUDDemoGameContainerView.h
//  HelloSud-iOS
//
//  Created by kaniel on 5/28/26.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SUDDemoCapsuleView;

@interface SUDDemoGameContainerView : UIView

@property (nonatomic, copy, nullable) void(^leftActionBlock)(void);
@property (nonatomic, copy, nullable) void(^rightActionBlock)(void);

/// 右上角胶囊
@property (nonatomic, strong, readonly) SUDDemoCapsuleView *capsuleView;

/// 内容容器
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIView *gameView;

/// 关闭回调
@property (nonatomic, copy, nullable) void(^dismissBlock)(void);

/// 设置游戏内容视图
- (void)setGameContentView:(UIView *)gameContentView;

/// 显示到指定父视图，从底部弹出
- (void)showInView:(UIView *)superView animated:(BOOL)animated;

/// 从底部退出
- (void)dismissAnimated:(BOOL)animated;
- (CGRect)capsuleViewRect;
@end

NS_ASSUME_NONNULL_END
