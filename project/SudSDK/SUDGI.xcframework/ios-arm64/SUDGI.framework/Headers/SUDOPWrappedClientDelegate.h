//
//  SUDOPWrappedClientDelegate.h
//  Pods
//
//  Created by kaniel on 3/11/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPCommon.h"
#import "SUDOPBannerAd.h"
#import "SUDOPCustomAd.h"
#import "SUDOPInterstitialAd.h"
#import "SUDOPRequestPaymentOptions.h"
#import "SUDOPSaveImageToPhotosAlbumOptions.h"
#import "SUDOPChooseImageOptions.h"
#import "SUDOPShowLoadingOptions.h"
#import "SUDOPHideLoadingOptions.h"
#import "SUDOPShowToastOptions.h"
#import "SUDOPHideToastOptions.h"
#import "SUDOPShowActionSheetOptions.h"
#import "SUDOPGameBannerAd.h"
#import "SUDOPGamePortalAd.h"
#import "SUDOPGameDrawerAd.h"
#import "SUDOPRewardVideoAd.h"
#import "SUDOPShowModalOptions.h"
#import "SUDOPPreviewImageOptions.h"
NS_ASSUME_NONNULL_BEGIN


/**
 * Protocol for Host App Implementation
 * Defines the callbacks used by the SDK to request user-related data
 * (identities, basic info, and detailed profiles) from the host application.
 */
@protocol SUDOPWrappedClientDelegate <NSObject>
@optional
/**
 * Triggered when the SDK requests legacy user identity information.
 * Typically used for backward compatibility or migrating existing user data.
 *
 * @param stateHandle The state handle used to return the processing result to the SDK.
 * @param dataJson A JSON string containing request parameters or contextual information.
 */
- (void)onGetLegacyUserIdentity:(id<SUDOPStateHandle>)stateHandle dataJson:(NSString*)dataJson;

/**
 * Triggered when the SDK requests basic user information.
 * The app should return basic fields such as nicknames and avatars via the handle.
 *
 * @param stateHandle The state handle used to return the processing result to the SDK.
 * @param dataJson A JSON string containing request parameters (e.g., a list of User IDs).
 */
- (void)onGetUserInfo:(id<SUDOPStateHandle>)stateHandle dataJson:(NSString*)dataJson;

/**
 * Triggered when the SDK requests comprehensive user profiles.
 * This typically involves detailed attributes such as gender, region, or verification status.
 *
 * @param stateHandle The state handle used to return the processing result to the SDK.
 * @param dataJson A JSON string specifying the requested profile attributes.
 */
- (void)onGetUserProfile:(id<SUDOPStateHandle>)stateHandle dataJson:(NSString*)dataJson;

/**
 Creates and initializes a banner ad.
 @param bannerAd The banner ad object to be created.
 */
- (void)createBannerAd:(SUDOPBannerAd *)bannerAd;

/**
 Creates and initializes a custom ad.
 @param customAd The custom ad object to be created.
 */
- (void)createCustomAd:(SUDOPCustomAd *)customAd;

/**
 Creates and initializes an interstitial ad.
 @param interstitialAd The interstitial ad object to be created.
 */
- (void)createInterstitialAd:(SUDOPInterstitialAd *)interstitialAd;

/**
 Creates and initializes a game banner ad.
 @param gameBannerAd The game banner ad object to be created.
 */
- (void)createGameBannerAd:(SUDOPGameBannerAd *)gameBannerAd;

/**
 Creates and initializes a game portal ad.
 @param gamePortalAd The game portal ad object to be created.
 */
- (void)createGamePortalAd:(SUDOPGamePortalAd *)gamePortalAd;

/**
 Creates and initializes a game drawer ad.
 @param gameDrawerAd The game drawer ad object to be created.
 */
- (void)createGameDrawerAd:(SUDOPGameDrawerAd *)gameDrawerAd;

/**
 Creates and initializes a rewarded video ad.
 @param rewardVideoAd The rewarded video ad object to be created.
 */
