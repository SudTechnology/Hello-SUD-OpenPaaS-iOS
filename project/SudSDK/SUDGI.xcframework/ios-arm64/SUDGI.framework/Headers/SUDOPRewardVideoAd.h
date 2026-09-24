//
//  SUDOPRewardVideoAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPAd.h"
NS_ASSUME_NONNULL_BEGIN
@class SUDOPRewardVideoAd;
@class SUDOPRewardVideoAdSSVData;

/// Game->APP event
@protocol SUDOPRewardVideoAdDelegate <NSObject>

/**
 Called when the ad has finished loading and is ready to be shown.
 @param ad The ad object that finished loading.
 */
- (void)rewardVideoAdLoad:(SUDOPRewardVideoAd *)ad withStateHandle:(id<SUDOPStateHandle>)stateHandle;

/**
 Notifies that the ad has been shown.
 @param ad The ad object being displayed.
 */
- (void)rewardVideoAdShow:(SUDOPRewardVideoAd *)ad withStateHandle:(id<SUDOPStateHandle>)stateHandle;

/**
 Notifies that the ad has been hidden.
 @param ad The ad object that was hidden.
 */
- (void)rewardVideoAdHide:(SUDOPRewardVideoAd *)ad withStateHandle:(id<SUDOPStateHandle>)stateHandle;

/**
 Notifies that the ad has been destroyed and should be cleaned up.
 @param ad The ad object being destroyed.
 */
- (void)rewardVideoAdDestroy:(SUDOPRewardVideoAd *)ad;


@optional
/**
 Provides server-side verification data for rewarded video ads.
 @param ad The ad object associated with the SSV data.
 @param ssvData The server-side verification data containing reward validation information.
 */
- (void)rewardVideoAd:(SUDOPRewardVideoAd *)ad setServerSideVerificationData:(SUDOPRewardVideoAdSSVData *)ssvData;

@end

@interface SUDOPRewardVideoAdSSVData : NSObject
@property(nonatomic, strong)NSString *sudTransactionId;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *rewardItem;
@property(nonatomic, assign)NSInteger rewardAmount;
@property(nonatomic, strong)NSString *customData;
@end


/// RewardVideo ad
@interface SUDOPRewardVideoAd : SUDOPAd
/**
 The unique identifier for the ad unit.
 This ID is used to identify which ad placement to load and display.
 */
@property(nonatomic, strong) NSString *adUnitId;
@property(nonatomic, weak) id<SUDOPRewardVideoAdDelegate> delegate;
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

/// notify ad close
- (void)notifyDidCloseWithIsEnded:(BOOL)isEnded;

@end

NS_ASSUME_NONNULL_END
