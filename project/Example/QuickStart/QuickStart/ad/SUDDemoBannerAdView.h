//
//  SUDDemoBannerView.h
//  HelloSud-iOS
//
//  Created by kaniel on 4/13/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SUDDemoBannerAdView;

@protocol SUDDemoBannerAdViewDelegate <NSObject>
@optional

/// 广告加载成功
- (void)bannerAdViewDidLoad:(SUDDemoBannerAdView *)adView;

/// 广告加载失败
- (void)bannerAdView:(SUDDemoBannerAdView *)adView didFailWithError:(NSError *)error;

/// 广告点击
- (void)bannerAdViewDidClick:(SUDDemoBannerAdView *)adView;

/// 广告关闭
- (void)bannerAdViewDidClose:(SUDDemoBannerAdView *)adView;

/// 广告展示
- (void)bannerAdViewDidShow:(SUDDemoBannerAdView *)adView;

@end

@interface SUDDemoBannerAdView : UIView

/// 代理
@property (nonatomic, weak) id<SUDDemoBannerAdViewDelegate> delegate;

/// 广告是否已加载
@property (nonatomic, assign, readonly) BOOL isAdLoaded;

/// 广告位ID
@property (nonatomic, copy, readonly) NSString *adUnitId;

/// 是否显示关闭按钮
@property (nonatomic, assign) BOOL showCloseButton;

/// 广告背景颜色
@property (nonatomic, strong) UIColor *adBackgroundColor;

/// 标题文字
@property (nonatomic, copy) NSString *titleText;

/// 描述文字
@property (nonatomic, copy) NSString *descriptionText;

/// 按钮文字
@property (nonatomic, copy) NSString *buttonText;

/// 图标图片（可以是UIImage或网络图片URL）
@property (nonatomic, strong) id iconImage;

/**
 * 初始化横幅广告
 * @param adUnitId 广告位ID
 */
- (instancetype)initWithAdUnitId:(NSString *)adUnitId;

/**
 * 加载广告
 */
- (void)loadAd;

/**
 * 在指定视图中显示广告（默认顶部）
 * @param parentView 父视图
 */
- (void)showInView:(UIView *)parentView;

/**
 * 在指定位置显示广告
 * @param parentView 父视图
 * @param position 位置（顶部/底部/自定义）
 */
- (void)showInView:(UIView *)parentView atPosition:(CGPoint)position size:(CGSize)size;

/**
 * 关闭广告
 */
- (void)closeAd;

/**
 * 设置广告数据
 * @param data 广告数据字典
 */
- (void)setAdData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END

