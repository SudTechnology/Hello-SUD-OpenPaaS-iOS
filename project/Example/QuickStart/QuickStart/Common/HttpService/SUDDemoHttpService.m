//
//  SUDDemoHttpService.m
//  HelloSud-iOS
//
//  Created by kaniel on 6/5/26.
//

#import "SUDDemoHttpService.h"
#import "HttpRequest.h"

@implementation SUDDemoHttpService
+(instancetype)shared {
    static dispatch_once_t onceToken;
    static SUDDemoHttpService *instance;
    dispatch_once(&onceToken, ^{
        instance = [[SUDDemoHttpService alloc]init];
    });
    return instance;
}

- (NSError *)errorWithCode:(NSInteger)retCode retMsg:(const NSString *_Nullable)retMsg {
    return [NSError errorWithDomain:@"request error" code:retCode userInfo:@{NSLocalizedDescriptionKey:retMsg ? retMsg : @""}];
}

- (void)postRequestWithURL:(NSString *)api
                     param:(NSDictionary *)param
                    header:(NSDictionary *)header
                 respClass:(Class)respCls
                   success:(void (^)(SUDDemoBaseRespModel *resp))success
                   failure:(void (^)(NSError *error))failure {
    NSLog(@"req api:%@, param:%@", api, param);
    if (api.length == 0) {
        
        NSLog( @"req url is nil");
        if (failure) {
            failure([self errorWithCode:-1 retMsg:@"req url is nil"]);
        }
        return;
    }

    [HttpRequest postRequestWithApi:api param:param success:^(NSDictionary * _Nullable rootDict) {
        NSLog(@"resp api:%@, rootDict:%@", api, rootDict);
        if ([respCls isSubclassOfClass:SUDDemoBaseRespModel.class]) {
            id temp = [respCls decodeModel:rootDict];
            SUDDemoBaseRespModel *resp = temp;
            if (resp.ret_code == 0) {
                if (success) success(resp);
                return;
            }
            if (failure) {
                failure([self errorWithCode:resp.ret_code retMsg:resp.ret_msg]);
            }
            NSLog( @"resp api:%@, error:%@(%@)", api, resp.ret_msg,@(resp.ret_code));
        } else {
            NSLog( @"resp class is a not the subclass of SUDDemoBaseRespModel");
        }
    } failure:^(NSError * error) {
        NSLog( @"resp api:%@, error:%@", api, error.localizedDescription);
        if (failure) failure(error);
    }];
    
}

/// 登录到接入方服务器
- (void)loginWithOptions:(NSDictionary *)options
                  completion:(void(^)(NSDictionary *result, NSError *error))completion {

    NSDictionary * param = options;
    [self postRequestWithURL:SUDDemoEnvConfig.loginURL param:param header:nil respClass:SUDDemoBaseRespModel.class success:^(SUDDemoBaseRespModel *resp) {
        completion(resp.data, nil);
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
    
}

/// 获取用户签名
- (void)requestUserSignatureWithOptions:(NSDictionary *)options
                             completion:(void(^)(NSDictionary *result, NSError *error))completion {
    
    NSDictionary * param = options;
    [self postRequestWithURL:SUDDemoEnvConfig.getUserSignatureURL param:param header:nil respClass:SUDDemoBaseRespModel.class success:^(SUDDemoBaseRespModel *resp) {
        completion(resp.data, nil);
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
    
}

- (void)reqUserProfileWithOptions:(NSDictionary *)options
                      completion:(void(^)(NSDictionary *dicUserProfile, NSError *error))completion {

    NSDictionary * param = options;
    [self postRequestWithURL:SUDDemoEnvConfig.getUserProfileURL param:param header:nil respClass:SUDDemoBaseRespModel.class success:^(SUDDemoBaseRespModel *resp) {
        completion(resp.data, nil);
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
}

/// 创建支付订单
- (void)reqCreateOrderWithOptions:(NSDictionary *)options
                      completion:(void(^)(NSDictionary *result, NSError *error))completion {

    NSDictionary * param = options;
    [self postRequestWithURL:SUDDemoEnvConfig.createOrderURL param:param header:nil respClass:SUDDemoBaseRespModel.class success:^(SUDDemoBaseRespModel *resp) {
        completion(resp.data, nil);
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
}

/// 获取支付信息
- (void)reqPayInfoWithOptions:(NSDictionary *)options
                  completion:(void(^)(NSDictionary *result, NSError *error))completion {
    
    
    NSDictionary * param = options;
    [self postRequestWithURL:SUDDemoEnvConfig.payInfoURL param:param header:nil respClass:SUDDemoBaseRespModel.class success:^(SUDDemoBaseRespModel *resp) {
        completion(resp.data, nil);
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
    
}

/// 查询支付结果
- (void)reqPayResultWithOptions:(NSDictionary *)options
                    completion:(void(^)(NSDictionary *result, NSError *error))completion {

    NSDictionary * param = options;
    [self postRequestWithURL:SUDDemoEnvConfig.queryPayResultURL param:param header:nil respClass:SUDDemoBaseRespModel.class success:^(SUDDemoBaseRespModel *resp) {
        completion(resp.data, nil);
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
}

/// 获取广告物料
- (void)reqAdMaterialWithOptions:(NSDictionary *)options
                     completion:(void(^)(NSDictionary *result, NSError *error))completion {
    NSDictionary * param = options;
    [self postRequestWithURL:SUDDemoEnvConfig.adMeterialURL param:param header:nil respClass:SUDDemoBaseRespModel.class success:^(SUDDemoBaseRespModel *resp) {
        completion(resp.data, nil);
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
}

/// 上报激励ssv数据
- (void)reqReportRewardAdSSVWithOptions:(NSDictionary *)options
                             completion:(void(^)(NSDictionary *result, NSError *error))completion {
    NSDictionary * param = options;
    [self postRequestWithURL:SUDDemoEnvConfig.reportRewarAdSSVDataURL param:param header:nil respClass:SUDDemoBaseRespModel.class success:^(SUDDemoBaseRespModel *resp) {
        completion(resp.data, nil);
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
}

/// 上报激励视频状态
- (void)reqReportRewardAdStatusWithOptions:(NSDictionary *)options
                                 respClass:(Class)respCls
                                completion:(void(^)(SUDDemoBaseRespModel *resp, NSError *error))completion {
    NSDictionary * param = options;
    [self postRequestWithURL:SUDDemoEnvConfig.closeRewarAdURL param:param header:nil respClass:SUDDemoBaseRespModel.class success:^(SUDDemoBaseRespModel *resp) {
        completion(resp, nil);
    } failure:^(NSError *error) {
        completion(nil, error);
    }];
}
@end
