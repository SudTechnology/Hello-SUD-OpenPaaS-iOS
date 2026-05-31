//
//  SUDOPWCKCommon.m
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/13/26.
//

#import "SUDOPWCKCommon.h"

#define RES_BUNDLE_NAME @"SUDOPWrappedClientKit_Res.bundle"

@implementation SUDOPWCKCommon
+ (NSError *)errorWithCode:(NSInteger)code msg:(NSString *)msg {
    NSError *error = [NSError errorWithDomain:@"SUDOPWCKCommonErrorDomain"
                                         code:code
                                     userInfo:@{NSLocalizedDescriptionKey : msg ?: @"unknow error"}];
    return error;
}

/// 资源bundle路径，缺省值默认 SUD_RES_BUNLE
/// - Parameter bunleName: bunleName description
+(nullable NSString *)resourceBunlePath:(NSString *_Nullable)bunleName {
    
    // 将应用程序目录添加到 search path 中
    NSString *sdkBundlePath = [[NSBundle bundleForClass:self.class] bundlePath];
    NSString *resBundlePath = [sdkBundlePath stringByAppendingPathComponent:bunleName ? bunleName : RES_BUNDLE_NAME];
    return resBundlePath;
}

/// 获取指定文件路径
/// - Parameters:
///   - fileName: fileName description
///   - bunleName: 缺省值默认 SUD_RES_BUNLE
+(nullable NSString *)filePath:(NSString *)fileName bundleName:(NSString *_Nullable)bunleName {
    NSString *resBundlePath = [self resourceBunlePath:bunleName];
    return [resBundlePath stringByAppendingPathComponent:fileName];
}

+(UIImage *)imageWithName:(NSString *)name {
    NSString *imagePath = [self filePath:name bundleName:nil];
    UIImage *image = nil;
    if (imagePath) {
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    return image;
}

+(CGFloat)pointFromPx:(CGFloat)px {

    CGFloat scale = [UIScreen mainScreen].nativeScale;
    if (scale == 0) {
        scale = 1.0;
    }
    return px / scale;
}

+(CGFloat)pxFromPoint:(CGFloat)point {
    CGFloat scale = [UIScreen mainScreen].nativeScale;
    return point * scale;
}
@end
