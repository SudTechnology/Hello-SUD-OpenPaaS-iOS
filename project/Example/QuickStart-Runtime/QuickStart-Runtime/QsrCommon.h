//
//  QsrCommon.h
//  QuickStart-Runtime
//
//  Created by kaniel on 12/4/25.
//

#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MJExtension/MJExtension.h"
#import <SUDGI/SUDGI-umbrella.h>

#define SUDGI_APP_ID   @"2049108146763776002"
#define SUDGI_APP_KEY  @"LMKp0m44C4jYzbAAjUChSmodNnQq2N9Q"

/// weakself宏
#define WeakSelf __weak typeof(self) weakSelf = self;

NS_ASSUME_NONNULL_BEGIN

@interface QsrCommon : NSObject
@property(nonatomic, strong)NSString *userId;
+(instancetype)shared;

/// 获取用户签名
- (void)requestUserSignatureWithUserId:(NSString *)userid
                            completion:(void(^)(NSString *userSignature, NSError *error))completion;

- (void)reqUserProfileWithUserId:(NSString *)userId
                   encryptedData:(NSString *)encryptedData
                      completion:(void(^)(NSDictionary *dicUserProfile, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
