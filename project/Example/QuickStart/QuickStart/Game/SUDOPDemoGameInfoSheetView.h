//
//  SUDOPDemoGameInfoSheetView.h
//  HelloSud-iOS
//
//  Created by kaniel on 5/30/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPDemoGameInfoSheetView : UIView

@property (nonatomic, copy, nullable) void(^reenterBlock)(void);
@property (nonatomic, copy, nullable) void(^gameInfoBlock)(void);
@property (nonatomic, copy, nullable) void(^dismissBlock)(void);

/// 设置本地图标
- (void)setGameIcon:(nullable UIImage *)image;

/// 设置网络图标
- (void)setGameIconURLString:(nullable NSString *)iconURLString placeholderImage:(nullable UIImage *)placeholderImage;

/// 设置游戏名称
- (void)setGameName:(nullable NSString *)gameName;

/// 设置企业名称
- (void)setCompanyName:(nullable NSString *)companyName;

/// 自定义按钮图标
- (void)setReenterButtonImage:(nullable UIImage *)image;
- (void)setGameInfoButtonImage:(nullable UIImage *)image;

/// 展示
- (void)showInView:(UIView *)superView;

/// 消失
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
