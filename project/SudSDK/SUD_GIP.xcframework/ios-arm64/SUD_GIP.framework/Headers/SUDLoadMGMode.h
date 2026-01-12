//
// Created by guanghui on 2022/7/5.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SUDLoadMGMode)
{
    /// unspecified
    kSudLoadMGModeUnspecified = -1,
    /// normal, 正常模式
    kSudLoadMGModeNormal = 0,
    /// AuthCrossApp，跨域App
    kSudLoadMgModeAppCrossAuth = 1,
};