- (void)createRewardedVideoAd:(SUDOPRewardVideoAd *)rewardVideoAd;

/**
 Requests a payment with the specified state handle and options.
 @param stateHandle The state handle object that manages the payment state.
 @param options The options configuration for the payment request.
 */
- (void)requestPayment:(id<SUDOPStateHandle>)stateHandle options:(SUDOPRequestPaymentOptions *)options;

/**
 Saves an image to the device's photo album.
 @param stateHandle The state handle object that manages the operation state and callbacks.
 @param options The options configuration for saving the image to the photo album.
 */
- (void)saveImageToPhotosAlbum:(id<SUDOPStateHandle>)stateHandle options:(SUDOPSaveImageToPhotosAlbumOptions *)options;

/**
 Opens the image picker for selecting images from album or camera.
 @param stateHandle The state handle object that manages the operation state and callbacks.
 @param options The options configuration for image selection (count, sizeType, sourceType, etc.).
 */
- (void)chooseImage:(id<SUDOPStateHandle>)stateHandle options:(SUDOPChooseImageOptions *)options;

/**
 Previews an image in full-screen mode with support for gesture interactions.
 @param stateHandle The state handle object that manages the operation state and callbacks.
 @param options The options configuration for image preview (e.g., image URLs, current index, show save button).
 */
- (void)previewImage:(id<SUDOPStateHandle>)stateHandle options:(SUDOPPreviewImageOptions *)options;

/**
 Displays a loading indicator (progress HUD) to the user.
 @param stateHandle The state handle object that manages the operation state and callbacks.
 @param options The options configuration for the loading indicator (e.g., text, style, mask type).
 */
- (void)showLoading:(id<SUDOPStateHandle>)stateHandle options:(SUDOPShowLoadingOptions *)options;

/**
 Hides the currently displayed loading indicator.
 @param stateHandle The state handle object that manages the operation state and callbacks.
 @param options The options configuration for hiding the loading indicator (e.g., animated or not).
 */
- (void)hideLoading:(id<SUDOPStateHandle>)stateHandle options:(SUDOPHideLoadingOptions *)options;

/**
 Displays a toast message (brief non-intrusive notification) to the user.
 @param stateHandle The state handle object that manages the operation state and callbacks.
 @param options The options configuration for the toast (e.g., message text, duration, position).
 */
- (void)showToast:(id<SUDOPStateHandle>)stateHandle options:(SUDOPShowToastOptions *)options;

/**
 Hides the currently displayed toast message.
 @param stateHandle The state handle object that manages the operation state and callbacks.
 @param options The options configuration for hiding the toast.
 */
- (void)hideToast:(id<SUDOPStateHandle>)stateHandle options:(SUDOPHideToastOptions *)options;

/**
 Displays an action sheet (bottom sheet) with a list of selectable options.
 @param stateHandle The state handle object that manages the operation state and callbacks.
 @param options The options configuration for the action sheet (alert text, item list, item color, etc.).
 */
- (void)showActionSheet:(id<SUDOPStateHandle>)stateHandle options:(SUDOPShowActionSheetOptions *)options;

/**
 Displays a modal dialog box (alert/prompt) to the user.
 @param stateHandle The state handle object that manages the operation state and callbacks.
 @param options The options configuration for the modal dialog (e.g., title, content, confirm button, cancel button, show input field).
 */
- (void)showModal:(id<SUDOPStateHandle>)stateHandle options:(SUDOPShowModalOptions *)options;

/**
 Retrieves the base information of the current application.
 @return A dictionary containing app base information such as app version, host, etc.
 */
- (NSDictionary *)getAppBaseInfo;

/**
 Retrieves the bounding client rectangle of the menu button.
 @return A dictionary containing the position and size information of the menu button.
         The dictionary typically includes keys such as x, y, width, height, top, right, bottom, left.
 */
- (NSDictionary *)getMenuButtonBoundingClientRect;
@end

NS_ASSUME_NONNULL_END
