//
//  SUDOPWCKCommon.m
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/13/26.
//

#import "SUDOPWCKCommon.h"
#import "SUDOPWCKLanguageHelper.h"

#define RES_BUNDLE_NAME @"SUDOPWrappedClientKit_Res.bundle"

@implementation SUDOPWCKCommon
+ (NSError *)errorWithCode:(NSInteger)code msg:(NSString *)msg {
    NSString *message = msg;
    if (message.length == 0) {
        message = [SUDOPWCKLanguageHelper localizedStringForKey:@"sudop_wck.error.unknown"
                                                         table:@"SUDOPWrappedClientKitErrors"
                                                  defaultValue:@"Unknown error."];
    }
    NSError *error = [NSError errorWithDomain:@"SUDOPWCKCommonErrorDomain"
                                         code:code
                                     userInfo:@{NSLocalizedDescriptionKey : message}];
    return error;
}

+ (nullable NSBundle *)resourceBundle {
    static NSBundle *resourceBundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray<NSBundle *> *candidateBundles = @[
            [NSBundle bundleForClass:self],
            [NSBundle mainBundle]
        ];
        for (NSBundle *candidate in candidateBundles) {
            if ([candidate.bundleURL.lastPathComponent isEqualToString:RES_BUNDLE_NAME]) {
                resourceBundle = candidate;
                break;
            }
            NSURL *bundleURL = [candidate URLForResource:[RES_BUNDLE_NAME stringByDeletingPathExtension]
                                           withExtension:@"bundle"];
            if (bundleURL) {
                resourceBundle = [NSBundle bundleWithURL:bundleURL];
                if (resourceBundle) {
                    break;
                }
            }
        }
    });
    return resourceBundle;
}

/// 资源bundle路径，缺省值默认 SUD_RES_BUNLE
/// - Parameter bunleName: bunleName description
+(nullable NSString *)resourceBunlePath:(NSString *_Nullable)bunleName {
    if (bunleName.length == 0 || [bunleName isEqualToString:RES_BUNDLE_NAME]) {
        return [self resourceBundle].bundlePath;
    }

    NSBundle *classBundle = [NSBundle bundleForClass:self];
    return [classBundle pathForResource:[bunleName stringByDeletingPathExtension]
                                 ofType:bunleName.pathExtension.length > 0 ? bunleName.pathExtension : @"bundle"];
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
