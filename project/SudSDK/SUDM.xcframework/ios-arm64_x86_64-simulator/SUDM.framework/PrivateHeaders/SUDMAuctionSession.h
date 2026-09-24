//
//  SUDMAuctionSession.h
//  SUDM
//
//  竞价会话总控（对应 Android SUDMAuctionSession.java）
//  串联 Loader 和 Selector，管理 Adapter 列表重排和 Win/Loss 通知
//

#import <Foundation/Foundation.h>
#import "SUDMBaseAdapter.h"
#import "SUDMLoadedSource.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SUDMAuctionSessionListener <NSObject>
/// 竞价加载成功（至少有一个有效候选）
- (void)auctionDidLoad;
/// 竞价加载失败
- (void)auctionDidFailWithError:(NSError *)error;
@optional
/// 单广告源加载成功
- (void)auctionSourceDidLoad:(SUDMBaseAdapter *)adapter durationMs:(NSTimeInterval)durationMs;
/// 单广告源加载失败
- (void)auctionSourceDidFail:(SUDMBaseAdapter *)adapter error:(NSError *)error durationMs:(NSTimeInterval)durationMs;
/// 单广告源加载超时
- (void)auctionSourceDidTimeout:(SUDMBaseAdapter *)adapter error:(NSError *)error durationMs:(NSTimeInterval)durationMs;
/// 单广告源被竞价规则过滤
- (void)auctionSourceDidFilter:(SUDMBaseAdapter *)adapter floorCents:(double)floorCents reason:(NSString *)reason;
@end

@interface SUDMAuctionSession : NSObject

- (instancetype)initWithAdapters:(NSMutableArray<SUDMBaseAdapter *> *)adapters
                  totalTimeoutMs:(NSTimeInterval)totalTimeoutMs
                 sourceTimeoutMs:(NSTimeInterval)sourceTimeoutMs
                    parallelSize:(NSInteger)parallelSize
                        listener:(id<SUDMAuctionSessionListener>)listener;

- (instancetype)init NS_UNAVAILABLE;

/// 开始竞价加载
- (void)loadAd;

/// 取消竞价会话
- (void)cancel;

/// 展示前调用：通知竞胜
- (void)onCandidateAttempt:(SUDMBaseAdapter *)adapter
                     index:(NSInteger)index;

/// 展示成功后调用：通知竞败 + 销毁落选者
- (void)onCandidateCommitted:(SUDMBaseAdapter *)winner;

/// 获取排序后的候选列表
@property (nonatomic, readonly) NSArray<SUDMLoadedSource *> *rankedCandidates;

/// 是否已取消
@property (nonatomic, readonly) BOOL isCanceled;

@end

NS_ASSUME_NONNULL_END
