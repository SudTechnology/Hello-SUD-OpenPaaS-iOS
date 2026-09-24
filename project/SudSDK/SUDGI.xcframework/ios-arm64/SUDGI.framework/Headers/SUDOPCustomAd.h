//
//  SUDOPCustomAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPAd.h"
NS_ASSUME_NONNULL_BEGIN

@class SUDOPCustomAd;
/// Game->APP event
@protocol SUDOPCustomAdDelegate <NSObject>

/**
 Notifies that the ad has been shown.
 @param ad The ad object being displayed.
 */
- (void)customAdShow:(SUDOPCustomAd *)ad withStateHandle:(id<SUDOPStateHandle>)stateHandle;

/**
 Notifies that the ad has been hidden.
 @param ad The ad object that was hidden.
 */
- (void)customAdHide:(SUDOPCustomAd *)ad withStateHandle:(id<SUDOPStateHandle>)stateHandle;

/**
 Notifies that the ad has been destroyed and should be cleaned up.
 @param ad The ad object being destroyed.
 */
- (void)customAdDestroy:(SUDOPCustomAd *)ad;

/**
 Asks whether the ad is currently being shown.
 @param ad The banner ad object to check.
 @return YES if the ad is currently visible, NO otherwise.
 */
- (BOOL)customAdIsShow:(SUDOPCustomAd *)ad;


@end

/// ad style
@interface SUDOPCustomAdStyle : NSObject
@property(nonatomic, assign)CGFloat left;
@property(nonatomic, assign)CGFloat top;
@property(nonatomic, assign)BOOL fixed;
@end

/// Cutoms ad
@interface SUDOPCustomAd : SUDOPAd
@property(nonatomic, strong)SUDOPCustomAdStyle *style;
@property(nonatomic, weak) id<SUDOPCustomAdDelegate> delegate;
/**
 The unique identifier for the ad unit.
 This ID is used to identify which ad placement to load and display.
 */
@property(nonatomic, strong) NSString *adUnitId;
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

/**
 Notifies that the ad has been hidden.
 */
- (void)notifyDidHide;

/**
 Notifies that the ad view has been resized.
 @param size The new size of the ad view after resizing.
 */
- (void)notifyResizeWithSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
