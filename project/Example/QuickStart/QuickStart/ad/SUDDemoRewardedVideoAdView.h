//
//  SUDDemoRewardedVideoAdView.h
//  HelloSud-iOS
//
//  Created by kaniel on 4/29/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SUDDemoRewardedVideoAdView;

@protocol SUDDemoRewardedVideoAdViewDelegate <NSObject>
@optional

/// 广告加载成功
- (void)rewardedVideoAdDidLoad:(SUDDemoRewardedVideoAdView *)adView;

/// 广告加载失败
- (void)rewardedVideoAd:(SUDDemoRewardedVideoAdView *)adView didFailWithError:(NSError *)error;

/// 广告展示成功
- (void)rewardedVideoAdDidShow:(SUDDemoRewardedVideoAdView *)adView;

/// 广告点击
- (void)rewardedVideoAdDidClick:(SUDDemoRewardedVideoAdView *)adView;

/// 广告关闭
/// @param isRewarded 是否完整观看并给予奖励
- (void)rewardedVideoAdDidClose:(SUDDemoRewardedVideoAdView *)adView isRewarded:(BOOL)isRewarded;

@end

@interface SUDDemoRewardedVideoAdView : UIView

/// 代理
@property (nonatomic, weak) id<SUDDemoRewardedVideoAdViewDelegate> delegate;

/// 广告是否已加载
@property (nonatomic, assign, readonly) BOOL isAdLoaded;

/// 是否正在播放
@property (nonatomic, assign, readonly) BOOL isPlaying;

/// 广告位ID
@property (nonatomic, copy, readonly) NSString *adUnitId;

/**
 * 初始化激励视频广告
 * @param adUnitId 广告位ID
 */
- (instancetype)initWithAdUnitId:(NSString *)adUnitId;

/**
 * 加载广告（模拟 wx.createRewardedVideoAd + load）
 */
- (void)loadAd;

/**
 * 显示广告（模拟 show 方法）
 * @param viewController 用于展示广告的控制器
 */
- (void)showAdFromViewController:(UIViewController *)viewController;

/**
 * 显示广告（带奖励回调）
 * @param viewController 用于展示广告的控制器
 * @param rewardCompletion 奖励回调（完整观看后调用）
 */
- (void)showAdFromViewController:(UIViewController *)viewController
                rewardCompletion:(nullable void(^)(void))rewardCompletion;

/**
 * 关闭广告
 */
- (void)closeAd;

/**
 * 销毁广告
 */
- (void)destroy;

/**
 * 设置广告数据（自定义广告内容）
 * @param data 广告数据字典（包含title、description、videoUrl等）
 */
- (void)setAdData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
