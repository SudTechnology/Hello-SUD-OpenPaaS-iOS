//
//  SUDOPWCKActionSheet.h
//  SUDGI
//
//  Created by kaniel on 5/24/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKActionSheet : NSObject

/// Presents an action sheet.
/// @param viewController The presenting view controller.
/// @param alertText The message displayed above the options.
/// @param itemList The option titles.
/// @param itemColor The option text color. The default is black (#000000).
/// @param completion Returns the selected option index, or -1 when cancelled.
+ (void)showInViewController:(UIViewController *)viewController
                   alertText:(nullable NSString *)alertText
                    itemList:(NSArray<NSString *> *)itemList
                   itemColor:(nullable NSString *)itemColor
                  completion:(void(^ _Nullable)(NSInteger index))completion;

@end

NS_ASSUME_NONNULL_END
