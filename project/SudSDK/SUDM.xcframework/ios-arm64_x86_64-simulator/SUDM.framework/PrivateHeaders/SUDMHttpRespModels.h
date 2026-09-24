//
//  SUDMHttpRespModels.h
//  SudMGP
//
//  Created by kaniel on 2024/5/31.
//

#import <Foundation/Foundation.h>
#import "SUDMAdCommon.h"
NS_ASSUME_NONNULL_BEGIN

@interface SUDMBaseRespModel : NSObject

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) NSDictionary *srcData;

/// 解码消息
/// @param srcData 根JSON
+ (instancetype)decodeModel:(id)srcData;

/// 业务错误信息
- (nullable NSString *)errorMsg;

- (NSDictionary *)sud_toFilteredJSONObject;

/// 移除指定字段
- (NSArray<NSString *> *)sud_removeKeysFromJSON;

@end


#pragma mark - SUDMAdConfig Models

/// 广告网络类型
typedef NS_ENUM(NSInteger, SUDMAdNetworkType) {
    /// 未知
    SUDMAdNetworkTypeUnknown = 0,

    /// Pangle，字节穿山甲海外版
    SUDMAdNetworkTypePangle = 1,

    /// Admob，谷歌 Admob
    SUDMAdNetworkTypeAdmob = 2,

    /// Tec-Do，钛动
    SUDMAdNetworkTypeTecDo = 3,

    /// Mintegral
    SUDMAdNetworkTypeMintegral = 4,

    /// Unity Ads
    SUDMAdNetworkTypeUnity = 6,

    /// Facebook / Meta
    SUDMAdNetworkTypeFacebook = 10,

    /// AppLovin
    SUDMAdNetworkTypeAppLovin = 11,

    /// IronSource
    SUDMAdNetworkTypeIronSource = 12,

    /// Vungle
    SUDMAdNetworkTypeVungle = 13,

    /// Bigo
    SUDMAdNetworkTypeBigo = 14,

    /// Google Ad Manager
    SUDMAdNetworkTypeAdManager = 15,

    /// AppLovin MAX 聚合
    SUDMAdNetworkTypeMax = 16,

    /// Admob Mediation 聚合
    SUDMAdNetworkTypeAdmobMediation = 17,

    /// A4G
    SUDMAdNetworkTypeA4G = 18,

    /// TopOn / AnyThink
    SUDMAdNetworkTypeTopOn = 19,
};

///// 广告类型
//typedef NS_ENUM(NSInteger, SUDMAdType) {
//    /// 未知
//    SUDMAdTypeUnknown = 0,
//
//    /// 信息流 / 原生
//    SUDMAdTypeNative = 1,
//
//    /// 横幅 / Banner
//    SUDMAdTypeBanner = 2,
//
//    /// 开屏
//    SUDMAdTypeAppOpen = 3,
//
//    /// 激励视频
//    SUDMAdTypeRewardedVideo = 5,
//
//    /// 插屏
//    SUDMAdTypeInterstitial = 6,
//};

/// SDK 初始化信息
@interface SUDMAdConfigSdkInitInfoModel : NSObject

@property(nonatomic, copy) NSString *app_id;
@property(nonatomic, copy) NSString *app_key;
@property(nonatomic, assign) SUDMAdNetworkType network;

@end


/// 广告代码位配置
@interface SUDMAdConfigCodeModel : NSObject

@property(nonatomic, assign) NSInteger bidding_bottom_price;
@property(nonatomic, assign) NSInteger bidding_est_price;
@property(nonatomic, assign) NSInteger bidding_type;
@property(nonatomic, assign) NSInteger is_bottom;
@property(nonatomic, assign) NSInteger load_sort;
@property(nonatomic, assign) SUDMAdNetworkType network;
@property(nonatomic, assign) NSInteger price;
@property(nonatomic, copy) NSString *rit_id;
@property(nonatomic, assign) NSInteger show_sort;
@property(nonatomic, assign) NSInteger sub_ad_type;

/// Banner 广告位服务端下发的固定宽（点），未下发时为 0
@property(nonatomic, assign) NSInteger banner_width;

/// Banner 广告位服务端下发的固定高（点），未下发时为 0
@property(nonatomic, assign) NSInteger banner_height;

@end


/// 瀑布流配置
@interface SUDMAdConfigWaterfallModel : NSObject

@property(nonatomic, assign) NSInteger banner_refresh_time;
@property(nonatomic, assign) NSInteger bidding_bottom_price;

@property(nonatomic, strong) NSArray<SUDMAdConfigCodeModel *> *client_bidding_code_list;

@property(nonatomic, assign) NSInteger layer_time_out;

@property(nonatomic, strong) NSArray<SUDMAdConfigCodeModel *> *non_bidding_code_list;

