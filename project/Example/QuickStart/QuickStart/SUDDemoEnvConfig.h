//
//  SUDDemoEnvConfig.h
//  HelloSudTest-iOS
//
//  Created by kaniel on 4/21/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDDemoEnvConfig : NSObject


/// base URL
+ (NSString *)baseURL;

/// 拼接完整接口地址
+ (NSString *)apiURLWithPath:(NSString *)path;

/// 具体接口
+ (NSString *)loginURL;
+ (NSString *)getUserSignatureURL;
+ (NSString *)getUserProfileURL;
+ (NSString *)verifyOrderURL;
+ (NSString *)mockPayURL;

@end

NS_ASSUME_NONNULL_END

