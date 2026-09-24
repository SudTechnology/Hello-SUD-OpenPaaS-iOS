//
//  SUDMAdBridgeProvider.h
//  SUDM
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SUDAdBridgeProviderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUDMAdBridgeProvider : NSObject <SUDAdBridgeProviderProtocol>

+ (BOOL)isAdBridgeAvailable;

+ (void)createAdWithRequest:(NSDictionary *)request
                 completion:(nullable SUDAdBridgeCompletion)completion
               eventHandler:(nullable SUDAdBridgeEventHandler)eventHandler;

+ (void)loadAdWithIdentifier:(NSString *)identifier completion:(nullable SUDAdBridgeCompletion)completion;

+ (void)showAdWithIdentifier:(NSString *)identifier completion:(nullable SUDAdBridgeCompletion)completion;

+ (void)hideAdWithIdentifier:(NSString *)identifier;
+ (void)updateAdWithIdentifier:(NSString *)identifier request:(NSDictionary *)request;
+ (void)setPrivacyConfig:(nullable SUDAdBridgePrivacyConfig *)config;
+ (void)setUserId:(nullable NSString *)userId;
+ (void)initializeAdSdkWithAppId:(NSString *)appId
                          appKey:(NSString *)appKey
                       bundleKey:(nullable NSString *)bundleKey
                      completion:(nullable void(^)(NSError * _Nullable error))completion;
+ (void)destroyAdWithIdentifier:(NSString *)identifier;
+ (void)destroyAllAds;
+ (void)shutdown;

@end

NS_ASSUME_NONNULL_END
