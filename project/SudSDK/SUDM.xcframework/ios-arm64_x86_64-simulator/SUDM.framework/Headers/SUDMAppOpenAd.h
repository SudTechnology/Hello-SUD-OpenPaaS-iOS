

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SUDMPayRevenueDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SUDMAppOpenAdDelegate;

@interface SUDMAppOpenAd : NSObject
@property (nonatomic,readonly)NSString *name;
@property (nonatomic,weak)id<SUDMPayRevenueDelegate> revenueDelegate;

//- (instancetype)initWithInfoData:(NSData *)data delegate:(id <SUDMAppOpenAdDelegate>)delegate;
- (instancetype)initWithAdUnitID:(nonnull NSString *)adUnitID delegate:(id <SUDMAppOpenAdDelegate>)delegate;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


- (void)loadAd;
- (BOOL)isReady;
- (void)showAd:(nullable UIViewController *)viewController;
/// 销毁广告对象及内部 adapter，释放加载与展示状态。
- (void)destroy;

@end

@protocol SUDMAppOpenAdDelegate <NSObject>

- (void)appOpenDidLoad:(SUDMAppOpenAd *)ad;
- (void)appOpenLoadFailWithError:(NSError *)error;
- (void)appOpenDidShow:(SUDMAppOpenAd *)ad;
- (void)appOpenShowFail:(nullable SUDMAppOpenAd *)ad withError:(NSError *)error;
- (void)appOpenDidClick:(SUDMAppOpenAd *)ad;
- (void)appOpenDidDismiss:(SUDMAppOpenAd *)ad;

@optional
- (void)appOpenWillStartLoad:(SUDMAppOpenAd *)ad loadObject:(nullable id)loadObject;
- (void)appOpenLoadAllFinish;
//platform load fail
- (void)appOpenAdapterLoadFail:(SUDMAppOpenAd *)ad withError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
