//
//  SUDOPWCKPhotoHelper.h
//  Pods
//
//  Created by kaniel on 5/13/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKPhotoHelper : NSObject

+ (void)saveImageToPhotosAlbum:(UIImage *)image
                    completion:(void(^ _Nullable)(BOOL success, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
