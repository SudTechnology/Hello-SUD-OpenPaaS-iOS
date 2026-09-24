//
//  SUDOPDefaultWrappedClient.h
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPWCKCommon.h"
NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKDefaultWrappedClient : NSObject<
SUDOPWrappedClientDelegate,
SUDRTGameQueryPermissionListener,
SUDRTGameQuerySystemPermissionListener>

@property(nonatomic, weak)UIViewController *viewController;
@property(nonatomic, weak)UIView *gameView;

/// The language used by the Kit UI. Nil, an empty string, or an unsupported value selects the default language, en.
@property(nonatomic, copy, nullable)NSString *preferredLanguage;
@end

NS_ASSUME_NONNULL_END
