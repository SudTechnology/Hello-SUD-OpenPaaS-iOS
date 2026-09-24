//
//  SUDOPBannerAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPAd.h"
NS_ASSUME_NONNULL_BEGIN

@class SUDOPBannerAd;
/// Game->APP event
@protocol SUDOPBannerAdDelegate <NSObject>

/**
 Notifies that the ad has been shown.
 @param ad The ad object being displayed.
 */
- (void)bannerAdShow:(SUDOPBannerAd *)ad withStateHandle:(id<SUDOPStateHandle>)stateHandle;

/**
 Notifies that the ad has been hidden.
 @param ad The ad object that was hidden.
 */
- (void)bannerAdHide:(SUDOPBannerAd *)ad withStateHandle:(id<SUDOPStateHandle>)stateHandle;

/**
 Notifies that the ad has been destroyed and should be cleaned up.
 @param ad The ad object being destroyed.
 */
- (void)bannerAdDestroy:(SUDOPBannerAd *)ad;

@end

 
/// ad style
@interface SUDOPBannerAdStyle : NSObject
@property(nonatomic, assign)CGFloat left;
@property(nonatomic, assign)CGFloat top;
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, assign)CGFloat realWidth;
@property(nonatomic, assign)CGFloat realHeight;
@end

/// Banner ad
@interface SUDOPBannerAd : SUDOPAd
@property(nonatomic, strong)SUDOPBannerAdStyle *style;
@property(nonatomic,weak)id<SUDOPBannerAdDelegate> delegate;
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
 Notifies that the ad view has been resized.
 @param size The new size of the ad view after resizing.
 */
- (void)notifyResizeWithSize:(CGSize)size;

/**
 计算 banner 在容器中的布局 frame：JS 传逻辑像素（iOS 为 pt），端上布局时叠加顶部安全区域。
 */
- (CGRect)bridgeLayoutFrameWithContainerView:(UIView *)containerView;
@end

NS_ASSUME_NONNULL_END
