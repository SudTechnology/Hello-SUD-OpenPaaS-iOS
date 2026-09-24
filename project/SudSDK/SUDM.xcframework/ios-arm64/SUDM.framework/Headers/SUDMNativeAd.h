
#import <UIKit/UIKit.h>
#import "SUDMNativeView.h"

#import "SUDMPayRevenueDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SUDMNativeAdDelegate;

@interface SUDMNativeAd : NSObject

//- (instancetype)initWithInfoData:(NSData *)data delegate:(id <SUDMNativeAdDelegate>)delegate;
- (instancetype)initWithAdUnitID:(nonnull NSString *)adUnitID delegate:(id <SUDMNativeAdDelegate>)delegate;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


- (BOOL)isReady;
- (void)loadAd;
- (void)renderWithNativeView:(SUDMNativeView *)nativeView;
- (void)destroyAd;

@property (nonatomic,readonly)NSString *name;
@property (nonatomic,weak)id<SUDMPayRevenueDelegate> revenueDelegate;
@property (nonatomic,weak)UIViewController *rootViewController;
@end

@protocol SUDMNativeAdDelegate <NSObject>

- (void)nativeDidLoad:(SUDMNativeAd *)ad;
- (void)nativeLoadFail:(SUDMNativeAd *)ad withError:(NSError *)error;
- (void)nativeDidShow:(SUDMNativeAd *)ad;
- (void)nativeShowFail:(nullable SUDMNativeAd *)ad withError:(NSError *)error;
- (void)nativeDidClick:(SUDMNativeAd *)ad;

@end

NS_ASSUME_NONNULL_END
