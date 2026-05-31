//
//  Common.h
//  QuickStart
//
//  Created by kaniel on 12/4/25.
//

#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MJExtension/MJExtension.h"
#import <SUDGI/SUDGI-umbrella.h>
#import "SUDDemoRespModel.h"

#define SUDGI_APP_ID   @"2049108146763776002"
#define SUDGI_APP_KEY  @"LMKp0m44C4jYzbAAjUChSmodNnQq2N9Q"


/// weakself宏
#define WeakSelf __weak typeof(self) weakSelf = self;

NS_ASSUME_NONNULL_BEGIN

@interface Common : NSObject

@property(nonatomic, strong)NSString *customUserId;// 自定义用户id

/// 获取用户名
+ (NSString *)getUserName;

- (NSString *)currentUserId;

+(instancetype)shared;

/// 获取用户签名
+ (void)requestUserSignatureWithUserId:(NSString *)userid
                            completion:(void(^)(NSString *userSignature, NSError *error))completion;

+ (void)reqUserProfileWithUserId:(NSString *)userId
                   encryptedData:(NSString *)encryptedData
                      completion:(void(^)(NSDictionary *dicUserProfile, NSError *error))completion;
/// 验证订单
+ (void)reqVerifyOrderWithUserId:(NSString *)userId
                        signData:(NSString *)signData
                       signature:(NSString *)signature
                      completion:(void(^)(NSDictionary *result, NSError *error))completion;

/// 模拟支付
+ (void)reqMockPayWithUserId:(NSString *)userId
                  sudTradeNo:(NSString *)sudTradeNo
                      action:(NSString *)action
                  completion:(void(^)(NSDictionary *result, NSError *error))completion;

/// 获取广告物料
+ (void)reqAdMaterialWithUserId:(NSString *)userId
                  completion:(void(^)(NSDictionary *result, NSError *error))completion;

/// 上报激励ssv数据
+ (void)reqReportRewardAdSSVWithOptions:(NSDictionary *)options
                             completion:(void(^)(NSDictionary *result, NSError *error))completion;

/// 上报激励视频状态
+ (void)reqReportRewardAdStatusWithOptions:(NSDictionary *)options
                                 respClass:(Class)respCls
                                completion:(void(^)(SUDDemoBaseRespModel *resp, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
