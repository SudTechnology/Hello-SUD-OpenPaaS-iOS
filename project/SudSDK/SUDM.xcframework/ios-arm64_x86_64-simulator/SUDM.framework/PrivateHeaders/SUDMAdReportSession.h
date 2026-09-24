#import <Foundation/Foundation.h>
#import "SUDReportContext.h"
#import "SUDReportContextRegistry.h"
#import "SUDMAdCommon.h"

NS_ASSUME_NONNULL_BEGIN

@class SUDMAdObject;
@class SUDMBaseAdapter;
@class SUDMAdUnitStrategy;

@interface SUDMAdReportSession : NSObject

@property (nonatomic, copy, readonly) NSString *joinId;
@property (nonatomic, strong, readonly, nullable) SUDReportContext *hostContext;
@property (nonatomic, assign, readonly) SUDMAdType adType;
@property (nonatomic, strong, readonly, nullable) SUDMAdUnitStrategy *strategy;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithAdType:(SUDMAdType)adType strategy:(nullable SUDMAdUnitStrategy *)strategy NS_DESIGNATED_INITIALIZER;

- (void)appAdRequest;
- (void)loadStart;
- (void)loadSuccessWithAd:(nullable SUDMAdObject *)ad;
- (void)loadFailedWithError:(nullable NSError *)error;
- (void)mediaRequestStartWithAdapter:(nullable SUDMBaseAdapter *)adapter;
- (void)mediaFillSuccessWithAdapter:(nullable SUDMBaseAdapter *)adapter ad:(nullable SUDMAdObject *)ad durationMs:(NSTimeInterval)durationMs;
- (void)mediaFillFailedWithAdapter:(nullable SUDMBaseAdapter *)adapter error:(nullable NSError *)error durationMs:(NSTimeInterval)durationMs;
- (void)mediaFillTimeoutWithAdapter:(nullable SUDMBaseAdapter *)adapter error:(nullable NSError *)error durationMs:(NSTimeInterval)durationMs;
- (void)mediaFillNotMatchWithAdapter:(nullable SUDMBaseAdapter *)adapter error:(nullable NSError *)error durationMs:(NSTimeInterval)durationMs;
- (void)priceFilteredWithAdapter:(nullable SUDMBaseAdapter *)adapter floorCents:(double)floorCents reason:(nullable NSString *)reason;
- (void)winWithAd:(nullable SUDMAdObject *)ad;
- (void)ready:(BOOL)ready;
- (void)showStart;
- (void)showSuccessWithAd:(nullable SUDMAdObject *)ad;
- (void)showFailedWithAd:(nullable SUDMAdObject *)ad error:(nullable NSError *)error;
- (void)clickStartWithAd:(nullable SUDMAdObject *)ad;
- (void)clickWithAd:(nullable SUDMAdObject *)ad;
- (void)closeWithAd:(nullable SUDMAdObject *)ad;
- (void)playStartWithAd:(nullable SUDMAdObject *)ad;
- (void)playEndWithAd:(nullable SUDMAdObject *)ad;
- (void)rewardWithAd:(nullable SUDMAdObject *)ad;
/// 记录 ADN 展示级收入；金额统一为币种的百万分之一（micros）
- (void)revenuePaidWithAd:(nullable SUDMAdObject *)ad
               valueMicros:(long long)valueMicros
              currencyCode:(nullable NSString *)currencyCode;

@end

NS_ASSUME_NONNULL_END
