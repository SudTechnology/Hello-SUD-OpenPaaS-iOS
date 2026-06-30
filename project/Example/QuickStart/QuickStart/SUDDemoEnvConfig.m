//
//  SUDDemoEnvConfig.m
//  HelloSudTest-iOS
//
//  Created by kaniel on 4/21/26.
//

#import "SUDDemoEnvConfig.h"

@implementation SUDDemoEnvConfig

+ (NSString *)baseURL {
    return @"https://hello-op.sud.ltd";
}

+ (NSString *)apiURLWithPath:(NSString *)path {
    if (path.length == 0) {
        return [self baseURL];
    }
    
    if (![path hasPrefix:@"/"]) {
        path = [@"/" stringByAppendingString:path];
    }
    
    return [[self baseURL] stringByAppendingString:path];
}

+ (NSString *)loginURL {
    return [self apiURLWithPath:@"/login/v3"];
}

+ (NSString *)getUserSignatureURL {
    return [self apiURLWithPath:@"/v1/app/generate/user/signature"];
}

+ (NSString *)getUserProfileURL {
    return [self apiURLWithPath:@"/v1/app/get/user/profile"];
}

+ (NSString *)createOrderURL {
    return [self apiURLWithPath:@"v1/app/order/create"];
}

+ (NSString *)payInfoURL {
    return [self apiURLWithPath:@"v1/app/pay/wap/pay"];
}

+ (NSString *)queryPayResultURL {
    return [self apiURLWithPath:@"v1/app/pay/wap/query"];
}

+ (NSString *)adMeterialURL {
    return [self apiURLWithPath:@"/v1/app/service/ads/material/query"];
}

+ (NSString *)reportRewarAdSSVDataURL {
    return [self apiURLWithPath:@"/v1/app/service/ads/ad-txn/reward"];
}

+ (NSString *)closeRewarAdURL {
    return [self apiURLWithPath:@"/v1/app/service/ads/ad-txn/complete"];
}

@end
