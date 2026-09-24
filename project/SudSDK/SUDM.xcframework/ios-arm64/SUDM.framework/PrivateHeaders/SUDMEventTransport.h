#import <Foundation/Foundation.h>
#import "SUDReportTransport.h"

NS_ASSUME_NONNULL_BEGIN

@class SUDMReportConfig;

@interface SUDMEventTransport : NSObject <SUDReportTransport>

- (instancetype)initWithConfigProvider:(SUDMReportConfig *(^)(void))configProvider;

+ (SUDReportTransportResult)classifyHTTPStatusCode:(NSInteger)statusCode;
+ (SUDReportTransportResult)classifyBusinessCode:(NSInteger)code;
+ (SUDReportTransportResult)classifyResponse:(NSDictionary *)response expectedCount:(NSInteger)expectedCount;

@end

NS_ASSUME_NONNULL_END
