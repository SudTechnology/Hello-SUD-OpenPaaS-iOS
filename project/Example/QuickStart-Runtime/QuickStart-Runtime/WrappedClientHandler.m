//
//  WrappedClientHandler.m
//  HelloSud-iOS
//
//  Created by kaniel on 4/13/26.
//

#import "WrappedClientHandler.h"
#import "QsrCommon.h"


@interface WrappedClientHandler()



@end

@implementation WrappedClientHandler



- (void)onGetLegacyUserIdentity:(id<SUDOPStateHandle>)stateHandle dataJson:(NSString*)dataJson {

    NSDictionary *dic = @{
        @"uid":@"1234",
    };
    NSString *result = [dic mj_JSONString];
    [stateHandle success:result];
    
}

- (void)onGetUserInfo:(id<SUDOPStateHandle>)stateHandle dataJson:(NSString*)dataJson {
    NSDictionary *dic = @{
        @"nickname":@"demo name",
        @"avatar":@"demo avatar",
    };
    NSString *result = [dic mj_JSONString];
    [stateHandle success:result];
}

- (void)onGetUserProfile:(id<SUDOPStateHandle>)stateHandle dataJson:(NSString*)dataJson {
    
    NSString *userId = QsrCommon.shared.userId;
    NSDictionary *dic = [dataJson mj_JSONObject];
    NSString *encryptedData = dic[@"encryptedData"];
    [QsrCommon.shared reqUserProfileWithUserId:userId encryptedData:encryptedData completion:^(NSDictionary * _Nonnull dicUserProfile, NSError * _Nonnull error) {
        if (error) {
            [stateHandle failure:error];
            return;
        }
        NSString *userProfileJsonStr = dicUserProfile[@"user_profile_data"];
        [stateHandle success:userProfileJsonStr];
    }];
}




- (void)cleanup {

}

@end
