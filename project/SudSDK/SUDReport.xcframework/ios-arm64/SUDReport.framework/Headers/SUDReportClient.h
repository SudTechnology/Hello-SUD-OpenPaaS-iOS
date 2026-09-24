#import <Foundation/Foundation.h>
#import "SUDReportOptions.h"
#import "SUDReportStore.h"
#import "SUDReportTransport.h"
#import "SUDReportUploadGate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUDReportClient : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithStore:(id<SUDReportStore>)store
                      options:(SUDReportOptions *)options
                    transport:(id<SUDReportTransport>)transport;

- (instancetype)initWithStore:(id<SUDReportStore>)store
                      options:(SUDReportOptions *)options
                    transport:(id<SUDReportTransport>)transport
                    uploadGate:(SUDReportUploadGate *)uploadGate NS_DESIGNATED_INITIALIZER;

- (void)enqueueRecord:(SUDReportRecord *)record;
- (void)enqueueRecord:(SUDReportRecord *)record waitForPersistence:(BOOL)waitForPersistence;
- (void)flush;
- (void)updateOptions:(SUDReportOptions *)options;
- (void)close;

@end

NS_ASSUME_NONNULL_END
