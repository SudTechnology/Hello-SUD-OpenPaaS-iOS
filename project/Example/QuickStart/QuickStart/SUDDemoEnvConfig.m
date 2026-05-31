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

+ (NSString *)verifyOrderURL {
    return [self apiURLWithPath:@"/v1/app/pay/validate"];
}

+ (NSString *)mockPayURL {
    return [self apiURLWithPath:@"/v1/app/pay/mock"];
}

@end
