//
//  SUDM.h
//  SUDM
//
//  Created by kaniel on 7/21/26.
//

#import <Foundation/Foundation.h>
#import "SUDMCommon.h"
#import "SUDMPrivacyConfig.h"
#import "SUDMBannerAdView.h"
#import "SUDMInterstitialAd.h"
#import "SUDMAppOpenAd.h"
#import "SUDMNativeAd.h"
#import "SUDMNativeView.h"
#import "SUDMRewardedVideoAd.h"


NS_ASSUME_NONNULL_BEGIN

@protocol SUDMDelegate;

@protocol SUDMDelegate <NSObject>

- (void)initFinishWithPlatformID:(NSInteger)platformID platformName:(NSString *)platformName failedError:(nullable NSError *)failedError;
- (void)allPlatformFinish:(nullable NSError *)error;
@end

@interface SUDM : NSObject
@property (nonatomic,assign)BOOL didInit;
@property (nonatomic,assign)BOOL openDebugLog;
+ (SUDM *)sharedInstance;
+(nonnull NSString *)sdkVersion;
+ (nonnull NSString *)getLogDirPath;

+ (void)initializeWithConfiguration:(SUDMSDKConfiguration *)configuration
                         completion:(void(^_Nullable)(NSError *_Nullable error))completion;
+(void)uninitialize;

/// 设置宿主已确认的隐私配置快照（推荐接入方式）。
/// 可在初始化前调用（随广告 SDK 一起生效），也可在初始化后调用进行热更新（只重放下发，不重建广告对象）。
/// 传入 nil 表示清除当前隐私配置快照。
+ (void)setPrivacyConfig:(nullable SUDMPrivacyConfig *)config;

- (void)startWithData:(NSData *)data delegate:(id <SUDMDelegate>)delegate;
- (void)setUserID:(NSString *)userID;

@end

NS_ASSUME_NONNULL_END
