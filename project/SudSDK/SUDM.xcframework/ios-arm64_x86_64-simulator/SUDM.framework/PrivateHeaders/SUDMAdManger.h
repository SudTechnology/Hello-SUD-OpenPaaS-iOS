

#import <Foundation/Foundation.h>
#import "SUDMBaseAdapter.h"
#import "SUDMNativeView.h"

@class SUDMAdReportSession;
@class SUDMAdUnitStrategy;
@class SUDMAuctionSession;

NS_ASSUME_NONNULL_BEGIN

@interface SUDMAdManger : NSObject

- (void)setPlatforms:(id)platforms;
/// 新：通过 SUDMAdUnitStrategy 配置（竞价模式）
- (void)configureWithStrategy:(SUDMAdUnitStrategy *)strategy;
- (BOOL)isReady;
- (void)loadAd;
- (void)showAd:(nullable UIViewController *)viewController;
- (nullable UIView *)getBannerView:(nullable UIViewController *)viewController;
- (void)renderWithNativeView:(SUDMNativeView *)nativeView viewController:(nullable UIViewController *)viewController;
- (void)startAutoRefresh;
- (void)stopAutoRefresh;
- (void)destroyAd;
/// 销毁所有 adapter（包括竞价 session）
- (void)destroy;
/// 终止场景强制销毁所有 adapter，包括展示中全局保活的 adapter。
- (void)forceDestroy;

@property (nonatomic,copy)NSString *customRewardString;
@property (nonatomic,assign)CGFloat delayTime;
@property (nonatomic,strong)NSMutableArray <SUDMBaseAdapter *>*adapterArray;
/// 当前已经成功展示的广告源；Banner 尺寸回调只接受该 adapter。
@property (nonatomic,weak,nullable) SUDMBaseAdapter *displayedAdapter;
@property (nonatomic,strong,nullable)SUDMAdReportSession *reportSession;
@property (nonatomic, copy) void (^willStartLoadAct)(SUDMBaseAdapter *adapter,id loadObject);
@property (nonatomic, copy) void (^loadedAdapterAct)(SUDMBaseAdapter *adapter);
@property (nonatomic, copy) void (^loadFailedAct)(NSError *error);
@property (nonatomic, copy) void (^loadAdapterFailedAct)(NSError *error,SUDMBaseAdapter *adapter);
@property (nonatomic, copy) void (^loadAllFinish)(void);

@property (nonatomic, copy) void (^showAct)(SUDMBaseAdapter *adapter);
@property (nonatomic, copy) void (^showFailedAct)(NSError *error, SUDMBaseAdapter * _Nullable adapter);
@property (nonatomic, copy) void (^clickAct)(SUDMBaseAdapter *adapter);
@property (nonatomic, copy) void (^closeAct)(SUDMBaseAdapter *adapter);
@property (nonatomic, copy) void (^rewardAct)(SUDMBaseAdapter *adapter,NSDictionary *rewardInfo);
@property (nonatomic, copy) void (^adPayRevenueAct)(SUDMBaseAdapter *adapter);
@property (nonatomic, copy) void (^adResizeAct)(SUDMBaseAdapter *adapter, CGSize size);

/// 竞价模式标识
@property (nonatomic, assign, readonly) BOOL isAuctionMode;

/// JS 提供的 Banner 最大容器尺寸（点）。加载 Banner 前用于候选尺寸过滤；未设置（<=0）时不过滤。
/// 固定尺寸候选按服务端下发尺寸判断是否可用；自适应候选按 Adapter 计算结果判断。
@property (nonatomic, assign) CGFloat bannerMaxWidth;
@property (nonatomic, assign) CGFloat bannerMaxHeight;

@end

NS_ASSUME_NONNULL_END
