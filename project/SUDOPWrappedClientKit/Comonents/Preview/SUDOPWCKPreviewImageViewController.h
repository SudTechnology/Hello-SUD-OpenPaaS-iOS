//
//  SUDOPWCKPreviewImageViewController.h
//  AFNetworking
//
//  Created by kaniel on 5/26/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKPreviewImageViewController : UIViewController

+ (void)showFromViewController:(UIViewController * _Nullable)viewController
                       current:(NSString * _Nullable)current
                          urls:(NSArray<NSString *> *)urls;

@end

NS_ASSUME_NONNULL_END

