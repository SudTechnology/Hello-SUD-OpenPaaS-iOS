#import <Foundation/Foundation.h>
#import "SUDReportRecord.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SUDReportStore <NSObject>

- (BOOL)insertRecord:(SUDReportRecord *)record;
- (NSArray<SUDReportRecord *> *)readBatchWithPriority:(SUDReportPriority)priority now:(NSTimeInterval)now limit:(NSInteger)limit;
- (NSInteger)countWithPriority:(SUDReportPriority)priority;
- (void)deleteRecords:(NSArray<SUDReportRecord *> *)records;
- (NSInteger)cleanupWithCutoff:(NSTimeInterval)cutoff maxRecords:(NSInteger)maxRecords;
- (void)close;

@end

NS_ASSUME_NONNULL_END
