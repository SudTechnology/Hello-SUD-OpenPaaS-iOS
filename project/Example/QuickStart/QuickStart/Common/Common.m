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

- (NSString *)selectedGameAppId {
    return SUDGI_APP_ID;
}

- (NSString *)selectedGameAppKey {
    return SUDGI_APP_KEY;
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

- (void)openLink:(NSString *)link {
    if (link.length == 0) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:link];
    if (!url) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        
        if (![application canOpenURL:url]) {
            NSLog(@"can not open url: %@", link);
            return;
        }
        
        if (@available(iOS 10.0, *)) {
            [application openURL:url
                         options:@{}
               completionHandler:^(BOOL success) {
                NSLog(@"open url result: %@", success ? @"success" : @"failed");
            }];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [application openURL:url];
#pragma clang diagnostic pop
        }
    });
}
@end
