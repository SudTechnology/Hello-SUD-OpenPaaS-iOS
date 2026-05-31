//
//  SUDDemoCustomAdView.h
//  HelloSud-iOS
//
//  Created by kaniel on 4/27/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SUDDemoCustomAdView;

@protocol SUDDemoCustomAdViewDelegate <NSObject>
@optional
/// 广告加载成功
- (void)customAdViewDidLoad:(SUDDemoCustomAdView *)adView;

/// 广告加载失败
- (void)customAdView:(SUDDemoCustomAdView *)adView didFailWithError:(NSError *)error;

/// 广告点击
- (void)customAdViewDidClick:(SUDDemoCustomAdView *)adView;

/// 广告关闭
- (void)customAdViewDidClose:(SUDDemoCustomAdView *)adView;

/// 广告展示
- (void)customAdViewDidShow:(SUDDemoCustomAdView *)adView;

@end

@interface SUDDemoCustomAdView : UIView

/// 代理
@property (nonatomic, weak) id<SUDDemoCustomAdViewDelegate> delegate;

/// 广告是否已加载
@property (nonatomic, assign, readonly) BOOL isAdLoaded;

/// 广告位ID
@property (nonatomic, copy, readonly) NSString *adUnitId;

/**
 * 初始化自定义广告
 * @param adUnitId 广告位ID
 */
- (instancetype)initWithAdUnitId:(NSString *)adUnitId;

/**
 * 加载广告
 */
- (void)loadAd;

/**
 * 显示广告（默认全屏居中模式，带遮罩）
 * @param viewController 用于展示广告的控制器
 */
- (void)showAdFromViewController:(UIViewController *)viewController;

/**
 * 显示广告（指定位置，无遮罩浮层模式）
 * @param viewController 用于展示广告的控制器
 * @param origin 广告视图的起始位置（相对于viewController的view）
 */
- (void)showAdFromViewController:(UIViewController *)viewController atOrigin:(CGPoint)origin;

/**
 * 显示广告（自定义frame）
 * @param viewController 用于展示广告的控制器
 * @param frame 广告视图的frame
 */
- (void)showAdFromViewController:(UIViewController *)viewController withFrame:(CGRect)frame;

/**
 * 关闭广告
 */
- (void)closeAd;

/**
 * 设置广告数据（自定义广告内容）
 * @param data 广告数据字典
 */
- (void)setAdData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
