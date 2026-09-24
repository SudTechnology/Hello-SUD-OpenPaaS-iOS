#import <Foundation/Foundation.h>
#import "SUDReportStore.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUDReportDatabaseStore : NSObject <SUDReportStore>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithDatabaseName:(NSString *)databaseName tableName:(NSString *)tableName NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
