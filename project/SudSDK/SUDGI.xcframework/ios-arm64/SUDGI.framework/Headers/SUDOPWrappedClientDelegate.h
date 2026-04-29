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
#import "SUDOPGameBannerAd.h"
#import "SUDOPGamePortalAd.h"
#import "SUDOPGameDrawerAd.h"
NS_ASSUME_NONNULL_BEGIN


/**
 * Protocol for Host App Implementation
 * Defines the callbacks used by the SDK to request user-related data
 * (identities, basic info, and detailed profiles) from the host application.
 */
@protocol SUDOPWrappedClientDelegate <NSObject>

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

- (void)createBannerAd:(SUDOPBannerAd *)bannerAd;

- (void)createCustomAd:(SUDOPCustomAd *)customAd;

- (void)createInterstitialAd:(SUDOPInterstitialAd *)interstitialAd;

- (void)createGameBannerAd:(SUDOPGameBannerAd *)gameBannerAd;

- (void)createGamePortalAd:(SUDOPGamePortalAd *)gamePortalAd;

- (void)createGameDrawerAd:(SUDOPGameDrawerAd *)gameDrawerAd;

- (void)requestPayment:(id<SUDOPStateHandle>)stateHandle options:(SUDOPRequestPaymentOptions *)options;
@end

NS_ASSUME_NONNULL_END
