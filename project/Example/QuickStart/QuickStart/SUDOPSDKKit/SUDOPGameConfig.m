//
//  SUDOPGameConfig.m
//  HelloSud-iOS
//
//  Created by kaniel on 5/31/26.
//

#import "SUDOPGameConfig.h"

@implementation SUDOPGameConfig

- (instancetype)initWithAppId:(NSString *)appId
                       appKey:(NSString *)appKey
                       userId:(NSString *)userId {
    self = [super init];
    if (self) {
        _appId = [appId copy];
        _appKey = [appKey copy];
        _userId = [userId copy];
    }
    return self;
}

@end
