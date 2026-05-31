//
//  SUDOPWCKImageFileHelper.m
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/14/26.
//

#import "SUDOPWCKImageFileHelper.h"

@implementation SUDOPWCKImageFileHelper

+ (NSString * _Nullable)saveImageToTemporaryDirectory:(UIImage *)image
                                             fileName:(NSString * _Nullable)fileName
                                   compressionQuality:(CGFloat)compressionQuality
                                                asPNG:(BOOL)asPNG
                                                error:(NSError * _Nullable * _Nullable)error {
    if (!image) {
        if (error) {
            *error = [NSError errorWithDomain:@"SUDOPWCKImageFileHelperErrorDomain"
                                         code:-1
                                     userInfo:@{NSLocalizedDescriptionKey : @"image is nil"}];
        }
        return nil;
    }
    
    NSData *imageData = nil;
    NSString *ext = nil;
    
    if (asPNG) {
        imageData = UIImagePNGRepresentation(image);
        ext = @"png";
    } else {
        CGFloat quality = compressionQuality;
        if (quality < 0) quality = 0;
        if (quality > 1) quality = 1;
        imageData = UIImageJPEGRepresentation(image, quality);
        ext = @"jpg";
    }
    
    if (!imageData) {
        if (error) {
            *error = [NSError errorWithDomain:@"SUDOPWCKImageFileHelperErrorDomain"
                                         code:-2
                                     userInfo:@{NSLocalizedDescriptionKey : @"failed to generate image data"}];
        }
        return nil;
    }
    
    NSString *tmpDir = NSTemporaryDirectory();
    if (tmpDir.length == 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"SUDOPWCKImageFileHelperErrorDomain"
                                         code:-3
                                     userInfo:@{NSLocalizedDescriptionKey : @"temporary directory not found"}];
        }
        return nil;
    }
    
    NSString *finalFileName = fileName;
    if (finalFileName.length == 0) {
        NSString *uuid = [NSUUID UUID].UUIDString;
        finalFileName = [NSString stringWithFormat:@"%@.%@", uuid, ext];
    } else {
        if (![finalFileName.pathExtension.lowercaseString isEqualToString:ext]) {
            finalFileName = [[finalFileName stringByDeletingPathExtension] stringByAppendingPathExtension:ext];
        }
    }
    
    NSString *filePath = [tmpDir stringByAppendingPathComponent:finalFileName];
    BOOL success = [imageData writeToFile:filePath options:NSDataWritingAtomic error:error];
    if (!success) {
        return nil;
    }
    
    return filePath;
}

+ (NSString * _Nullable)saveJPEGImageToTemporaryDirectory:(UIImage *)image
                                       compressionQuality:(CGFloat)compressionQuality
                                                    error:(NSError * _Nullable * _Nullable)error {
    return [self saveImageToTemporaryDirectory:image
                                      fileName:nil
                            compressionQuality:compressionQuality
                                         asPNG:NO
                                         error:error];
}

@end

