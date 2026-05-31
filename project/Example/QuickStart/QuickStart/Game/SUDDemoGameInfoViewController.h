//
//  SUDDemoGameInfoViewController.h
//  HelloSud-iOS
//
//  Created by kaniel on 5/30/26.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SUDOPGameInformation;

@interface SUDDemoGameInfoViewController : UIViewController

@property (nonatomic, strong) SUDOPGameInformation *gameInformation;

/// present 方式展示
+ (void)presentFromViewController:(UIViewController * _Nullable)viewController
                  gameInformation:(SUDOPGameInformation *)gameInformation;

@end

NS_ASSUME_NONNULL_END
