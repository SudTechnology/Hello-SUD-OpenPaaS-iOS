

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SUDMPayRevenueDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SUDMRewardedVideoAdDelegate;

@interface SUDMRewardedVideoAd : NSObject

- (instancetype)initWithAdUnitID:(nonnull NSString *)adUnitID delegate:(id <SUDMRewardedVideoAdDelegate>)delegate;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)loadAd;
- (BOOL)isReady;
- (void)showAd:(nullable UIViewController *)viewController;
/// 销毁广告对象及内部 adapter，释放加载与展示状态。
- (void)destroy;

@property (nonatomic,readonly)NSString *name;
@property (nonatomic,copy)NSString *customRewardString;
@property (nonatomic,weak)id<SUDMPayRevenueDelegate> revenueDelegate;
@end

@protocol SUDMRewardedVideoAdDelegate <NSObject>

- (void)rewardedVideoDidLoad:(SUDMRewardedVideoAd *)ad;
- (void)rewardedVideoLoadFail:(SUDMRewardedVideoAd *)ad withError:(NSError *)error;
- (void)rewardedVideoDidShow:(SUDMRewardedVideoAd *)ad;
- (void)rewardedVideoShowFail:(nullable SUDMRewardedVideoAd *)ad withError:(NSError *)error;
- (void)rewardedVideoDidClick:(SUDMRewardedVideoAd *)ad;
- (void)rewardedVideoDidDismiss:(SUDMRewardedVideoAd *)ad;
- (void)rewardedVideoDidEarnReward:(SUDMRewardedVideoAd *)ad rewardInfo:(NSDictionary *)rewardInfo;

@end

NS_ASSUME_NONNULL_END
