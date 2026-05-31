//
//  CustomAdHandler.m
//  HelloSud-iOS
//
//  Created by kaniel on 4/28/26.
//

#import "CustomAdHandler.h"
#import "SUDDemoCustomAdView.h"

@interface CustomAdHandler()<SUDOPAdDelegate,SUDDemoCustomAdViewDelegate>
@property(nonatomic, strong)SUDOPCustomAd *ad;
@property(nonatomic, strong)SUDDemoCustomAdView *customAdView;
@property(nonatomic, weak)UIViewController *viewController;
@end

@implementation CustomAdHandler

- (void)cleanup {
    if (self.customAdView) {
        [self.customAdView removeFromSuperview];
    }
}

- (void)createWithAd:(SUDOPCustomAd *)ad viewController:(UIViewController *)viewController {
    self.ad = ad;
    self.viewController = viewController;
    
    ad.delegate = self;
    SUDDemoCustomAdView *customAdView = [[SUDDemoCustomAdView alloc]init];

    self.customAdView = customAdView;
    self.customAdView.delegate = self;


    [self.customAdView loadAd];
}



- (void)sudopAdShow:(SUDOPCustomAd *)ad {
    self.customAdView.hidden = NO;
    [self.customAdView showAdFromViewController:self.viewController atOrigin:CGPointMake(self.ad.style.left, self.ad.style.top)];
}
- (BOOL)sudopAdIsShow:(SUDOPCustomAd *)ad {
    return self.customAdView.hidden == NO;
}
- (void)sudopAdHide:(SUDOPCustomAd *)ad {
    self.customAdView.hidden = YES;
    [self.ad notifyDidHide];
}
- (void)sudopAdDestroy:(SUDOPCustomAd *)ad{
    [self.customAdView removeFromSuperview];
    self.customAdView = nil;
    self.ad = nil;
}

/// 广告加载成功
- (void)customAdViewDidLoad:(SUDDemoCustomAdView *)adView {
    [self.ad notifyDidLoad];
}

/// 广告加载失败
- (void)customAdView:(SUDDemoCustomAdView *)adView didFailWithError:(NSError *)error {
    [self.ad notifyError:error];
}

/// 广告点击
- (void)customAdViewDidClick:(SUDDemoCustomAdView *)adView {
    [self.ad notifyDidClickWithCode:0 msg:@""];
}

/// 广告关闭
- (void)customAdViewDidClose:(SUDDemoCustomAdView *)adView {
    [self.ad notifyDidClose];
}

/// 广告展示
- (void)customAdViewDidShow:(SUDDemoCustomAdView *)adView {
    [self.ad notifyDidShow];
}

@end
