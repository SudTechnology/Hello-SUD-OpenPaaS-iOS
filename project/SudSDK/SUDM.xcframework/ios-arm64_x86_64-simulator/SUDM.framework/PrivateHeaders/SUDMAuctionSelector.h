//
//  SUDMAuctionSelector.h
//  SUDM
//
//  混合竞价规则计算器（对应 Android SUDMAuctionSelector.java）
//  纯计算，不发请求、不维护超时
//

#import <Foundation/Foundation.h>
#import "SUDMBaseAdapter.h"
#import "SUDMAdPrice.h"

NS_ASSUME_NONNULL_BEGIN

@class SUDMLoadedSource;

/// 淘汰原因
@interface SUDMAuctionRejection : NSObject
@property (nonatomic, strong) SUDMBaseAdapter *adapter;
@property (nonatomic, strong, nullable) SUDMAdPrice *price;
@property (nonatomic, copy) NSString *reason;
@end

/// 选择结果
@interface SUDMAuctionSelectionResult : NSObject
@property (nonatomic, strong) NSArray<SUDMLoadedSource *> *candidates;
@property (nonatomic, strong) NSArray<SUDMAuctionRejection *> *rejections;
@end

@interface SUDMAuctionSelector : NSObject

/// 从已加载结果中筛选和排序候选
/// 排序规则：价格降序 → CB 优先 → showSort 升序 → configOrder 升序
- (SUDMAuctionSelectionResult *)selectCandidates:(NSArray<SUDMLoadedSource *> *)loadedSources;

/// 竞胜通知（CB 候选即将展示时调用）
- (void)notifyBidWin:(NSArray<SUDMLoadedSource *> *)candidates
             adapter:(SUDMBaseAdapter *)adapter;

/// 竞败通知（展示成功后向其余 CB 候选发送 loss）
- (void)notifyBidLoss:(NSArray<SUDMLoadedSource *> *)candidates
               winner:(SUDMBaseAdapter *)winner;

/// 静态方法：判断候选是否有资格参与竞价
+ (BOOL)isEligibleForAuction:(SUDMBaseAdapter *)adapter
                       price:(SUDMAdPrice *)price;

/// 静态方法：新候选是否严格优于当前最佳候选
+ (BOOL)isBetterCandidate:(SUDMAdPrice *)newPrice
                newAdapter:(SUDMBaseAdapter *)newAdapter
              currentPrice:(nullable SUDMAdPrice *)currentPrice
            currentAdapter:(nullable SUDMBaseAdapter *)currentAdapter;

@end

NS_ASSUME_NONNULL_END
