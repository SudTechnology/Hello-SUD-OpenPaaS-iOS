//
//  SUDDemoInterstitialAdView.h
//  HelloSud-iOS
//
//  Created by kaniel on 4/27/26.
//

// SUDDemoInterstitialAdView.h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SUDDemoInterstitialAdView;

@protocol SUDDemoInterstitialAdViewDelegate <NSObject>
@optional
- (void)interstitialAdDidLoad:(SUDDemoInterstitialAdView *)adView;
- (void)interstitialAdDidFailToLoad:(SUDDemoInterstitialAdView *)adView error:(NSError *)error;
- (void)interstitialAdDidPresent:(SUDDemoInterstitialAdView *)adView;
- (void)interstitialAdDidDismiss:(SUDDemoInterstitialAdView *)adView;
- (void)interstitialAdDidClick:(SUDDemoInterstitialAdView *)adView;
@end
/// 插页广告
@interface SUDDemoInterstitialAdView : UIView

@property (nonatomic, weak) id<SUDDemoInterstitialAdViewDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isAdLoaded;

- (void)loadAd;
- (void)showAdFromViewController:(UIViewController *)viewController;
- (void)showAdFromViewController:(UIViewController *)viewController withCompletion:(void(^ _Nullable)(BOOL success))completion;
- (void)dismissAd;
@end

NS_ASSUME_NONNULL_END
