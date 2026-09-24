#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDReportOptions : NSObject <NSCopying>

@property (nonatomic, assign, readonly) NSInteger batchThreshold;
@property (nonatomic, assign, readonly) NSInteger maxUploadCount;
@property (nonatomic, assign, readonly) NSTimeInterval flushIntervalMs;
@property (nonatomic, assign, readonly) NSTimeInterval attemptTimeoutMs;
@property (nonatomic, assign, readonly) NSTimeInterval retentionMs;
@property (nonatomic, assign, readonly) NSInteger maxRecords;
@property (nonatomic, copy, readonly) NSArray<NSNumber *> *retryDelaysMs;
@property (nonatomic, assign, readonly, getter=isRealtimeEnabled) BOOL realtimeEnabled;
@property (nonatomic, assign, readonly) double retryJitterRatio;

+ (instancetype)defaultOptions;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithBatchThreshold:(NSInteger)batchThreshold
                        maxUploadCount:(NSInteger)maxUploadCount
                       flushIntervalMs:(NSTimeInterval)flushIntervalMs
                      attemptTimeoutMs:(NSTimeInterval)attemptTimeoutMs
                           retentionMs:(NSTimeInterval)retentionMs
                            maxRecords:(NSInteger)maxRecords
                         retryDelaysMs:(NSArray<NSNumber *> *)retryDelaysMs
                       realtimeEnabled:(BOOL)realtimeEnabled
                      retryJitterRatio:(double)retryJitterRatio NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
