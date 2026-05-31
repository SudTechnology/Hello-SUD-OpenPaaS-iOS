//
//  GameBannerAdHandler.m
//  HelloSud-iOS
//
//  Created by kaniel on 4/28/26.
//

#import "GameBannerAdHandler.h"
#import "SUDDemoBoxAdView.h"

@interface GameBannerAdHandler()<SUDOPAdDelegate,SUDDemoBoxAdViewDelegate>
@property(nonatomic, strong)SUDOPGameBannerAd *ad;
@property(nonatomic, strong)SUDDemoBoxAdView *adView;
@property(nonatomic, weak)UIViewController *viewController;
@end

@implementation GameBannerAdHandler

- (void)cleanup {
    if (self.adView) {
        [self.adView removeFromSuperview];
    }
}

- (void)createBoxBannerAdWithAd:(SUDOPGameBannerAd *)ad viewController:(UIViewController *)viewController {
    self.ad = ad;
    self.viewController = viewController;
    
    ad.delegate = self;
    self.adView = [[SUDDemoBoxAdView alloc]initWithAdUnitId:ad.adUnitId adType:SUDOPBoxAdTypeBanner];
    self.adView.delegate = self;
    [self.adView loadAd];
}


- (void)sudopAdShow:(SUDOPGameBannerAd *)ad {
    [self.adView showInView:self.viewController.view];
    [self.ad notifyDidShow];
}

- (void)sudopAdHide:(SUDOPGameBannerAd *)ad {
    [self.adView closeAd];
    
}

- (void)sudopAdDestroy:(SUDOPGameBannerAd *)ad {
    [self.adView closeAd];
    self.ad = nil;
    [self.adView removeFromSuperview];
    
}


/// 广告加载成功
- (void)boxAdViewDidLoad:(SUDDemoBoxAdView *)adView {
    [self.ad notifyDidLoad];
}

/// 广告加载失败
- (void)boxAdView:(SUDDemoBoxAdView *)adView didFailWithError:(NSError *)error {
    [self.ad notifyError:error];
}

/// 点击了某个广告项
- (void)boxAdView:(SUDDemoBoxAdView *)adView didSelectItemAtIndex:(NSInteger)index {
    [self.ad notifyDidClickWithCode:index msg:@""];
}

/// 广告关闭
- (void)boxAdViewDidClose:(SUDDemoBoxAdView *)adView {
    [self.ad notifyDidClose];
}

/// 抽屉广告展开/收起回调
- (void)boxAdView:(SUDDemoBoxAdView *)adView didChangeDrawerState:(BOOL)isOpen {
    
}

@end
