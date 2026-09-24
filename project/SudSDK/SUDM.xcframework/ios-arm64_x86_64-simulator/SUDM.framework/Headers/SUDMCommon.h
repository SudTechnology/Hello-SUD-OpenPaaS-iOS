//
//  SUDMCommon.h
//  SUDM
//
//  Created by kaniel on 7/24/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSInteger const kSUDMErrorCodeNoAdShow = -20001;
static NSInteger const kSUDMErrorCodeNoMediation = -20002;
static NSInteger const kSUDMErrorCodeNoFill = -20003;
static NSInteger const kSUDMErrorCodeLoadTimeout = -20004;
static NSInteger const kSUDMErrorCodeBelowFloor = -20005;
static NSInteger const kSUDMErrorCodeInvalidPrice = -20006;

/// 本地按广告样式限制加载频率，未发起三方请求
static NSInteger const kSUDMErrorCodeLoadFrequencyLimited = -20007;

/// Initialization parameters
@interface SUDMSDKConfiguration : NSObject

/// App ID
@property(nonatomic, copy) NSString *appId;
/// App Key
@property(nonatomic, copy) NSString *appKey;
@property(nonatomic, copy) NSString *userId;
/// 服务端下发的 bundle_key（OP 初始化透传），用于广告配置 query 与埋点上报
@property(nonatomic, copy) NSString *bundleKey;
@end




NS_ASSUME_NONNULL_END
