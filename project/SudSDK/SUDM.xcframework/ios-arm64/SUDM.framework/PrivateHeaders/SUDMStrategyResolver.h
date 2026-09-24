//
//  SUDMStrategyResolver.h
//  SUDM
//
//  配置解析器：从 SUDMAdConfigRespModel 解析出 adapter 列表和竞价参数
//  对应 Android SUDMStrategyResolver.java
//

#import <Foundation/Foundation.h>
#import "SUDMHttpRespModels.h"
#import "SUDMAdCommon.h"
#import "SUDMBaseAdapter.h"

NS_ASSUME_NONNULL_BEGIN

/// 选择策略类型（对应 Android SUDMAdFormat.SELECTION_STRATEGY_*）
typedef NS_ENUM(NSInteger, SUDMSelectionStrategyType) {
    /// 旧流程（沿用现有逻辑）
    SUDMSelectionStrategyLegacy = 0,
    /// 混合竞价（CB + Non-Bidding 并发竞价）
    SUDMSelectionStrategyHybridAuction = 1,
};

/// 解析后的广告位策略
@interface SUDMAdUnitStrategy : NSObject

/// 广告位 ID（上报 ad_info.mediation_ad_unit_id，来源广告配置接口 ad_unit_id）
@property (nonatomic, assign) NSInteger adUnitId;
/// 游戏侧广告位 ID（上报 ad_info.game_ad_unit_id，来源 OP sudAdUnitId）
@property (nonatomic, copy, nullable) NSString *gameAdUnitId;
/// 聚合应用 ID（上报 ad_info.mediation_app_id）
@property (nonatomic, assign) NSInteger mediationAppId;
/// 操作类型（上报 ad_info.operation_type，取自广告配置 source）
@property (nonatomic, assign) NSInteger source;
/// 主体 ID（上报 ad_info.subject_id，取自广告配置 subject_id；未下发时为 nil，该字段不上报）
@property (nonatomic, strong, nullable) NSNumber *subjectId;
/// 瀑布流 ID（上报 ad_info.mediation_waterfall_id）
@property (nonatomic, assign) NSInteger waterfallId;
/// 瀑布流版本（服务端下发为字符串时间戳，上报 ad_info.mediation_waterfall_version）
@property (nonatomic, copy, nullable) NSString *waterfallVersion;
/// 广告类型
@property (nonatomic, assign) SUDMAdType adType;
/// 选择策略类型
@property (nonatomic, assign) SUDMSelectionStrategyType selectionStrategyType;
/// 总超时（毫秒）
@property (nonatomic, assign) NSInteger totalTimeOut;
/// 单层超时（毫秒）
@property (nonatomic, assign) NSInteger layerTimeOut;
/// Non-Bidding 并发数
@property (nonatomic, assign) NSInteger parallelSize;
/// Banner 刷新时间
@property (nonatomic, assign) NSInteger bannerRefreshTime;
/// 解析后的 Adapter 配置信息列表（每条对应一个广告源）
@property (nonatomic, strong) NSArray<NSDictionary *> *adapterConfigs;

@end

/// 策略解析 options 中传递游戏侧广告位的 key，值为字符串（对应 OP sudAdUnitId）
FOUNDATION_EXPORT NSString * const SUDMStrategyOptionSudAdUnitIdKey;

@interface SUDMStrategyResolver : NSObject

/// 从广告配置响应中解析指定广告类型的策略
/// @param configResp 广告配置响应
/// @param adType 广告类型
/// @param options 额外选项（如 banner 尺寸等）
/// @return 解析后的策略，如果未找到对应广告位则返回 nil
+ (nullable SUDMAdUnitStrategy *)resolveWithConfig:(SUDMAdConfigRespModel *)configResp
                                            adType:(SUDMAdType)adType
                                           options:(nullable NSDictionary *)options;

/// 从广告配置响应中解析 SDK 初始化信息
/// @param configResp 广告配置响应
/// @return 初始化平台配置数组
+ (NSArray<NSDictionary *> *)resolveInitStrategies:(SUDMAdConfigRespModel *)configResp;

@end

NS_ASSUME_NONNULL_END
