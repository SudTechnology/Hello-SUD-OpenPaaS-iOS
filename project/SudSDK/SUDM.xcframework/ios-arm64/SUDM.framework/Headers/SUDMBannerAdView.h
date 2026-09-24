
#import <UIKit/UIKit.h>

#import "SUDMPayRevenueDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SUDMBannerAdViewDelegate;

typedef NS_ENUM(NSInteger,SUDMBannerAdSizeType) {
    SUDMBannerAdSizeType320x50,
    SUDMBannerAdSizeType320x100,
    SUDMBannerAdSizeType300x250
};

@interface SUDMBannerAdView : UIView
@property (nonatomic,assign)BOOL closeAutoShow;
@property (nonatomic,readonly)NSString *name;
@property (nonatomic,weak)id<SUDMPayRevenueDelegate> revenueDelegate;
@property (nonatomic,assign)SUDMBannerAdSizeType bannerAdSizeType;
@property (nonatomic,weak)UIViewController *rootViewController;
/// JS 期望的 Banner 广告尺寸（pt）。加载前用于候选广告源尺寸过滤，未设置（<=0）时不过滤。
/// 属性名沿用历史命名（原表示容器尺寸），语义已改为期望广告尺寸。
@property (nonatomic,assign)CGSize containerSize;

//- (instancetype)initWithInfoData:(NSData *)data delegate:(id <SUDMBannerAdViewDelegate>)delegate;
- (instancetype)initWithAdUnitID:(nonnull NSString *)adUnitID delegate:(id <SUDMBannerAdViewDelegate>)delegate;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


- (void)loadAd;
- (BOOL)isReady;
- (void)showAd;
- (void)hideAd;
- (void)destroy;
- (void)startAutoRefresh;
- (void)stopAutoRefresh;
@end


@protocol SUDMBannerAdViewDelegate <NSObject>

- (void)bannerAdViewDidLoad:(SUDMBannerAdView *)ad;
- (void)bannerAdViewLoadFailWithError:(NSError *)error;
- (void)bannerAdViewDidShow:(SUDMBannerAdView *)ad;
- (void)bannerAdViewShowFail:(nullable SUDMBannerAdView *)ad withError:(NSError *)error;
- (void)bannerAdViewDidClick:(SUDMBannerAdView *)ad;
- (void)bannerAdViewDidClose:(SUDMBannerAdView *)ad;

@optional
/// 广告源确定真实渲染尺寸后回调（pt）。仅 Banner 使用；宽度或高度可能随广告源变化。
- (void)bannerAdView:(SUDMBannerAdView *)ad didResizeWithSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
