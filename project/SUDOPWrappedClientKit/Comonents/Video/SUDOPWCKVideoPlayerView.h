//
//  SUDOPWCKVideoPlayerView.h
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 6/29/26.
//

#import <UIKit/UIKit.h>

@class SUDOPVideo;
@class SUDOPWCKVideoPlayerView;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SUDOPWCKVideoPlayerViewLayerUpdateHandler)(SUDOPWCKVideoPlayerView *playerView,
                                                          SUDOPVideo *video);

@interface SUDOPWCKVideoPlayerView : UIView

@property (nonatomic, weak, readonly) SUDOPVideo *video;

/// Called when the player needs its view hierarchy to be adjusted externally.
/// Examples:
/// - video.underGameView changes.
/// - The player returns to its original superview after exiting full screen.
/// - The hierarchy needs to be verified after applyVideoState.
@property (nonatomic, copy, nullable) SUDOPWCKVideoPlayerViewLayerUpdateHandler layerUpdateHandler;

/// The placeholder image displayed for the video cover.
@property (nonatomic, strong, nullable) UIImage *coverPlaceholderImage;

/// The close button image.
@property (nonatomic, strong, nullable) UIImage *closeImage;

/// The bottom play button image.
@property (nonatomic, strong, nullable) UIImage *playImage;

/// The bottom pause button image.
@property (nonatomic, strong, nullable) UIImage *pauseImage;

/// The enter-full-screen button image.
@property (nonatomic, strong, nullable) UIImage *fullScreenImage;

/// The exit-full-screen button image.
@property (nonatomic, strong, nullable) UIImage *exitFullScreenImage;

/// The center play button image.
@property (nonatomic, strong, nullable) UIImage *centerPlayImage;

/// The center pause button image.
@property (nonatomic, strong, nullable) UIImage *centerPauseImage;

- (instancetype)initWithVideo:(SUDOPVideo *)video NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

/// Updates the UI when playback progress is supplied externally.
- (void)updateCurrentTime:(NSTimeInterval)currentTime
                 duration:(NSTimeInterval)duration;

/// Destroys the player UI.
/// This method does not call [video destroy], which avoids recursion.
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
