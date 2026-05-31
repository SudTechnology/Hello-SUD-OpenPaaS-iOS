//
//  DemoWrappedClientHandler.h
//  HelloSud-iOS
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPWrappedClientKit-umbrella.h"
NS_ASSUME_NONNULL_BEGIN
/// 实现SDKwrapped类接口模块
@interface DemoWrappedClientHandler : SUDOPWCKDefaultWrappedClient
@property(nonatomic, weak)UIView *gameContentView;

- (void)cleanup;
@end


NS_ASSUME_NONNULL_END
