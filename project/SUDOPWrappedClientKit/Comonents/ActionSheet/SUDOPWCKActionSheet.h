//
//  SUDOPWCKActionSheet.h
//  SUDGI
//
//  Created by kaniel on 5/24/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKActionSheet : NSObject

/// 展示 ActionSheet
/// @param viewController 当前控制器
/// @param alertText 顶部提示文本
/// @param itemList 选项数组
/// @param itemColor 选项文字颜色，默认黑色 #000000
/// @param completion 点击选项返回索引，取消返回 -1
+ (void)showInViewController:(UIViewController *)viewController
                   alertText:(nullable NSString *)alertText
                    itemList:(NSArray<NSString *> *)itemList
                   itemColor:(nullable NSString *)itemColor
                  completion:(void(^ _Nullable)(NSInteger index))completion;

@end

NS_ASSUME_NONNULL_END
