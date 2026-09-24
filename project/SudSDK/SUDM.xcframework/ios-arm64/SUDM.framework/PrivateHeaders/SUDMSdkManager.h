//
//  SUDMSdkManager.h
//  SUDM
//
//  Created by kaniel on 7/24/26.
//

#import <Foundation/Foundation.h>
#import "SUDMCommon.h"
#import "SUDMPrivacyConfig.h"
#import "SUDMAdConfigManager.h"

@class SUDMBaseAdapter;
NS_ASSUME_NONNULL_BEGIN

@interface SUDMSdkManager : NSObject

@property(nonatomic, strong)SUDMAdConfigManager *adConfigManager;

@property(nonatomic, strong)NSString *appId;
@property(nonatomic, strong)NSString *appKey;
@property(nonatomic, strong)NSString *userId;
/// 服务端下发的 bundle_key（OP 初始化透传），用于广告配置 query 与埋点上报
@property(nonatomic, strong)NSString *bundleKey;

@property(nonatomic, assign)BOOL isInitedSdk;
+(instancetype)shared;
- (void)updateSdkWithConfig:(SUDMSDKConfiguration *)configuration;
/// 更新隐私配置快照并重放下发到所有已创建的 adapter。
/// 可在初始化前调用（快照在 adapter 创建时下发），也可在初始化后调用（热更新）。
/// 传入 nil 表示清空快照：清空同样会重放给全部存活 adapter，清除其旧快照与本地资格判断状态。
- (void)updatePrivacyConfig:(nullable SUDMPrivacyConfig *)config;
/// 当前生效的隐私配置快照（nil 表示未设置）。供广告请求创建 adapter 时读取。
- (nullable SUDMPrivacyConfig *)currentPrivacyConfig;
/// 将当前最新隐私快照（含 nil 清空）应用到指定 adapter。
/// 与 updatePrivacyConfig: 共用同一版本裁决：应用期间若又发布更新的快照会自动补发最新值，
/// 避免旧快照在新快照之后提交到 adapter。创建/启动 adapter 前应调用本方法。
- (void)applyLatestPrivacyConfigToAdapter:(SUDMBaseAdapter *)adapter;
- (void)handleUinitialize;
@end

NS_ASSUME_NONNULL_END
