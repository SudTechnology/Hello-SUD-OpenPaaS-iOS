//
//  SUDDemoHttpService.h
//  HelloSud-iOS
//
//  Created by kaniel on 6/5/26.
//

#import <Foundation/Foundation.h>
#import "SUDDemoEnvConfig.h"
#import "SUDDemoRespModel.h"

NS_ASSUME_NONNULL_BEGIN



@interface SUDDemoHttpService : NSObject
+(instancetype)shared;

/// 登录到接入方服务器
- (void)loginWithOptions:(NSDictionary *)options
              completion:(void(^)(NSDictionary *result, NSError *error))completion;

/// 获取用户签名
- (void)requestUserSignatureWithOptions:(NSDictionary *)options
                             completion:(void(^)(NSDictionary *result, NSError *error))completion;
/// 获取用户敏感信息
- (void)reqUserProfileWithOptions:(NSDictionary *)options
                      completion:(void(^)(NSDictionary *dicUserProfile, NSError *error))completion;

/// 创建支付订单
- (void)reqCreateOrderWithOptions:(NSDictionary *)options
                      completion:(void(^)(NSDictionary *result, NSError *error))completion;

/// 获取支付信息
- (void)reqPayInfoWithOptions:(NSDictionary *)options
                  completion:(void(^)(NSDictionary *result, NSError *error))completion;

/// 查询支付结果
- (void)reqPayResultWithOptions:(NSDictionary *)options
                    completion:(void(^)(NSDictionary *result, NSError *error))completion;

/// 获取广告物料
- (void)reqAdMaterialWithOptions:(NSDictionary *)options
                  completion:(void(^)(NSDictionary *result, NSError *error))completion;

/// 上报激励ssv数据
- (void)reqReportRewardAdSSVWithOptions:(NSDictionary *)options
                             completion:(void(^)(NSDictionary *result, NSError *error))completion;

/// 上报激励视频状态
- (void)reqReportRewardAdStatusWithOptions:(NSDictionary *)options
                                 respClass:(Class)respCls
                                completion:(void(^)(SUDDemoBaseRespModel *resp, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
