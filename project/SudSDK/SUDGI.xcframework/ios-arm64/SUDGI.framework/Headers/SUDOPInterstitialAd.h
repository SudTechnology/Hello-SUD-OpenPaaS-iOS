//
//  SUDOPInterstitialAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SUDOPInterstitialAd;
/// Game->APP event
@protocol SUDOPInterstitialAdDelegate <NSObject>
- (void)interstitialAdShow:(SUDOPInterstitialAd *)interstitialAd;
- (void)interstitialAdHide:(SUDOPInterstitialAd *)interstitialAd;
- (void)interstitialAdDestroy:(SUDOPInterstitialAd *)interstitialAd;
@end


/// banner
@interface SUDOPInterstitialAd : NSObject
@property(nonatomic, strong)NSString *adUnitId;
@property(nonatomic, weak)id<SUDOPInterstitialAdDelegate> delegte;

/// notify ad Loaded
- (void)notifyOnLoad;

- (void)notifyOnClose;

/// notify ad error
- (void)notifyOnError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
