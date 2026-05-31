//
//  SUDDemoBoxAdView.h
//  HelloSud-iOS
//
//  Created by kaniel on 4/28/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 互推盒子广告类型
typedef NS_ENUM(NSInteger, SUDOPBoxAdType) {
    SUDOPBoxAdTypeBanner = 0,      // 横幅广告
    SUDOPBoxAdTypeGrid9,            // 九宫格广告
    SUDOPBoxAdTypeDrawer            // 抽屉广告
};

@class SUDDemoBoxAdView;

@protocol SUDDemoBoxAdViewDelegate <NSObject>
@optional

/// 广告加载成功
- (void)boxAdViewDidLoad:(SUDDemoBoxAdView *)adView;

/// 广告加载失败
- (void)boxAdView:(SUDDemoBoxAdView *)adView didFailWithError:(NSError *)error;

/// 点击了某个广告项
- (void)boxAdView:(SUDDemoBoxAdView *)adView didSelectItemAtIndex:(NSInteger)index;

/// 广告关闭
- (void)boxAdViewDidClose:(SUDDemoBoxAdView *)adView;

/// 抽屉广告展开/收起回调
- (void)boxAdView:(SUDDemoBoxAdView *)adView didChangeDrawerState:(BOOL)isOpen;

@end

@interface SUDDemoBoxAdView : UIView

/// 代理
@property (nonatomic, weak) id<SUDDemoBoxAdViewDelegate> delegate;

/// 广告类型
@property (nonatomic, assign, readonly) SUDOPBoxAdType adType;

/// 广告是否已加载
@property (nonatomic, assign, readonly) BOOL isAdLoaded;

/// 广告位ID
@property (nonatomic, copy, readonly) NSString *adUnitId;

/// 广告数据源
@property (nonatomic, strong, readonly) NSArray<NSDictionary *> *adItems;

/// 是否显示关闭按钮
@property (nonatomic, assign) BOOL showCloseButton;

/// 标题文字
@property (nonatomic, copy) NSString *titleText;

/// 副标题文字（仅横幅广告）
@property (nonatomic, copy) NSString *subtitleText;

/**
 * 初始化互推盒子广告
 * @param adUnitId 广告位ID
 * @param adType 广告类型
 */
- (instancetype)initWithAdUnitId:(NSString *)adUnitId adType:(SUDOPBoxAdType)adType;

/**
 * 加载广告
 */
- (void)loadAd;

/**
 * 在指定视图中显示广告
 * @param parentView 父视图
 */
- (void)showInView:(UIView *)parentView;

/**
 * 在指定位置显示广告
 * @param parentView 父视图
 * @param origin 显示位置
 */
- (void)showInView:(UIView *)parentView atOrigin:(CGPoint)origin;

/**
 * 关闭广告
 */
- (void)closeAd;

/**
 * 设置广告数据（自定义广告内容）
 * @param items 广告项数组，每个元素包含icon、title、desc等
 */
- (void)setAdItems:(NSArray<NSDictionary *> *)items;

// 抽屉广告专用方法
/**
 * 打开抽屉
 */
- (void)openDrawer;

/**
 * 关闭抽屉
 */
- (void)closeDrawer;

/**
 * 切换抽屉状态
 */
- (void)toggleDrawer;

@end

NS_ASSUME_NONNULL_END
