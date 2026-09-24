#import <Foundation/Foundation.h>
#import "SUDReportRecord.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SUDReportTransportResult) {
    /// 上传成功，调度器会删除本批记录。
    SUDReportTransportResultSuccess = 0,
    /// 上传失败但可重试，调度器会按重试策略延后再次上传。
    SUDReportTransportResultRetry,
    /// 当前通道暂不可用，调度器会保留记录并等待后续调度。
    SUDReportTransportResultHold,
    /// 记录不可恢复或无需继续上传，调度器会丢弃本批记录。
    SUDReportTransportResultDrop,
};

typedef void (^SUDReportTransportCompletion)(SUDReportTransportResult result);

@protocol SUDReportTransport <NSObject>

- (nullable dispatch_block_t)uploadRecords:(NSArray<SUDReportRecord *> *)records
                                completion:(SUDReportTransportCompletion)completion;

- (BOOL)isAvailableForPriority:(SUDReportPriority)priority;

@end

NS_ASSUME_NONNULL_END
