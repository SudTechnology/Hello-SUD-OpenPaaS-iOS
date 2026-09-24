#import <Foundation/Foundation.h>
#import "SUDReportTransport.h"
#import "SUDReportUploadGate.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SUDReportUploadAttemptCompletion)(SUDReportTransportResult result);

@interface SUDReportUploadAttempt : NSObject

@property (nonatomic, copy, readonly) NSArray<SUDReportRecord *> *records;
@property (nonatomic, assign, readonly) NSInteger retryIndex;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithRecords:(NSArray<SUDReportRecord *> *)records
                      transport:(id<SUDReportTransport>)transport
                      uploadGate:(SUDReportUploadGate *)uploadGate
                       timeoutMs:(NSTimeInterval)timeoutMs
                      retryIndex:(NSInteger)retryIndex
                   callbackQueue:(dispatch_queue_t)callbackQueue
                      completion:(SUDReportUploadAttemptCompletion)completion NS_DESIGNATED_INITIALIZER;

- (void)start;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
