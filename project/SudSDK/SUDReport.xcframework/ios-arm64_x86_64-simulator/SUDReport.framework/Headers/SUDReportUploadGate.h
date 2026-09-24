#import <Foundation/Foundation.h>
#import "SUDReportRecord.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SUDReportUploadGateCompletion)(void);

typedef void (^SUDReportUploadGateStartBlock)(SUDReportUploadGateCompletion completion);
typedef void (^SUDReportUploadGateCancelBlock)(void);

@interface SUDReportUploadGate : NSObject

- (dispatch_block_t)submitWithPriority:(SUDReportPriority)priority
                            startBlock:(SUDReportUploadGateStartBlock)startBlock
                            cancelBlock:(SUDReportUploadGateCancelBlock)cancelBlock;

@end

NS_ASSUME_NONNULL_END
