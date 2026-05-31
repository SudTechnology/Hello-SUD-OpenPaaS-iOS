//
//  InterstitialAdHandler.m
//  HelloSud-iOS
//
//  Created by kaniel on 4/28/26.
//

#import "InterstitialAdHandler.h"
#import "SUDDemoInterstitialAdView.h"

@interface InterstitialAdHandler()<SUDOPAdDelegate,SUDDemoInterstitialAdViewDelegate>
@property(nonatomic, strong)SUDOPInterstitialAd *ad;
@property(nonatomic, strong)SUDDemoInterstitialAdView *adView;
@property(nonatomic, weak)UIViewController *viewController;
@end

@implementation InterstitialAdHandler

- (void)cleanup {
    if (self.adView) {
        [self.adView removeFromSuperview];
    }
}

- (void)createWithAd:(SUDOPInterstitialAd *)interstitialAd viewController:(UIViewController *)viewController {
    self.ad = interstitialAd;
    self.viewController = viewController;
    
    interstitialAd.delegate = self;
    self.adView = [[SUDDemoInterstitialAdView alloc]init];
    self.adView.delegate = self;
    [self.adView loadAd];
}



- (void)sudopAdShow:(SUDOPInterstitialAd *)interstitialAd {
    [self.adView showAdFromViewController:self.viewController];
    
}
- (void)sudopAdHide:(SUDOPInterstitialAd *)interstitialAd {
    [self.adView dismissAd];
    
}
- (void)sudopAdDestroy:(SUDOPInterstitialAd *)interstitialAd {
    [self.adView removeFromSuperview];
    self.ad = nil;
    self.adView = nil;
}

- (void)interstitialAdDidLoad:(SUDDemoInterstitialAdView *)adView{
    [self.ad notifyDidLoad];
}
- (void)interstitialAdDidFailToLoad:(SUDDemoInterstitialAdView *)adView error:(NSError *)error {
    [self.ad notifyError:error];
}
- (void)interstitialAdDidPresent:(SUDDemoInterstitialAdView *)adView {
    [self.ad notifyDidShow];
}
- (void)interstitialAdDidDismiss:(SUDDemoInterstitialAdView *)adView {
    [self.ad notifyDidClose];
}
- (void)interstitialAdDidClick:(SUDDemoInterstitialAdView *)adView{
    [self.ad notifyDidClickWithCode:0 msg:@""];
}

@end
