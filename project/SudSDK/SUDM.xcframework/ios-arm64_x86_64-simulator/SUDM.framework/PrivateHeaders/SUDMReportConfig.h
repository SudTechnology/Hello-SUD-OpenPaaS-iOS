#import <Foundation/Foundation.h>
#import "SUDReportOptions.h"
#import "SUDReportRecord.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SUDMReportNormalCollectPolicy) {
    SUDMReportNormalCollectPolicyUpload = 1,
    SUDMReportNormalCollectPolicyStoreOnly = 2,
};

@interface SUDMReportConfig : NSObject <NSCopying>

@property (nonatomic, copy, readonly) NSArray<NSString *> *uploadImportantURLs;
@property (nonatomic, copy, readonly) NSArray<NSString *> *uploadNormalURLs;
@property (nonatomic, assign, readonly, getter=isRealtimeEnabled) BOOL realtimeEnabled;
@property (nonatomic, assign, readonly) NSInteger batchThreshold;
@property (nonatomic, assign, readonly) NSInteger maxUploadCount;
@property (nonatomic, assign, readonly) NSTimeInterval flushIntervalMs;
@property (nonatomic, assign, readonly) NSTimeInterval timeoutMs;
@property (nonatomic, copy, readonly) NSArray<NSNumber *> *retryDelaysMs;
@property (nonatomic, assign, readonly) double retryJitterRatio;
@property (nonatomic, assign, readonly) NSInteger maxCacheCount;
@property (nonatomic, assign, readonly) NSTimeInterval retentionMs;
@property (nonatomic, assign, readonly) SUDMReportNormalCollectPolicy normalCollectPolicy;

/// 服务端下发的采样类型，端上按需使用，0 表示未下发
@property (nonatomic, assign, readonly) NSInteger sampleType;

+ (instancetype)defaultConfig;
+ (nullable instancetype)configWithDictionary:(NSDictionary *)dictionary;

- (SUDReportOptions *)reportOptions;
- (NSArray<NSString *> *)uploadURLsForPriority:(SUDReportPriority)priority;
- (NSDictionary *)dictionaryValue;

@end

NS_ASSUME_NONNULL_END
