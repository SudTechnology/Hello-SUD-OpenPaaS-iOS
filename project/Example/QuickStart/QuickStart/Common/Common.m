//
//  Common.m
//  QuickStart
//
//  Created by kaniel on 12/4/25.
//
#import <CommonCrypto/CommonDigest.h>
#import "Common.h"
#import "SUDDemoEnvConfig.h"
#import "HttpRequest.h"
@implementation Common

+(instancetype)shared {
    static dispatch_once_t onceToken;
    static Common *g_common = nil;
    dispatch_once(&onceToken, ^{
        g_common = [[Common alloc]init];
    });
    return g_common;
}

- (NSString *)currentUserId {
    NSString *userId = [Common getUserName];
    if (Common.shared.customUserId.length > 0) {
        userId = Common.shared.customUserId;
    }
    return userId;
}

/// 获取用户名
+ (NSString *)getUserName {
    return [self MD5ForLower8Bate:[self getUUID]];
}

/// 获取uuid
+ (NSString *)getUUID {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;;
}

// 8位小写
+(NSString *)MD5ForLower8Bate:(NSString *)str {
    NSString *md5Str = [self MD5ForLower32Bate:str];
    NSString  *string = [md5Str substringWithRange:NSMakeRange(8, 8)];
    return string;
}

// 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str{
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}

/// 获取用户签名
+ (void)requestUserSignatureWithUserId:(NSString *)userid
                            completion:(void(^)(NSString *userSignature, NSError *error))completion {
    
    
    NSString *url = SUDDemoEnvConfig.getUserSignatureURL;
    NSDictionary *dicParam = @{@"user_id": userid, @"app_id":SUDGI_APP_ID };
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

+ (void)reqUserProfileWithUserId:(NSString *)userId
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
+ (void)postHttpRequestWithURL:(NSString *)api
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
