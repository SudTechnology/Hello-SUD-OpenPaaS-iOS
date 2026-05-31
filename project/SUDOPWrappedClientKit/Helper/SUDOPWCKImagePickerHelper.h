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

/// 选择图片（支持拍照/相册，多张）
/// @param viewController 当前控制器
/// @param sourceTypes 可传：@[@"album"], @[@"camera"], @[@"album", @"camera"]
/// @param maxCount 最大选择数量，<=0 按 1 处理
/// @param allowsEditing 是否允许编辑（仅 UIImagePickerController 路径有效；PHPicker 不支持系统裁剪）
/// @param completion 返回图片数组；取消/失败时 error 非空
+ (void)chooseImagesFromViewController:(UIViewController * _Nullable)viewController
                           sourceTypes:(NSArray<NSString *> *)sourceTypes
                              maxCount:(NSInteger)maxCount
                         allowsEditing:(BOOL)allowsEditing
                            completion:(void(^ _Nullable)(NSArray<UIImage *> * _Nullable images, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END

