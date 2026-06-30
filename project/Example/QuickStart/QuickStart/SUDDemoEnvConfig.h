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
+ (NSString *)createOrderURL;
+ (NSString *)payInfoURL;
+ (NSString *)queryPayResultURL;
+ (NSString *)adMeterialURL;
+ (NSString *)reportRewarAdSSVDataURL;
+ (NSString *)closeRewarAdURL;

@end

NS_ASSUME_NONNULL_END

