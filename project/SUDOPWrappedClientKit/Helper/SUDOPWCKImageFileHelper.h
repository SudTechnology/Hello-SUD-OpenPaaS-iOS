//
//  SUDOPWCKImageFileHelper.h
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/14/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKImageFileHelper : NSObject

/// 将图片压缩后保存到临时目录
/// @param image 原图
/// @param fileName 文件名，不传则自动生成
/// @param compressionQuality JPEG压缩质量 0~1，PNG时无效
/// @param asPNG 是否按PNG保存，NO则按JPEG保存
/// @param error 错误
/// @return 成功返回临时文件完整路径，失败返回nil
+ (NSString * _Nullable)saveImageToTemporaryDirectory:(UIImage *)image
                                             fileName:(NSString * _Nullable)fileName
                                   compressionQuality:(CGFloat)compressionQuality
                                                asPNG:(BOOL)asPNG
                                                error:(NSError * _Nullable * _Nullable)error;

/// 快捷保存 JPEG 到临时目录
+ (NSString * _Nullable)saveJPEGImageToTemporaryDirectory:(UIImage *)image
                                       compressionQuality:(CGFloat)compressionQuality
                                                    error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END

