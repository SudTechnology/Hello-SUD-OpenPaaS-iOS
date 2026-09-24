//
//  SUDMAdConfigManager.h
//  SUDM
//
//  Created by kaniel on 7/24/26.
//

#import <Foundation/Foundation.h>
#import "SUDMAdCommon.h"
NS_ASSUME_NONNULL_BEGIN
@protocol SUDMAdConfigManagerDelegate;
@class SUDMAdUnitStrategy;
@class SUDMAdConfigRequestFrequencyModel;

@interface SUDMAdConfigManager : NSObject
@property(nonatomic, weak)id<SUDMAdConfigManagerDelegate> delegate;

- (void)updateAdConfig;

/// 幂等清理：取消刷新/重试定时器、置空内存配置并停止后续调度，可重复调用。
- (void)cleanup;

/// 重新进入可调度状态，供 SDK 二次初始化时调用（清理后再初始化需先 reset）。
- (void)reset;

/// 新：获取解析后的广告位策略（竞价模式使用）
- (nullable SUDMAdUnitStrategy *)getStrategyForAdType:(SUDMAdType)adType
                                              options:(nullable NSDictionary *)options;

/// 获取广告请求频次配置；各字段为服务端下发值，未下发时取兜底值 10。该方法只提供配置读取，不做请求拦截。
- (nonnull SUDMAdConfigRequestFrequencyModel *)requestFrequencyConfig;

/// 按样式判定本次加载是否放行：放行即原子记录放行时间，拒绝不推进窗口，放行后失败/取消不退还。
/// 未纳入本期限频的样式（原生、激励插屏、未知类型）直接放行且不记录。
- (BOOL)allowRequestForAdType:(SUDMAdType)adType;

/// Get starting sdk configuration
/// - Parameter completion: completion description
- (void)getStartDataWithCompletion:(void(^)(NSData *_Nullable data, NSError *_Nullable error))completion;
@end


@protocol SUDMAdConfigManagerDelegate <NSObject>

@optional
- (void)adConfigManangerDidUPdatedAdConfig:(SUDMAdConfigManager *)adConfigManager;

@end

NS_ASSUME_NONNULL_END
