//
//  BannerAdHandler.m
//  HelloSud-iOS
//
//  Created by kaniel on 4/28/26.
//

#import "BannerAdHandler.h"
#import "SUDDemoBannerAdView.h"

@interface BannerAdHandler()<SUDOPAdDelegate,SUDDemoBannerAdViewDelegate>
@property(nonatomic, strong)SUDOPBannerAd *bannerAd;
@property(nonatomic, strong)SUDDemoBannerAdView *bannerView;
@property(nonatomic, weak)UIViewController *viewController;
@end

@implementation BannerAdHandler

- (void)cleanup {
    if (self.bannerView) {
        [self.bannerView removeFromSuperview];
    }
}

- (void)createWithAd:(SUDOPBannerAd *)bannerAd viewController:(UIViewController *)viewController {
    self.bannerAd = bannerAd;
    self.viewController = viewController;

    self.bannerAd = bannerAd;
    bannerAd.delegate = self;
    SUDDemoBannerAdView *bannerView = [[SUDDemoBannerAdView alloc]init];
    bannerView.delegate = self;
    self.bannerView = bannerView;
    [self.bannerView loadAd];
}


- (void)sudopAdDestroy:(nonnull SUDOPBannerAd *)bannerAd {
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
    self.bannerAd = nil;
}

- (void)sudopAdHide:(nonnull SUDOPBannerAd *)bannerAd {
    [self.bannerView closeAd];
}

- (void)sudopAdShow:(nonnull SUDOPBannerAd *)bannerAd {
    [self.bannerView showInView:self.viewController.view
                     atPosition:CGPointMake(self.bannerAd.style.left, self.bannerAd.style.top)
                           size:CGSizeMake(self.bannerAd.style.width, self.bannerAd.style.height)];
}


/// 广告加载成功
- (void)bannerAdViewDidLoad:(SUDDemoBannerAdView *)adView {
    [self.bannerAd notifyDidLoad];
}

/// 广告加载失败
- (void)bannerAdView:(SUDDemoBannerAdView *)adView didFailWithError:(NSError *)error {
    [self.bannerAd notifyError:error];
}

/// 广告点击
- (void)bannerAdViewDidClick:(SUDDemoBannerAdView *)adView {
    [self.bannerAd notifyDidClickWithCode:0 msg:@""];
}

/// 广告关闭
- (void)bannerAdViewDidClose:(SUDDemoBannerAdView *)adView {
    [self.bannerAd notifyDidClose];
}

/// 广告展示
- (void)bannerAdViewDidShow:(SUDDemoBannerAdView *)adView {
    [self.bannerAd notifyDidShow];
}

@end
