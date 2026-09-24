

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SUDMNativeView.h"
#import "SUDM.h"
#import "SUDMAdCommon.h"

@class SUDMAdObject;
@class SUDMAdPrice;

NS_ASSUME_NONNULL_BEGIN

/// 竞价类型（对应 Android SUDMMediationStrategy.BIDDING_TYPE_*）
typedef NS_ENUM(NSInteger, SUDMBiddingType) {
    /// Non-Bidding（设价代码位，使用配置固定价）
    SUDMBiddingTypeNonBidding = 0,
    /// Server Bidding（预留，本期不调度）
    SUDMBiddingTypeServerBidding = 1,
    /// Client Bidding（SDK 实时返价）
    SUDMBiddingTypeClientBidding = 2,
};

@interface SUDMBaseAdapter : NSObject

/// 全局存活适配器统一注册表（弱引用，线程安全）。
/// 所有 adapter 在 init 时自动注册、dealloc 时自动注销，供隐私热更新等全局操作覆盖到请求期 adapter。
+ (nonnull NSArray<SUDMBaseAdapter *> *)livingAdapters;

//init
- (void)startWithInfo:(NSDictionary *)info;
- (void)setUserID:(NSString *)userID;
/// 应用隐私配置快照（子类映射到具体三方 SDK；默认仅缓存最近一次快照）
- (void)applyPrivacyConfig:(nullable SUDMPrivacyConfig *)config;
/// 最近一次下发的隐私配置快照（供子类在合适时机读取）
@property (nonatomic, strong, readonly, nullable) SUDMPrivacyConfig *privacyConfig;
/// 当前隐私快照下该渠道是否可参与请求（子类重写以声明不支持场景，如 CHILD）
- (BOOL)supportsCurrentPrivacy;
//ad
- (BOOL)setupAdWithInfo:(NSDictionary *)info;
- (void)loadAd;
- (BOOL)isReady;
- (void)showAd:(nullable UIViewController *)viewController customRewardString:(NSString *)customRewardString;
- (nullable UIView *)getBannerView:(nullable UIViewController *)viewController;
- (void)renderWithNativeView:(SUDMNativeView *)nativeView viewController:(nullable UIViewController *)viewController;
- (void)setFullLayOut:(UIView *)view;

#pragma mark - Banner 尺寸适配（对应 Android SUDMBannerAdapter）

/// 请求前（主线程）按 JS 提供的最大容器判定该候选是否可用，并准备本次请求。
/// 固定尺寸广告源要求实际尺寸不超过容器；自适应广告源要求计算出的尺寸不超过容器。
/// @param maxWidth JS 最大容器宽度（点）
/// @param maxHeight JS 最大容器高度（点）
- (BOOL)prepareBannerSizeWithMaxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;

/// 让广告源按期望广告尺寸准备本次请求，并返回其实际请求的逻辑尺寸（点）；算不出时返回 CGSizeZero。
/// 子类重写：AdMob 返回锚定自适应尺寸、Carty 返回服务端尺寸吸附到三档后的尺寸。
- (CGSize)resolveBannerRequestSizeWithMaxWidth:(CGFloat)maxWidth;

/// 服务端为该候选下发的 Banner 尺寸（点；不做三档白名单收敛）；未下发或非正数返回 CGSizeZero。
- (CGSize)resolveServerBannerSize;

/// 解析服务端下发的固定三档尺寸（320x50 / 320x100 / 300x250），非法尺寸返回 CGSizeZero。
- (CGSize)resolveFixedBannerSize;

/// 最近一次 prepareBannerSize 成功后的候选尺寸（点）；未成功时为 CGSizeZero。
@property (nonatomic, assign, readonly) CGSize bannerSize;
- (nullable id)getAdObject;
- (SUDMAdObject *)getSUDMAdObject;
- (void)startAutoRefresh;
- (void)stopAutoRefresh;
- (void)destroyAd;
//Callback
- (void)startFinish:(nullable NSError *)error;
- (void)loadFinish;
- (void)loadFail:(NSError *)error;
- (void)adClick;
- (void)adDisplay;
- (void)adDisplayFail:(NSError *)error;
- (void)adReward:(NSDictionary *)rewardInfo;
- (void)adPayRevenue;
- (void)adClose;
- (void)videoPlayStart;
- (void)videoPlayEnd;
- (void)willStartLoad:(id)loadObject;
/// Banner 广告真实尺寸回传（广告源确定最终渲染尺寸后回调，点；仅 Banner 使用）
- (void)adResize:(CGSize)size;

