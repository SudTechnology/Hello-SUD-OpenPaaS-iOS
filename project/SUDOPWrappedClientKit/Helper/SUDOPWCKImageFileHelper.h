//
//  SUDOPWCKImageFileHelper.h
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/14/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKImageFileHelper : NSObject

/// Compresses and saves an image to the temporary directory.
/// @param image The source image.
/// @param fileName The file name. Pass nil to generate one automatically.
/// @param compressionQuality The JPEG compression quality from 0 to 1. Ignored for PNG output.
/// @param asPNG YES to save as PNG; NO to save as JPEG.
/// @param error Receives an error if the operation fails.
/// @return The complete temporary file path on success, or nil on failure.
+ (NSString * _Nullable)saveImageToTemporaryDirectory:(UIImage *)image
                                             fileName:(NSString * _Nullable)fileName
                                   compressionQuality:(CGFloat)compressionQuality
                                                asPNG:(BOOL)asPNG
                                                error:(NSError * _Nullable * _Nullable)error;

/// Saves a JPEG image to the temporary directory.
+ (NSString * _Nullable)saveJPEGImageToTemporaryDirectory:(UIImage *)image
                                       compressionQuality:(CGFloat)compressionQuality
                                                    error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
