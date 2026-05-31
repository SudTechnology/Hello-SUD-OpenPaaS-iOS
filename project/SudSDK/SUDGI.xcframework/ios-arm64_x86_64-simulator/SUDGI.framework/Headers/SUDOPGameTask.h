//
//  SUDOPGameTask.h
//  Pods
//
//  Created by kaniel on 3/11/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SUDOPCommon.h"
NS_ASSUME_NONNULL_BEGIN
/**
 * Protocol for managing a game-related task instance.
 * Provides control over the lifecycle of asynchronous operations such as pre-loading.
 */
@protocol SUDOPGameTask <NSObject>

/**
 * Cancels the ongoing task and releases associated resources.
 */
- (void)destroy;
@end
NS_ASSUME_NONNULL_END
