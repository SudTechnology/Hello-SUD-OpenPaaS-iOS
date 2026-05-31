//
//  SUDOPInterstitialAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPAd.h"
NS_ASSUME_NONNULL_BEGIN

/// Interstitial ad
@interface SUDOPInterstitialAd : SUDOPAd

/// notify ad Loaded
- (void)notifyDidLoad;

- (void)notifyDidClose;

/// notify ad error
- (void)notifyError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