#pragma mark - Auction（竞价扩展）

/// 获取竞价价格（CB 子类应重写，返回 SDK 实时 eCPM）
- (nullable SUDMAdPrice *)getAuctionPrice;

/// 获取有效竞价价格（Non-Bidding 返回配置固定价，CB 返回实时价）
- (nullable SUDMAdPrice *)getEffectiveAuctionPrice;

/// 竞胜通知（CB 子类重写）
- (void)notifyBidWin:(double)winningPriceCents;

/// 竞败通知（CB 子类重写）
- (void)notifyBidLoss:(double)winningPriceCents;

/// 销毁适配器（释放广告资源，标记不可用）
- (void)destroyAdapter;
/// 强制销毁适配器并解除展示中全局保活，仅用于游戏退出/SDK 关闭等终止场景。
- (void)forceDestroyAdapter;

/// 类型判断
- (BOOL)isClientBidding;
- (BOOL)isNonBidding;
- (BOOL)isServerBidding;

@property (nonatomic,readonly)CGFloat ecpm;
@property (nonatomic,assign)BOOL loaded;
/// 全屏广告（插屏/激励/开屏）是否处于展示中（showAd 发起 ~ DidDismiss/ShowFail 回调区间）。
/// 展示期间外部调 destroy 时，Manager 需将其延迟到关闭/失败回调后再回收，避免丢失三方 SDK 的 dismiss 回调。
@property (nonatomic,assign)BOOL isPresenting;
@property (nonatomic,assign)SUDMAdType adType;
@property (nonatomic,assign)NSInteger platformID;
@property (nonatomic,copy)NSString *platformName;
@property (nonatomic,strong)NSDictionary *info;
@property (nonatomic,assign)BOOL didBid;
@property (nonatomic,assign)BOOL priorityDisplay;

#pragma mark - Revenue（展示级收入，用于收入上报）

/// 展示级收入金额（币种百万分之一 micros；无收入回调时为 0）
@property (nonatomic, assign) long long valueMicros;
/// 展示级收入货币码（ISO 4217 大写三位，如 USD；无收入回调时为 nil）
@property (nonatomic, copy, nullable) NSString *currencyCode;

#pragma mark - Auction Properties（竞价策略属性）

/// 竞价类型
@property (nonatomic, assign) SUDMBiddingType biddingType;
/// Non-Bidding 配置固定价（美元美分 eCPM）
@property (nonatomic, assign) double configuredPriceCents;
/// 展示排序权重
@property (nonatomic, assign) NSInteger showSort;
/// 加载排序权重
@property (nonatomic, assign) NSInteger loadSort;
/// 配置顺序（用于同分排序）
@property (nonatomic, assign) NSInteger configOrder;
/// 竞价底价（美元美分 eCPM，仅 CB 使用）
@property (nonatomic, assign) double auctionFloorCents;
/// 预估价（美元美分 eCPM）
@property (nonatomic, assign) double estimatedPriceCents;

#pragma mark - Callback Blocks

@property (nonatomic,copy)void(^startFinishAct)(NSError * _Nullable error,SUDMBaseAdapter *adapter);
@property (nonatomic,copy)void(^loadFinishAct)(SUDMBaseAdapter *adapter);
@property (nonatomic,copy)void(^loadFailAct)(NSError *error,SUDMBaseAdapter *adapter);
@property (nonatomic,copy)void(^adDisplayAct)(SUDMBaseAdapter *adapter);
@property (nonatomic,copy)void(^adDisplayFailAct)(NSError *error,SUDMBaseAdapter *adapter);
@property (nonatomic,copy)void(^adClickAct)(SUDMBaseAdapter *adapter);
@property (nonatomic,copy)void(^adCloseAct)(SUDMBaseAdapter *adapter);
@property (nonatomic,copy)void(^adRewardAct)(NSDictionary *rewardInfo,SUDMBaseAdapter *adapter);
@property (nonatomic,copy)void(^videoPlayStartAct)(SUDMBaseAdapter *adapter);
@property (nonatomic,copy)void(^videoPlayEndAct)(SUDMBaseAdapter *adapter);
@property (nonatomic,copy)void(^adPayRevenueAct)(SUDMBaseAdapter *adapter);
@property (nonatomic, copy)void(^willStartLoadAct)(SUDMBaseAdapter *adapter,id loadObject);
@property (nonatomic, copy)void(^adResizeAct)(CGSize size,SUDMBaseAdapter *adapter);
@end

NS_ASSUME_NONNULL_END
