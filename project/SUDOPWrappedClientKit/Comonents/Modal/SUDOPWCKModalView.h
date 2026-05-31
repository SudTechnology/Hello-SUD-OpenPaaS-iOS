//
//  SUDOPWCKModalView.h
//  AFNetworking
//
//  Created by kaniel on 5/25/26.
//

#import <UIKit/UIKit.h>
#import "SUDOPWCKModalOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKModalView : UIView

+ (instancetype)showInViewController:(UIViewController * _Nullable)viewController
                             options:(SUDOPWCKModalOptions *)options
                              cancel:(void(^ _Nullable)(void))cancelBlock
                             confirm:(void(^ _Nullable)(NSString * _Nullable inputText))confirmBlock;

- (void)hide;

@end

NS_ASSUME_NONNULL_END


