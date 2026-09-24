#import <Foundation/Foundation.h>
#import "SUDMBaseAdapter.h"

NS_ASSUME_NONNULL_BEGIN

/// TopOn（AnyThinkSDK / TPNiOS）广告适配器。
/// 单类多类型实现，通过 self.adType 区分 Banner / RewardedVideo / Interstitial / Native / AppOpen / RewardedInterstitial。
@interface SUDMTopOnAdapter : SUDMBaseAdapter

@end

NS_ASSUME_NONNULL_END