@property(nonatomic, assign) NSInteger parallel_size;
@property(nonatomic, assign) NSInteger request_mode;

/// 服务端可能返回 null
@property(nonatomic, strong, nullable) NSArray<SUDMAdConfigCodeModel *> *server_bidding_code_list;

@property(nonatomic, assign) NSInteger total_time_out;
@property(nonatomic, assign) NSInteger waterfall_id;
@property(nonatomic, copy) NSString *waterfall_version;

@end


/// 广告单元配置
@interface SUDMAdConfigAdUnitModel : NSObject

@property(nonatomic, assign) NSInteger ad_unit_id;

/// 当前 JSON 里有 ad_unit_type = 6，
/// 如果你的 SUDMAdType 只定义到 5，这里建议先用 NSInteger。
@property(nonatomic, assign) SUDMAdType ad_unit_type;

@property(nonatomic, assign) NSInteger prime_rit_id;

@property(nonatomic, strong) NSArray<SUDMAdConfigWaterfallModel *> *waterfall_list;

@end


/// 埋点上报配置（服务端下发的 event_info 节点）
@interface SUDMAdConfigEventInfoModel : NSObject

/// 批量上报触发阈值（条）
@property(nonatomic, assign) NSInteger batch_threshold;

/// 本地事件过期天数
@property(nonatomic, assign) NSInteger event_expire_day;

/// 本地最大缓存条数
@property(nonatomic, assign) NSInteger max_cache_count;

/// 单次上报最大条数
@property(nonatomic, assign) NSInteger max_upload_count;

/// 最大等待时长（秒），到时未攒够阈值也上报
@property(nonatomic, assign) NSInteger max_wait_seconds;

/// 是否开启实时上报，未下发时为 nil，由端上使用兜底值
@property(nonatomic, strong, nullable) NSNumber *realtime_enabled;

/// 重试间隔序列（秒）
@property(nonatomic, strong) NSArray<NSNumber *> *retry_intervals;

/// 重试间隔抖动比例，取值 0~1，未下发时为 nil，由端上使用兜底值
@property(nonatomic, strong, nullable) NSNumber *retry_jitter_ratio;

/// 采样类型
@property(nonatomic, assign) NSInteger sample_type;

/// 重要事件上报地址
@property(nonatomic, strong) NSArray<NSString *> *upload_import_urls;

/// 普通事件上报地址
@property(nonatomic, strong) NSArray<NSString *> *upload_normal_urls;

#pragma mark - 广告请求频次（服务端随 event_info 节点下发）

/// 横幅广告请求频次，未下发时为 nil，由端上使用兜底值
@property(nonatomic, strong, nullable) NSNumber *banner_req_frequency;

/// 插屏广告请求频次，未下发时为 nil，由端上使用兜底值
@property(nonatomic, strong, nullable) NSNumber *interstitial_req_frequency;

/// 激励视频请求频次，未下发时为 nil，由端上使用兜底值
@property(nonatomic, strong, nullable) NSNumber *rewarded_req_frequency;

/// 开屏广告请求频次，未下发时为 nil，由端上使用兜底值
@property(nonatomic, strong, nullable) NSNumber *splash_req_frequency;

@end


/// 广告请求频次配置（对外语义模型，取值已按兜底值处理）
@interface SUDMAdConfigRequestFrequencyModel : NSObject

/// 横幅广告请求频次
@property(nonatomic, assign) NSInteger bannerFrequency;

/// 插屏广告请求频次
@property(nonatomic, assign) NSInteger interstitialFrequency;

/// 激励视频广告请求频次
@property(nonatomic, assign) NSInteger rewardedFrequency;

/// 开屏广告请求频次
@property(nonatomic, assign) NSInteger splashFrequency;

@end


/// 广告配置响应
@interface SUDMAdConfigRespModel : SUDMBaseRespModel

@property(nonatomic, strong) NSArray<SUDMAdConfigAdUnitModel *> *ad_unit_list;

@property(nonatomic, assign) NSInteger mediation_app_id;

/// JSON 示例：
/// {
///   "3": {
///     "app_id": "6001923",
///     "app_key": "",
///     "network": 3
///   }
/// }
@property(nonatomic, strong) NSDictionary<NSString *, SUDMAdConfigSdkInitInfoModel *> *sdk_init_info;

@property(nonatomic, assign) NSInteger source;

/// 主体 ID，与 source 同级下发；未下发时为 nil，用于区分「未下发」与「下发 0」
@property(nonatomic, strong, nullable) NSNumber *subject_id;

@property(nonatomic, strong)NSString *etag;

/// 埋点上报配置，服务端可能不下发
@property(nonatomic, strong, nullable) SUDMAdConfigEventInfoModel *event_info;

@end

NS_ASSUME_NONNULL_END
