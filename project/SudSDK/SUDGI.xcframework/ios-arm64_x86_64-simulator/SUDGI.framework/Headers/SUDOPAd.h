//
//  SUDOPAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPCommon.h"
NS_ASSUME_NONNULL_BEGIN

@class SUDOPAd;

@protocol SUDOPAdEventListener <NSObject>
@optional
- (void)sudAdDidLoad:(SUDOPAd *)ad;
- (void)sudAdDidShow:(SUDOPAd *)ad;
- (void)sudAdDidClick:(SUDOPAd *)ad;
- (void)sudAdDidClose:(SUDOPAd *)ad;
- (void)sudAd:(SUDOPAd *)ad didFailWithError:(NSError *)error;
@end

/// Base ad class
@interface SUDOPAd : NSObject
@end

NS_ASSUME_NONNULL_END
