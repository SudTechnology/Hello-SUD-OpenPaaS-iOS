#import <Foundation/Foundation.h>
#import "SUDReportContext.h"
#import "SUDReportContextRegistry.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUDMSdkReportSession : NSObject

@property (nonatomic, copy, readonly) NSString *joinId;
@property (nonatomic, strong, readonly, nullable) SUDReportContext *hostContext;

- (void)initStart;
- (void)configStart;
- (void)configEnd;
- (void)configFailedWithError:(nullable NSError *)error;
- (void)initEnd;
- (void)initFailedWithError:(nullable NSError *)error;
- (void)adnInitStartWithInfo:(nullable NSDictionary *)info;
- (void)adnInitEndWithInfo:(nullable NSDictionary *)info;
- (void)adnInitFailedWithInfo:(nullable NSDictionary *)info error:(nullable NSError *)error;
- (void)adnInitStartWithPlatformId:(NSInteger)platformId platformName:(nullable NSString *)platformName;
- (void)adnInitEndWithPlatformId:(NSInteger)platformId platformName:(nullable NSString *)platformName;
- (void)adnInitFailedWithPlatformId:(NSInteger)platformId platformName:(nullable NSString *)platformName error:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
