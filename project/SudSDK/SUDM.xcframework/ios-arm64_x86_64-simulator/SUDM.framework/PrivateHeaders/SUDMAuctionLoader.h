//
//  SUDMAuctionLoader.h
//  SUDM
//
//  竞价请求执行器（对应 Android SUDMAuctionLoader.java）
//  管理 CB + Non-Bidding 的并发请求、滚动窗口、剪枝、超时
//

#import <Foundation/Foundation.h>
#import "SUDMBaseAdapter.h"
#import "SUDMLoadedSource.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SUDMAuctionLoaderCallback <NSObject>
- (void)onLoadFinished:(NSArray<SUDMLoadedSource *> *)loadedSources
              timedOut:(BOOL)timedOut
             elapsedMs:(NSTimeInterval)elapsedMs;
- (void)onSourceLoaded:(SUDMBaseAdapter *)adapter durationMs:(NSTimeInterval)durationMs;
- (void)onSourceError:(SUDMBaseAdapter *)adapter error:(NSError *)error durationMs:(NSTimeInterval)durationMs;
- (void)onSourceTimeout:(SUDMBaseAdapter *)adapter error:(NSError *)error durationMs:(NSTimeInterval)durationMs;
@end

@interface SUDMAuctionLoader : NSObject

- (instancetype)initWithAdapters:(NSArray<SUDMBaseAdapter *> *)adapters
                  totalTimeoutMs:(NSTimeInterval)totalTimeoutMs
                 sourceTimeoutMs:(NSTimeInterval)sourceTimeoutMs
          nonBiddingParallelSize:(NSInteger)parallelSize
                        callback:(id<SUDMAuctionLoaderCallback>)callback;

- (instancetype)init NS_UNAVAILABLE;

/// 开始加载所有广告源
- (void)load;

/// 取消所有进行中的请求（销毁全部 adapter，包括已成功的）
- (void)cancel;

/// 是否已完成或取消
@property (nonatomic, readonly) BOOL isFinished;

@end

NS_ASSUME_NONNULL_END
