

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SUDMPayRevenueDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SUDMInterstitialAdDelegate;

@interface SUDMInterstitialAd : NSObject

//- (instancetype)initWithInfoData:(NSData *)data delegate:(id <SUDMInterstitialAdDelegate>)delegate;
- (instancetype)initWithAdUnitID:(nonnull NSString *)adUnitID delegate:(id <SUDMInterstitialAdDelegate>)delegate;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)loadAd;
- (BOOL)isReady;
- (void)showAd:(nullable UIViewController *)viewController;
/// 销毁广告对象及内部 adapter，释放加载与展示状态。
- (void)destroy;

@property (nonatomic,readonly)NSString *name;
@property (nonatomic,weak)id<SUDMPayRevenueDelegate> revenueDelegate;
@end

@protocol SUDMInterstitialAdDelegate <NSObject>

- (void)interstitialDidLoad:(SUDMInterstitialAd *)ad;
- (void)interstitialLoadFailWithError:(NSError *)error;
- (void)interstitialDidShow:(SUDMInterstitialAd *)ad;
- (void)interstitialShowFail:(nullable SUDMInterstitialAd *)ad withError:(NSError *)error;
- (void)interstitialDidClick:(SUDMInterstitialAd *)ad;
- (void)interstitialDidDismiss:(SUDMInterstitialAd *)ad;

@end

NS_ASSUME_NONNULL_END
