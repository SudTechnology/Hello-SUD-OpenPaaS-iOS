//
//  SUDMAdPrice.h
//  SUDM
//
//  统一价格模型（对应 Android SUDMAdPrice.java）
//  内部使用美元美分 eCPM（例如 5 美元 eCPM = 500 cents）
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 价格来源
typedef NS_ENUM(NSInteger, SUDMAdPriceSource) {
    /// SDK 实时返回的价格（Client Bidding）
    SUDMAdPriceSourceSDKRealtime = 0,
    /// 配置预估价（如 Admob 的 bidding_est_price）
    SUDMAdPriceSourceConfigEstimated = 1,
    /// Non-Bidding 配置固定价
    SUDMAdPriceSourceConfigFixed = 2,
    /// 未知来源
    SUDMAdPriceSourceUnknown = 3,
};

@interface SUDMAdPrice : NSObject <NSCopying>

/// 美元美分 eCPM 值
@property (nonatomic, readonly) double centsValue;

/// 价格来源
@property (nonatomic, readonly) SUDMAdPriceSource source;

/// 美元 eCPM（cents / 100）
@property (nonatomic, readonly) double usdEcpmValue;

/// 是否可用于竞价排序（cents > 0 且 source != Unknown）
@property (nonatomic, readonly) BOOL isValidForAuction;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 从美元美分 eCPM 创建
+ (instancetype)centsWithValue:(double)cents source:(SUDMAdPriceSource)source;

/// 从美元 eCPM 创建（会自动 ×100 转换为美分）
+ (instancetype)usdEcpmWithValue:(double)usdEcpm source:(SUDMAdPriceSource)source;

/// 比较价格，返回 NSComparisonResult
- (NSComparisonResult)compare:(SUDMAdPrice *)other;

@end

NS_ASSUME_NONNULL_END
