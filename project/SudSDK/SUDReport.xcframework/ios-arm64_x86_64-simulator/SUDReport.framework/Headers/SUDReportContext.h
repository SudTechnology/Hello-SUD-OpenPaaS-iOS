#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDReportContext : NSObject <NSCopying>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, copy, readonly, nullable) NSString *appId;
@property (nonatomic, copy, readonly, nullable) NSString *gameId;
@property (nonatomic, copy, readonly, nullable) NSString *gameVersion;
@property (nonatomic, copy, readonly, nullable) NSString *sessionId;
@property (nonatomic, copy, readonly, nullable) NSString *runId;
@property (nonatomic, copy, readonly, nullable) NSString *opSdkVersion;

- (instancetype)initWithAppId:(nullable NSString *)appId
                       gameId:(nullable NSString *)gameId
                  gameVersion:(nullable NSString *)gameVersion
                    sessionId:(nullable NSString *)sessionId
                        runId:(nullable NSString *)runId
                 opSdkVersion:(nullable NSString *)opSdkVersion NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
