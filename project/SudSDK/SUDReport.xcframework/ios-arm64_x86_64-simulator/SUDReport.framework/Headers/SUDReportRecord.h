#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SUDReportPriority) {
    SUDReportPriorityNormal = 0,
    SUDReportPriorityImportant = 1,
};

@interface SUDReportRecord : NSObject

@property (nonatomic, copy, readonly) NSString *requestId;
@property (nonatomic, assign, readonly) SUDReportPriority priority;
@property (nonatomic, copy, readonly) NSString *payload;
@property (nonatomic, assign, readonly) NSTimeInterval createdAt;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithRequestId:(NSString *)requestId
                         priority:(SUDReportPriority)priority
                          payload:(NSString *)payload
                        createdAt:(NSTimeInterval)createdAt NS_DESIGNATED_INITIALIZER;

- (BOOL)isValid;

@end

NS_ASSUME_NONNULL_END
