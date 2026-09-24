#import <Foundation/Foundation.h>
#import "SUDReportClient.h"
#import "SUDReportDatabaseStore.h"
#import "SUDReportContext.h"
#import "SUDMAdCommon.h"

NS_ASSUME_NONNULL_BEGIN

/// 收入上报 ad_info 字段名
FOUNDATION_EXPORT NSString * const SUDMReportKeyADNRevenueValueMicros;
FOUNDATION_EXPORT NSString * const SUDMReportKeyADNRevenueCurrency;

@class SUDMAdObject;
@class SUDMBaseAdapter;
@class SUDMAdUnitStrategy;
@class SUDMReportConfig;

@interface SUDMReportManager : NSObject

+ (void)initializeIfNeeded;
+ (void)updateConfig:(SUDMReportConfig *)config;
+ (void)flush;
+ (void)close;

+ (void)reportWithHostContext:(nullable SUDReportContext *)hostContext
                     priority:(SUDReportPriority)priority
                       joinId:(NSString *)joinId
                    eventType:(NSInteger)eventType
                    eventName:(NSString *)eventName
                       adType:(SUDMAdType)adType
                     strategy:(nullable SUDMAdUnitStrategy *)strategy
                      adapter:(nullable SUDMBaseAdapter *)adapter
                           ad:(nullable SUDMAdObject *)ad
                        error:(nullable NSError *)error
                        extra:(nullable NSDictionary *)extra;

+ (void)reportWithHostContext:(nullable SUDReportContext *)hostContext
                     priority:(SUDReportPriority)priority
                       joinId:(NSString *)joinId
                    eventType:(NSInteger)eventType
                    eventName:(NSString *)eventName
                       adType:(SUDMAdType)adType
                     strategy:(nullable SUDMAdUnitStrategy *)strategy
                      adapter:(nullable SUDMBaseAdapter *)adapter
                           ad:(nullable SUDMAdObject *)ad
                        error:(nullable NSError *)error
                        extra:(nullable NSDictionary *)extra
                  adInfoExtra:(nullable NSDictionary *)adInfoExtra;

@end

NS_ASSUME_NONNULL_END
