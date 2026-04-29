//
//  QsrCommon.m
//  QuickStart-Runtime
//
//  Created by kaniel on 12/4/25.
//

#import "QsrCommon.h"
#import "SUDDemoEnvConfig.h"

@implementation QsrCommon

+(instancetype)shared {
    static dispatch_once_t onceToken;
    static QsrCommon *g_common = nil;
    dispatch_once(&onceToken, ^{
        g_common = [[QsrCommon alloc]init];
    });
    return g_common;
}

/// 获取用户签名
- (void)requestUserSignatureWithUserId:(NSString *)userid
                            completion:(void(^)(NSString *userSignature, NSError *error))completion {
    
    
    NSString *url = SUDDemoEnvConfig.getUserSignatureURL;
    NSDictionary *dicParam = @{@"user_id": self.userId, @"app_id":SUDGI_APP_ID };
    [self postHttpRequestWithURL:url param:dicParam completion:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        NSDictionary * dataDic = responseObject[@"data"];
        NSString * userSignature = [dataDic objectForKey:@"user_signature"];
        completion(userSignature, nil);
        
    }];
    
}

- (void)reqUserProfileWithUserId:(NSString *)userId
                   encryptedData:(NSString *)encryptedData
                      completion:(void(^)(NSDictionary *dicUserProfile, NSError *error))completion {
    
    NSDictionary * param = @{@"user_id": userId, @"encrypted_data":encryptedData, @"app_id":SUDGI_APP_ID};
    [self postHttpRequestWithURL:SUDDemoEnvConfig.getUserProfileURL param:param completion:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        NSDictionary * dataDic = responseObject[@"data"];
        completion(dataDic, nil);
    }];
    
}


/// 基础接口请求
/// Basic interface request
- (void)postHttpRequestWithURL:(NSString *)api
                         param:(NSDictionary *)param
                    completion:(void (^ _Nullable)(NSDictionary * _Nullable responseObject, NSError * _Nullable error))completion {
    
    NSURL *url = [NSURL URLWithString:api];
    if (!url) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"SUDHttpErrorDomain"
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey : @"Invalid URL"}];
            completion(nil, error);
        }
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (param) {
        NSError *jsonError = nil;
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&jsonError];
        if (jsonError) {
            if (completion) {
                completion(nil, jsonError);
            }
            return;
        }
        request.HTTPBody = bodyData;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (completion) {
                    completion(nil, error);
                }
                return;
            }
            
            if (!data) {
                if (completion) {
                    NSError *dataError = [NSError errorWithDomain:@"SUDHttpErrorDomain"
                                                             code:-2
                                                         userInfo:@{NSLocalizedDescriptionKey : @"Response data is empty"}];
                    completion(nil, dataError);
                }
                return;
            }
            
            NSError *jsonError = nil;
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&jsonError];
            if (jsonError) {
                if (completion) {
                    completion(nil, jsonError);
                }
                return;
            }
            
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                if (completion) {
                    NSError *typeError = [NSError errorWithDomain:@"SUDHttpErrorDomain"
                                                             code:-3
                                                         userInfo:@{NSLocalizedDescriptionKey : @"Response is not a dictionary"}];
                    completion(nil, typeError);
                }
                return;
            }
            
            NSInteger retCode = [responseObject[@"ret_code"] integerValue];
            if (retCode != 0) {
                NSString *retMsg = responseObject[@"ret_msg"];
                if (![retMsg isKindOfClass:[NSString class]] || retMsg.length == 0) {
                    retMsg = @"Request failed";
                }
                
                NSError *bizError = [NSError errorWithDomain:@"SUDHttpBizErrorDomain"
                                                        code:retCode
                                                    userInfo:@{
                    NSLocalizedDescriptionKey : retMsg,
                    @"responseObject" : responseObject
                }];
                
                if (completion) {
                    completion(nil, bizError);
                }
                return;
            }
            
            if (completion) {
                completion(responseObject, nil);
            }
        });
    }];
    [dataTask resume];
}


@end
