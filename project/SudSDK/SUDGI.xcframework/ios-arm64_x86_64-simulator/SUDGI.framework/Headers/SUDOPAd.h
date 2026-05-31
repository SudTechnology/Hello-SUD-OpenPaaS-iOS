//
//  SUDOPAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SUDOPAd;
@class SUDOPRewardVideoAdSSVData;

/// Game->APP event
@protocol SUDOPAdDelegate <NSObject>
/**
 Notifies that the ad has been shown.
 @param ad The ad object being displayed.
 */
- (void)sudopAdShow:(SUDOPAd *)ad;

/**
 Notifies that the ad has been hidden.
 @param ad The ad object that was hidden.
 */
- (void)sudopAdHide:(SUDOPAd *)ad;

/**
 Notifies that the ad has been destroyed and should be cleaned up.
 @param ad The ad object being destroyed.
 */
- (void)sudopAdDestroy:(SUDOPAd *)ad;

@optional

/**
 Called when the ad has finished loading and is ready to be shown.
 @param ad The ad object that finished loading.
 */
- (void)sudopAdLoad:(SUDOPAd *)ad;

/**
 Asks whether the ad is currently being shown.
 @param bannerAd The banner ad object to check.
 @return YES if the ad is currently visible, NO otherwise.
 */
- (BOOL)sudopAdIsShow:(SUDOPAd *)bannerAd;

/**
 Provides server-side verification data for rewarded video ads.
 @param ad The ad object associated with the SSV data.
 @param ssvData The server-side verification data containing reward validation information.
 */
- (void)sudopAd:(SUDOPAd *)ad setServerSideVerificationData:(SUDOPRewardVideoAdSSVData *)ssvData;
@end

/// Base ad class
@interface SUDOPAd : NSObject {
    @package
    NSString *_gameId;
    @package
    NSString *_sudAdUnitId;
    @package
    NSString *_adId;
    @package
    NSString *_adType;
}
/**
 The unique identifier for the ad unit.
 This ID is used to identify which ad placement to load and display.
 */
@property(nonatomic, strong) NSString *adUnitId;

/**
 The delegate object that will receive ad event callbacks.
 The delegate is held weakly to avoid retain cycles.
 */
@property(nonatomic, weak) id<SUDOPAdDelegate> delegate;

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
 @param code The click action identifier code (e.g., 1-download, 2-redirect, etc.).
 @param msg The description message of the click action.
 */
- (void)notifyDidClickWithCode:(NSInteger)code msg:(NSString *)msg;

/**
 Notifies that an error occurred during ad loading or presentation.
 @param error The error object containing detailed information (error code, description, etc.).
 */
- (void)notifyError:(NSError *)error;

/**
 Notifies that the ad view has been resized.
 @param size The new size of the ad view after resizing.
 */
- (void)notifyResizeWithSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
