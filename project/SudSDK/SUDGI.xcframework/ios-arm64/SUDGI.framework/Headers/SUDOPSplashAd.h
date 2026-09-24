//
//  SUDOPSplashAd.h
//  SUDGI
//

#import <Foundation/Foundation.h>
#import "SUDOPAd.h"
NS_ASSUME_NONNULL_BEGIN

@class SUDOPSplashAd;
/// Game->APP event
@protocol SUDOPSplashAdDelegate <NSObject>

/**
 Called when the ad has finished loading and is ready to be shown.
 @param ad The ad object that finished loading.
 */
- (void)splashAdLoad:(SUDOPSplashAd *)ad withStateHandle:(id<SUDOPStateHandle>)stateHandle;

/**
 Notifies that the ad has been shown.
 @param ad The ad object being displayed.
 */
- (void)splashAdShow:(SUDOPSplashAd *)ad withStateHandle:(id<SUDOPStateHandle>)stateHandle;

/**
 Notifies that the ad has been destroyed and should be cleaned up.
 @param ad The ad object being destroyed.
 */
- (void)splashAdDestroy:(SUDOPSplashAd *)ad;

@end

/// Splash ad (App Open ad)
@interface SUDOPSplashAd : SUDOPAd
/**
 The unique identifier for the ad unit.
 This ID is used to identify which ad placement to load and display.
 */
@property(nonatomic, strong) NSString *adUnitId;
@property(nonatomic, weak) id<SUDOPSplashAdDelegate> delegate;

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
