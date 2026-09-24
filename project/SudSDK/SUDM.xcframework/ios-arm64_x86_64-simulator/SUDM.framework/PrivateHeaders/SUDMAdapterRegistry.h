//
//  SUDMAdapterRegistry.h
//  SUDM
//
//  广告网络类型 → 适配器类名映射注册表
//  对应 Android SUDMAdapterRegistry.java
//

#import <Foundation/Foundation.h>
#import "SUDMHttpRespModels.h"
#import "SUDMAdCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUDMAdapterRegistry : NSObject

/// 根据网络类型获取适配器类名
+ (nullable NSString *)adapterClassNameForNetwork:(SUDMAdNetworkType)networkType;

/// 根据网络类型获取平台名称
+ (nullable NSString *)networkNameForType:(SUDMAdNetworkType)networkType;

@end

NS_ASSUME_NONNULL_END
