//
//  SUDOPWCKImagePickerHelper.h
//  SUDGI
//
//  Created by kaniel on 5/14/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKImagePickerHelper : NSObject

/// Selects one or more images from the camera or photo library.
/// @param viewController The view controller used to present the picker.
/// @param sourceTypes Supported values: @[@"album"], @[@"camera"], or @[@"album", @"camera"].
/// @param maxCount The maximum selection count. Values less than or equal to zero are treated as 1.
/// @param allowsEditing Whether editing is allowed. This only applies to UIImagePickerController; PHPicker does not provide system cropping.
/// @param completion Returns the selected images. The error is non-nil when the operation is cancelled or fails.
+ (void)chooseImagesFromViewController:(UIViewController * _Nullable)viewController
                           sourceTypes:(NSArray<NSString *> *)sourceTypes
                              maxCount:(NSInteger)maxCount
                         allowsEditing:(BOOL)allowsEditing
                            completion:(void(^ _Nullable)(NSArray<UIImage *> * _Nullable images, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
