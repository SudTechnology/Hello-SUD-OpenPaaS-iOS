//
//  SUDMAdCommon.h
//  SUDM
//
//  Created by kaniel on 7/27/26.
//

#import <Foundation/Foundation.h>
#import "SUDMCommon.h"
NS_ASSUME_NONNULL_BEGIN

/// 广告类型
typedef NS_ENUM(NSInteger, SUDMAdType) {
    /// 未知
    SUDMAdTypeUnknown = 0,
    /// 横幅 / Banner
    SUDMAdTypeBanner = 1,
    /// 激励视频
    SUDMAdTypeRewardedVideo = 2,
    /// 插屏
    SUDMAdTypeInterstitial = 3,
    /// 信息流 / 原生
    SUDMAdTypeNative = 4,
    /// 开屏
    SUDMAdTypeAppOpen = 6,
    /// 激励插屏
    SUDMAdTypeRewardedInterstitial = 7
};



@interface SUDMAdCommon : NSObject
+ (NSError *)errorWithCode:(NSInteger)errorCode;

@end

NS_ASSUME_NONNULL_END
