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

@property(nonatomic, strong)UIViewController *viewController;
@end

NS_ASSUME_NONNULL_END
