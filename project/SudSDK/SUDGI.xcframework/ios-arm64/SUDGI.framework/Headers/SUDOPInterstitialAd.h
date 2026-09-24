//
//  SUDOPInterstitialAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPAd.h"
NS_ASSUME_NONNULL_BEGIN

@class SUDOPInterstitialAd;
/// Game->APP event
@protocol SUDOPInterstitialAdDelegate <NSObject>

/**
 Called when the ad has finished loading and is ready to be shown.
 @param ad The ad object that finished loading.
 */
- (void)interstitialAdLoad:(SUDOPInterstitialAd *)ad withStateHandle:(id<SUDOPStateHandle>)stateHandle;

/**
 Notifies that the ad has been shown.
 @param ad The ad object being displayed.
 */
- (void)interstitialAdShow:(SUDOPInterstitialAd *)ad withStateHandle:(id<SUDOPStateHandle>)stateHandle;


/**
 Notifies that the ad has been destroyed and should be cleaned up.
 @param ad The ad object being destroyed.
 */
- (void)interstitialAdDestroy:(SUDOPInterstitialAd *)ad;

@end

/// Interstitial ad
@interface SUDOPInterstitialAd : SUDOPAd
/**
 The unique identifier for the ad unit.
 This ID is used to identify which ad placement to load and display.
 */
@property(nonatomic, strong) NSString *adUnitId;
@property(nonatomic, weak) id<SUDOPInterstitialAdDelegate> delegate;

/**
 Notifies that the ad content has finished loading (data is ready but not yet displayed).
 */
- (void)notifyDidLoad;

/**
 Notifies that the ad has been successfully presented to the user.
 */
- (void)notifyDidShow;

/**
 Notifies that the ad has been closed (either by user action or automatically).
 */
- (void)notifyDidClose;

/**
 Notifies that the ad was clicked by the user.
 */
- (void)notifyDidClick;

/**
 Notifies that an error occurred during ad loading or presentation.
 @param error The error object containing detailed information (error code, description, etc.).
 */
- (void)notifyError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
