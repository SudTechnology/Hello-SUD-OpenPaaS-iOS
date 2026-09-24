//
//  SUDOPWCKVideoPlayerView.m
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 6/29/26.
//

#import "SUDOPWCKVideoPlayerView.h"
#import "SUDOPWCKCommon.h"

#import <Masonry/Masonry.h>
#import <QuartzCore/QuartzCore.h>
#import <float.h>

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#define SUDOP_HAS_SDWEBIMAGE 1
#else
#define SUDOP_HAS_SDWEBIMAGE 0
#endif

@interface SUDOPWCKVideoPlayerView () <UIGestureRecognizerDelegate>

@property (nonatomic, weak, readwrite) SUDOPVideo *video;

@property (nonatomic, weak) UIView *renderView;

@property (nonatomic, weak) UIView *originSuperview;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) UIView *fullScreenContainerView;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) BOOL seeking;

@property (nonatomic, assign) NSInteger fullScreenDirection;
@property (nonatomic, assign) BOOL changingFullScreenLayout;
@property (nonatomic, assign) BOOL suppressOuterLayoutUpdate;

@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *controlContainerView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *bottomPlayButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *centerPlayButton;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) CAGradientLayer *controlGradientLayer;

/// enablePlayGesture：双击播放器切换播放/暂停。
@property (nonatomic, strong) UITapGestureRecognizer *playGestureRecognizer;

/// enableProgressGesture：左右滑动播放器拖动播放进度。
@property (nonatomic, strong) UIPanGestureRecognizer *progressGestureRecognizer;

/// 左右滑动开始时的播放时间。
@property (nonatomic, assign) NSTimeInterval panSeekStartTime;

/// 左右滑动过程中的目标播放时间。
@property (nonatomic, assign) NSTimeInterval panSeekTargetTime;

@end

@implementation SUDOPWCKVideoPlayerView

#pragma mark - Init

- (instancetype)initWithVideo:(SUDOPVideo *)video {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _video = video;
        _duration = video.duration;
        _currentTime = video.currentTime;
        _seeking = NO;
        _fullScreenDirection = 0;
        _changingFullScreenLayout = NO;
        _suppressOuterLayoutUpdate = NO;
        _panSeekStartTime = 0;
        _panSeekTargetTime = 0;

        self.backgroundColor = UIColor.blackColor;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;

        [self setupRenderView];
        [self setupUI];
        [self setupConstraints];
        [self bindActions];
        [self bindVideoCallbacks];
        [self reloadCoverImage];
        [self applyVideoState];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    self.controlGradientLayer.frame = self.controlContainerView.bounds;
    [self applyObjectFit];

    [CATransaction commit];
}

#pragma mark - Setup

- (void)setupRenderView {
    UIView *renderView = self.video.renderView;
    if (!renderView) {
        NSAssert(NO, @"video.renderView should not be nil before SUDOPWCKVideoPlayerView init");
        return;
    }

    self.renderView = renderView;

    [renderView removeFromSuperview];

    renderView.hidden = NO;
    renderView.userInteractionEnabled = NO;
    renderView.backgroundColor = UIColor.blackColor;
    renderView.layer.masksToBounds = YES;

    renderView.translatesAutoresizingMaskIntoConstraints = YES;
    renderView.autoresizingMask = UIViewAutoresizingNone;
    renderView.transform = CGAffineTransformIdentity;
    renderView.frame = self.bounds;

    [self addSubview:renderView];
}

- (void)setupUI {
    [self addSubview:self.coverImageView];
    [self addSubview:self.controlContainerView];

    [self.controlContainerView addSubview:self.bottomPlayButton];
    [self.controlContainerView addSubview:self.currentTimeLabel];
    [self.controlContainerView addSubview:self.progressSlider];
    [self.controlContainerView addSubview:self.durationLabel];
    [self.controlContainerView addSubview:self.fullScreenButton];

    [self addSubview:self.closeButton];
    [self addSubview:self.centerPlayButton];
}

- (void)setupConstraints {
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self remakeChromeConstraintsWithSafeInsets:UIEdgeInsetsZero];
}

- (void)bindActions {
    [self.closeButton addTarget:self
                         action:@selector(onCloseButtonClick)
               forControlEvents:UIControlEventTouchUpInside];

    [self.bottomPlayButton addTarget:self
                              action:@selector(onPlayButtonClick)
                    forControlEvents:UIControlEventTouchUpInside];

    [self.centerPlayButton addTarget:self
                              action:@selector(onPlayButtonClick)
                    forControlEvents:UIControlEventTouchUpInside];

    [self.fullScreenButton addTarget:self
                              action:@selector(onFullScreenButtonClick)
                    forControlEvents:UIControlEventTouchUpInside];

    [self.progressSlider addTarget:self
                            action:@selector(onSliderTouchDown:)
                  forControlEvents:UIControlEventTouchDown];

    [self.progressSlider addTarget:self
                            action:@selector(onSliderValueChanged:)
                  forControlEvents:UIControlEventValueChanged];

    [self.progressSlider addTarget:self
                            action:@selector(onSliderTouchEnd:)
                  forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];

    UITapGestureRecognizer *playGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(onPlayGestureDoubleTap:)];
    playGestureRecognizer.numberOfTapsRequired = 2;
    playGestureRecognizer.numberOfTouchesRequired = 1;
    playGestureRecognizer.cancelsTouchesInView = NO;
    playGestureRecognizer.delegate = self;
    playGestureRecognizer.enabled = self.video.enablePlayGesture;

    [self addGestureRecognizer:playGestureRecognizer];
    self.playGestureRecognizer = playGestureRecognizer;

    UIPanGestureRecognizer *progressGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(onProgressPanGesture:)];
    progressGestureRecognizer.minimumNumberOfTouches = 1;
    progressGestureRecognizer.maximumNumberOfTouches = 1;
    progressGestureRecognizer.cancelsTouchesInView = NO;
    progressGestureRecognizer.delegate = self;
    progressGestureRecognizer.enabled = self.video.enableProgressGesture;

    [self addGestureRecognizer:progressGestureRecognizer];
    self.progressGestureRecognizer = progressGestureRecognizer;
}

#pragma mark - Video Callbacks

- (void)bindVideoCallbacks {
    __weak typeof(self) weakSelf = self;

    self.video.layoutChangedHandler = ^(SUDOPVideo * _Nonnull video) {
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) {
            return;
        }

        [self updateOuterLayoutIfNeeded];
    };

    self.video.layerChangedHandler = ^(SUDOPVideo * _Nonnull video) {
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) {
            return;
        }

        [self updateLayerIfNeeded];
    };

    self.video.styleChangedHandler = ^(SUDOPVideo * _Nonnull video) {
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) {
            return;
        }

        [self applyVideoState];
    };

    self.video.progressChangedHandler = ^(SUDOPVideo * _Nonnull video,
                                          NSTimeInterval currentTime,
                                          NSTimeInterval duration) {
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) {
            return;
        }

        [self updateCurrentTime:currentTime duration:duration];
    };

    self.video.visibilityChangedHandler = ^(SUDOPVideo * _Nonnull video, BOOL visible) {
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) {
            return;
        }

        self.hidden = !visible;
        self.renderView.hidden = !visible;
    };

    self.video.requestFullScreenHandler = ^(SUDOPVideo * _Nonnull video, NSInteger direction) {
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) {
            return;
        }

        [self requestFullScreenWithDirection:direction];
    };

    self.video.exitFullScreenHandler = ^(SUDOPVideo * _Nonnull video) {
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) {
            return;
        }

        [self exitFullScreen];
    };

    self.video.destroyHandler = ^(SUDOPVideo * _Nonnull video) {
        __strong typeof(weakSelf) self = weakSelf;
        if (!self) {
            return;
        }

        [self invalidate];
    };
}

#pragma mark - Apply State

- (void)applyVideoState {
    SUDOPVideo *video = self.video;
    if (!video) {
        return;
    }

    UIColor *backgroundColor = [self colorFromHexString:video.backgroundColor] ?: UIColor.blackColor;

    self.backgroundColor = backgroundColor;
    self.renderView.backgroundColor = backgroundColor;

    BOOL disabled = [video isDisabled];
    self.hidden = disabled;
    self.renderView.hidden = disabled;

    [self applyObjectFit];
    [self applyControlVisibility];
    [self applyButtonImages];
    [self applyProgressState];
    [self applyCoverState];
    [self updateLayerIfNeeded];

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)applyObjectFit {
    NSString *objectFit = self.video.objectFit ?: @"contain";

    [self applyCoverObjectFit:objectFit];
    [self applyRenderViewObjectFit:objectFit];
}

- (void)applyCoverObjectFit:(NSString *)objectFit {
    if ([self string:objectFit equalsIgnoreCase:@"fill"]) {
        self.coverImageView.contentMode = UIViewContentModeScaleToFill;
    } else if ([self string:objectFit equalsIgnoreCase:@"cover"]) {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

- (CGRect)contentsRectForVideoWidth:(double)videoWidth
                        videoHeight:(double)videoHeight
                           viewWidth:(double)viewWidth
                          viewHeight:(double)viewHeight {
    if (videoWidth <= 0 || videoHeight <= 0 || viewWidth <= 0 || viewHeight <= 0) {
        return CGRectMake(0, 0, 1, 1);
    }

    double videoAspectRatio = videoWidth / videoHeight;
    double viewAspectRatio = viewWidth / viewHeight;

    double scale = videoAspectRatio / viewAspectRatio;
    double scaleX = 1.0;
    double scaleY = 1.0;

    if (fabs(videoAspectRatio - viewAspectRatio) > DBL_EPSILON) {
        if (scale > 1.0) {
            scaleX = 1.0;
            scaleY = 1.0 / scale;
        } else {
            scaleX = scale;
            scaleY = 1.0;
        }
    }

    return CGRectMake((1.0 - scaleX) / 2.0,
                      (1.0 - scaleY) / 2.0,
                      scaleX,
                      scaleY);
}

- (void)applyRenderViewObjectFit:(NSString *)objectFit {
    UIView *renderView = self.renderView;
    SUDOPVideo *video = self.video;

    if (!renderView || !video) {
        return;
    }

    CGSize containerSize = self.bounds.size;
    if (containerSize.width <= 0 || containerSize.height <= 0) {
        return;
    }

    CGFloat videoViewWidth = containerSize.width;
    CGFloat videoViewHeight = containerSize.height;

    double videoWidth = (double)video.videoWidth;
    double videoHeight = (double)video.videoHeight;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    renderView.transform = CGAffineTransformIdentity;
    renderView.frame = CGRectMake(0, 0, videoViewWidth, videoViewHeight);
    renderView.layer.masksToBounds = YES;
    renderView.layer.contentsScale = UIScreen.mainScreen.scale;

    if ([self string:objectFit equalsIgnoreCase:@"fill"]) {
        renderView.layer.contentsGravity = kCAGravityResize;

        CGRect contentsRect = [self contentsRectForVideoWidth:videoWidth
                                                  videoHeight:videoHeight
                                                     viewWidth:videoViewWidth
                                                    viewHeight:videoViewHeight];

        renderView.layer.contentsRect = contentsRect;

    } else if ([self string:objectFit equalsIgnoreCase:@"contain"]) {
        renderView.layer.contentsGravity = kCAGravityResizeAspect;
        renderView.layer.contentsRect = CGRectMake(0, 0, 1, 1);

    } else if ([self string:objectFit equalsIgnoreCase:@"cover"]) {
        renderView.layer.contentsGravity = kCAGravityResizeAspectFill;
        renderView.layer.masksToBounds = YES;

        CGRect contentsRect = [self contentsRectForVideoWidth:videoWidth
                                                  videoHeight:videoHeight
                                                     viewWidth:videoViewWidth
                                                    viewHeight:videoViewHeight];

        renderView.layer.contentsRect = contentsRect;

    } else {
        NSLog(@"objectFit is a invalid value!");

        renderView.layer.contentsGravity = kCAGravityResizeAspect;
        renderView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
    }

    [renderView setNeedsLayout];
    [renderView layoutIfNeeded];

    [CATransaction commit];
}

- (void)applyControlVisibility {
    SUDOPVideo *video = self.video;
    if (!video) {
        return;
    }

    BOOL showControls = video.controls;
    BOOL showProgress = showControls && video.showProgress;

    /*
     controls 控制：
     - 底部控制栏容器
     - 底部播放按钮
     - 全屏/缩小按钮
     - 右上角关闭按钮
     */
    self.controlContainerView.hidden = !showControls;
    self.bottomPlayButton.hidden = !showControls;
    self.fullScreenButton.hidden = !showControls;
    self.closeButton.hidden = !showControls;

    /*
     showProgress 控制：
     - 进度条
     - 当前时间
     - 总时长

     注意：
     showProgress 必须配合 controls。
     controls = NO 时，即使 showProgress = YES，也不显示进度相关 UI。
     */
    self.progressSlider.hidden = !showProgress;
    self.currentTimeLabel.hidden = !showProgress;
    self.durationLabel.hidden = !showProgress;

    /*
     UISlider 是否可拖动：
     - controls 开启
     - showProgress 开启
     */
    self.progressSlider.userInteractionEnabled = showProgress;

    /*
     centerPlayButton：
     - showCenterPlayBtn 控制是否启用中间播放按钮；
     - 播放中隐藏；
     - 暂停/未播放时显示；
     - 不受 controls / showProgress / enablePlayGesture 影响。
     */
    BOOL showCenterPlayButton = video.showCenterPlayBtn && !video.playing;
    self.centerPlayButton.hidden = !showCenterPlayButton;

    /*
     enablePlayGesture：
     双击播放器切换播放/暂停。
     */
    self.playGestureRecognizer.enabled = video.enablePlayGesture;

    /*
     enableProgressGesture：
     左右滑动播放器拖动播放进度。
     注意：
     这个不受 showProgress 控制。
     即使进度条隐藏，只要 enableProgressGesture = YES，仍然允许左右滑动 seek。
     */
    self.progressGestureRecognizer.enabled = video.enableProgressGesture;
}

- (void)applyButtonImages {
    BOOL playing = self.video.playing;

    self.bottomPlayButton.selected = playing;
    self.centerPlayButton.selected = playing;
    self.fullScreenButton.selected = self.video.isFullScreen;

    if (self.playImage || self.pauseImage) {
        [self.bottomPlayButton setTitle:nil forState:UIControlStateNormal];
        [self.bottomPlayButton setTitle:nil forState:UIControlStateSelected];
        [self.bottomPlayButton setImage:self.playImage forState:UIControlStateNormal];
        [self.bottomPlayButton setImage:self.pauseImage forState:UIControlStateSelected];
    } else {
        [self.bottomPlayButton setImage:nil forState:UIControlStateNormal];
        [self.bottomPlayButton setImage:nil forState:UIControlStateSelected];
        [self.bottomPlayButton setTitle:@"▶︎" forState:UIControlStateNormal];
        [self.bottomPlayButton setTitle:@"Ⅱ" forState:UIControlStateSelected];
    }

    if (self.centerPlayImage || self.centerPauseImage) {
        [self.centerPlayButton setTitle:nil forState:UIControlStateNormal];
        [self.centerPlayButton setTitle:nil forState:UIControlStateSelected];
        [self.centerPlayButton setImage:self.centerPlayImage forState:UIControlStateNormal];
        [self.centerPlayButton setImage:self.centerPauseImage forState:UIControlStateSelected];
    } else {
        [self.centerPlayButton setImage:nil forState:UIControlStateNormal];
        [self.centerPlayButton setImage:nil forState:UIControlStateSelected];
        [self.centerPlayButton setTitle:@"▶︎" forState:UIControlStateNormal];
        [self.centerPlayButton setTitle:@"Ⅱ" forState:UIControlStateSelected];
    }

    if (self.fullScreenImage || self.exitFullScreenImage) {
        [self.fullScreenButton setTitle:nil forState:UIControlStateNormal];
        [self.fullScreenButton setTitle:nil forState:UIControlStateSelected];
        [self.fullScreenButton setImage:self.fullScreenImage forState:UIControlStateNormal];
        [self.fullScreenButton setImage:self.exitFullScreenImage forState:UIControlStateSelected];
    } else {
        [self.fullScreenButton setImage:nil forState:UIControlStateNormal];
        [self.fullScreenButton setImage:nil forState:UIControlStateSelected];
        [self.fullScreenButton setTitle:@"⛶" forState:UIControlStateNormal];
        [self.fullScreenButton setTitle:@"⇲" forState:UIControlStateSelected];
    }

    if (self.closeImage) {
        [self.closeButton setTitle:nil forState:UIControlStateNormal];
        [self.closeButton setImage:self.closeImage forState:UIControlStateNormal];
    } else {
        [self.closeButton setImage:nil forState:UIControlStateNormal];
        [self.closeButton setTitle:@"×" forState:UIControlStateNormal];
    }
}

- (void)applyProgressState {
    if (self.seeking) {
        return;
    }

    NSTimeInterval duration = self.duration;
    NSTimeInterval currentTime = self.currentTime;

    if (duration <= 0) {
        self.progressSlider.minimumValue = 0;
        self.progressSlider.maximumValue = 1;
        self.progressSlider.value = 0;
        self.currentTimeLabel.text = [self formatTime:currentTime];
        self.durationLabel.text = @"00:00";
        return;
    }

    currentTime = MAX(0, MIN(currentTime, duration));

    self.progressSlider.minimumValue = 0;
    self.progressSlider.maximumValue = duration;
    self.progressSlider.value = currentTime;

    self.currentTimeLabel.text = [self formatTime:currentTime];
    self.durationLabel.text = [self formatTime:duration];
}

- (void)applyCoverState {
    BOOL hasPoster = self.video.poster.length > 0 || self.coverPlaceholderImage != nil;

    if (!hasPoster) {
        self.coverImageView.hidden = YES;
        return;
    }

    self.coverImageView.hidden = self.video.playing;
}

#pragma mark - Public

- (void)updateCurrentTime:(NSTimeInterval)currentTime
                 duration:(NSTimeInterval)duration {
    self.currentTime = MAX(0, currentTime);
    self.duration = MAX(0, duration);

    [self applyProgressState];
}

- (void)invalidate {
    [self.layer removeAllAnimations];
    [self.fullScreenContainerView.layer removeAllAnimations];

    self.layerUpdateHandler = nil;

    if (self.playGestureRecognizer) {
        [self removeGestureRecognizer:self.playGestureRecognizer];
        self.playGestureRecognizer.delegate = nil;
        self.playGestureRecognizer = nil;
    }

    if (self.progressGestureRecognizer) {
        [self removeGestureRecognizer:self.progressGestureRecognizer];
        self.progressGestureRecognizer.delegate = nil;
        self.progressGestureRecognizer = nil;
    }

    [self.renderView removeFromSuperview];

    self.video.layoutChangedHandler = nil;
    self.video.layerChangedHandler = nil;
    self.video.styleChangedHandler = nil;
    self.video.progressChangedHandler = nil;
    self.video.visibilityChangedHandler = nil;
    self.video.requestFullScreenHandler = nil;
    self.video.exitFullScreenHandler = nil;
    self.video.destroyHandler = nil;

    [self removeFromSuperview];
    [self.fullScreenContainerView removeFromSuperview];
    self.fullScreenContainerView = nil;
}

#pragma mark - Layout Update

- (void)updateOuterLayoutIfNeeded {
    if (!self.superview) {
        return;
    }

    if (self.video.isFullScreen || self.fullScreenContainerView) {
        return;
    }

    if (self.suppressOuterLayoutUpdate) {
        return;
    }

    CGRect frame = self.video.frameInPoint;

    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.superview).offset(frame.origin.x);
        make.top.equalTo(self.superview).offset(frame.origin.y);
        make.width.mas_equalTo(frame.size.width);
        make.height.mas_equalTo(frame.size.height);
    }];
}

- (void)updateLayerIfNeeded {
    if (!self.superview) {
        return;
    }

    /*
     SUDOPWCKVideoPlayerView 自己不知道 gameView 是谁，
     所以不在这里直接做 bringSubviewToFront / sendSubviewToBack。
     
     这里只向外通知：
     “我需要重新调整层级了”。
     
     由 SUDOPWCKDefaultWrappedClient 根据 gameView 和 video.underGameView
     去决定插入到 gameView 上方还是下方。
     */
    if (self.layerUpdateHandler) {
        self.layerUpdateHandler(self, self.video);
        return;
    }

    /*
     兜底逻辑：
     如果外部没有设置 layerUpdateHandler，则保持旧行为。
     */
    if (!self.video.underGameView) {
        [self.superview bringSubviewToFront:self];
    }
}

#pragma mark - Cover

- (void)reloadCoverImage {
    NSString *poster = self.video.poster;

    if (self.coverPlaceholderImage) {
        self.coverImageView.image = self.coverPlaceholderImage;
    }

    if (poster.length <= 0) {
        return;
    }

#if SUDOP_HAS_SDWEBIMAGE
    NSURL *url = [NSURL URLWithString:poster];
    [self.coverImageView sd_setImageWithURL:url placeholderImage:self.coverPlaceholderImage];
#endif
}

#pragma mark - Button Actions

- (void)onCloseButtonClick {
    [self.video destroy];
}

- (void)togglePlayPause {
    if (self.video.playing) {
        [self.video pause];
    } else {
        [self.video play];
    }

    [self applyVideoState];
}

- (void)onPlayButtonClick {
    [self togglePlayPause];
}

- (void)onPlayGestureDoubleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateRecognized) {
        return;
    }

    if (!self.video.enablePlayGesture) {
        return;
    }

    [self togglePlayPause];
}

- (void)onFullScreenButtonClick {
    if (self.video.isFullScreen || self.fullScreenContainerView) {
        [self.video exitFullScreen];
    } else {
        [self.video requestFullScreenWithDirection:0];
    }
}

#pragma mark - Slider Actions

- (void)onSliderTouchDown:(UISlider *)slider {
    self.seeking = YES;
}

- (void)onSliderValueChanged:(UISlider *)slider {
    NSTimeInterval duration = self.duration;

    if (duration <= 0) {
        return;
    }

    NSTimeInterval time = MAX(0, MIN(slider.value, duration));
    self.currentTimeLabel.text = [self formatTime:time];
}

- (void)onSliderTouchEnd:(UISlider *)slider {
    NSTimeInterval duration = self.duration;

    if (duration <= 0) {
        self.seeking = NO;
        [self applyProgressState];
        return;
    }

    self.seeking = NO;

    NSTimeInterval time = MAX(0, MIN(slider.value, duration));
    self.currentTime = time;

    [self.video seek:time];

    [self applyProgressState];
}

#pragma mark - Progress Pan Gesture

- (void)onProgressPanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    if (!self.video.enableProgressGesture) {
        return;
    }

    if (self.duration <= 0) {
        return;
    }

    CGFloat width = self.bounds.size.width;
    if (width <= 0) {
        return;
    }

    CGPoint translation = [gestureRecognizer translationInView:self];

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.seeking = YES;
            self.panSeekStartTime = MAX(0, MIN(self.currentTime, self.duration));
            self.panSeekTargetTime = self.panSeekStartTime;
            break;
        }

        case UIGestureRecognizerStateChanged: {
            /*
             左右滑动拖动进度：
             向右滑动 -> 快进
             向左滑动 -> 后退

             这里采用：横向滑满整个播放器宽度，对应整个视频时长。
             如果后续觉得过于灵敏，可以把 duration 改成 duration * 0.5 或者固定秒数。
             */
            NSTimeInterval deltaTime = (translation.x / width) * self.duration;
            NSTimeInterval targetTime = self.panSeekStartTime + deltaTime;
            targetTime = MAX(0, MIN(targetTime, self.duration));

            self.panSeekTargetTime = targetTime;
            self.currentTime = targetTime;

            self.progressSlider.minimumValue = 0;
            self.progressSlider.maximumValue = self.duration;
            self.progressSlider.value = targetTime;
            self.currentTimeLabel.text = [self formatTime:targetTime];
            self.durationLabel.text = [self formatTime:self.duration];
            break;
        }

        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            NSTimeInterval targetTime = MAX(0, MIN(self.panSeekTargetTime, self.duration));

            self.seeking = NO;
            self.currentTime = targetTime;

            [self.video seek:targetTime];

            [self applyProgressState];

            self.panSeekStartTime = 0;
            self.panSeekTargetTime = 0;
            break;
        }

        default:
            break;
    }
}

#pragma mark - FullScreen

- (void)requestFullScreenWithDirection:(NSInteger)direction {
    if (self.video.isFullScreen || self.fullScreenContainerView) {
        return;
    }

    UIView *window = [self sud_keyWindow];
    if (!window) {
        return;
    }

    UIView *originSuperview = self.superview;
    if (!originSuperview) {
        return;
    }

    direction = [self normalizedFullScreenDirection:direction];

    self.fullScreenDirection = direction;
    self.originSuperview = originSuperview;

    [window layoutIfNeeded];
    [originSuperview layoutIfNeeded];
    [self layoutIfNeeded];

    CGRect originFrame = [originSuperview convertRect:self.bounds fromView:self];
    if (originFrame.size.width <= 0 || originFrame.size.height <= 0) {
        originFrame = self.frame;
    }
    self.originFrame = originFrame;

    [self.layer removeAllAnimations];

    UIView *containerView = [[UIView alloc] initWithFrame:window.bounds];
    containerView.backgroundColor = UIColor.blackColor;
    containerView.clipsToBounds = YES;
    self.fullScreenContainerView = containerView;

    [window addSubview:containerView];

    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];

    [window layoutIfNeeded];
    [containerView layoutIfNeeded];

    [self removeFromSuperview];

    self.transform = CGAffineTransformIdentity;
    [containerView addSubview:self];

    self.changingFullScreenLayout = YES;

    [self.video notifyFullScreenChanged:YES];

    /*
     进入全屏后，立即通知外部根据 underGameView 调整 fullScreenContainerView 层级。
     */
    [self updateLayerIfNeeded];

    [self applyFullScreenLayoutInContainer:containerView
                                    window:window
                                 direction:direction
                                  animated:YES];

    self.changingFullScreenLayout = NO;

    [self applyVideoState];
}

- (void)exitFullScreen {
    if (!self.video.isFullScreen && !self.fullScreenContainerView) {
        return;
    }

    UIView *originSuperview = self.originSuperview;
    UIView *containerView = self.fullScreenContainerView;
    CGRect originFrame = self.originFrame;

    self.changingFullScreenLayout = YES;
    self.suppressOuterLayoutUpdate = YES;

    [self.layer removeAllAnimations];
    [containerView.layer removeAllAnimations];

    self.transform = CGAffineTransformIdentity;
    self.fullScreenDirection = 0;

    if (!originSuperview) {
        [self removeFromSuperview];
        [containerView removeFromSuperview];
        self.fullScreenContainerView = nil;

        [self.video notifyFullScreenChanged:NO];

        [self remakeChromeConstraintsWithSafeInsets:UIEdgeInsetsZero];
        [self applyVideoState];

        self.suppressOuterLayoutUpdate = NO;
        self.changingFullScreenLayout = NO;
        return;
    }

    [originSuperview layoutIfNeeded];

    [self removeFromSuperview];
    [originSuperview addSubview:self];

    if (originFrame.size.width <= 0 || originFrame.size.height <= 0) {
        originFrame = self.video.frameInPoint;
    }

    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(originSuperview).offset(originFrame.origin.x);
        make.top.equalTo(originSuperview).offset(originFrame.origin.y);
        make.width.mas_equalTo(originFrame.size.width);
        make.height.mas_equalTo(originFrame.size.height);
    }];

    [self remakeChromeConstraintsWithSafeInsets:UIEdgeInsetsZero];

    [originSuperview layoutIfNeeded];
    [self layoutIfNeeded];

    [containerView removeFromSuperview];
    self.fullScreenContainerView = nil;

    [self.video notifyFullScreenChanged:NO];

    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(originSuperview).offset(originFrame.origin.x);
        make.top.equalTo(originSuperview).offset(originFrame.origin.y);
        make.width.mas_equalTo(originFrame.size.width);
        make.height.mas_equalTo(originFrame.size.height);
    }];

    [self remakeChromeConstraintsWithSafeInsets:UIEdgeInsetsZero];

    [originSuperview layoutIfNeeded];
    [self layoutIfNeeded];

    [self applyVideoState];
    [self updateLayerIfNeeded];

    self.originSuperview = nil;
    self.originFrame = CGRectZero;

    self.suppressOuterLayoutUpdate = NO;
    self.changingFullScreenLayout = NO;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];

    if (self.changingFullScreenLayout) {
        return;
    }

    if (!self.video.isFullScreen && !self.fullScreenContainerView) {
        return;
    }

    UIView *window = [self sud_keyWindow];
    UIView *containerView = self.fullScreenContainerView;

    if (!window || !containerView || self.superview != containerView) {
        return;
    }

    [self applyFullScreenLayoutInContainer:containerView
                                    window:window
                                 direction:self.fullScreenDirection
                                  animated:NO];
}

#pragma mark - FullScreen Layout Helper

- (NSInteger)normalizedFullScreenDirection:(NSInteger)direction {
    if (direction == 90) {
        return -90;
    }

    if (direction == -90) {
        return 90;
    }

    return 0;
}

- (CGAffineTransform)transformForFullScreenDirection:(NSInteger)direction {
    direction = [self normalizedFullScreenDirection:direction];

    if (direction == 90) {
        return CGAffineTransformMakeRotation((CGFloat)M_PI_2);
    }

    if (direction == -90) {
        return CGAffineTransformMakeRotation((CGFloat)-M_PI_2);
    }

    return CGAffineTransformIdentity;
}

- (CGSize)layoutSizeForContainerSize:(CGSize)containerSize
                           direction:(NSInteger)direction {
    direction = [self normalizedFullScreenDirection:direction];

    if (direction == 90 || direction == -90) {
        return CGSizeMake(containerSize.height, containerSize.width);
    }

    return containerSize;
}

- (UIEdgeInsets)safeInsetsForWindow:(UIView *)window
                          direction:(NSInteger)direction {
    UIEdgeInsets windowInsets = UIEdgeInsetsZero;

    if (@available(iOS 11.0, *)) {
        windowInsets = window.safeAreaInsets;
    }

    direction = [self normalizedFullScreenDirection:direction];

    if (direction == 90) {
        return UIEdgeInsetsMake(windowInsets.right,
                                windowInsets.top,
                                windowInsets.left,
                                windowInsets.bottom);
    }

    if (direction == -90) {
        return UIEdgeInsetsMake(windowInsets.left,
                                windowInsets.bottom,
                                windowInsets.right,
                                windowInsets.top);
    }

    return windowInsets;
}

- (void)remakeChromeConstraintsWithSafeInsets:(UIEdgeInsets)safeInsets {
    CGFloat topOffset = safeInsets.top + 6.0;
    CGFloat bottomOffset = safeInsets.bottom;
    CGFloat leftOffset = safeInsets.left;
    CGFloat rightOffset = safeInsets.right;

    CGFloat controlBarVisualHeight = 64.0;
    CGFloat controlHorizontalPadding = 12.0;

    CGFloat controlContainerHeight = controlBarVisualHeight + bottomOffset;
    CGFloat controlCenterYOffsetFromBottom = -(bottomOffset + 22.0);

    [self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(topOffset);
        make.right.equalTo(self).offset(-(rightOffset + 12.0));
        make.width.height.mas_equalTo(32.0);
    }];

    [self.controlContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(controlContainerHeight);
    }];

    [self.centerPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(72.0);
    }];

    [self.bottomPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.controlContainerView).offset(leftOffset + controlHorizontalPadding);
        make.centerY.equalTo(self.controlContainerView.mas_bottom).offset(controlCenterYOffsetFromBottom);
        make.width.height.mas_equalTo(28.0);
    }];

    [self.fullScreenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.controlContainerView).offset(-(rightOffset + controlHorizontalPadding));
        make.centerY.equalTo(self.controlContainerView.mas_bottom).offset(controlCenterYOffsetFromBottom);
        make.width.height.mas_equalTo(28.0);
    }];

    [self.currentTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomPlayButton.mas_right).offset(6.0);
        make.centerY.equalTo(self.bottomPlayButton);
        make.width.mas_equalTo(44.0);
    }];

    [self.durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullScreenButton.mas_left).offset(-6.0);
        make.centerY.equalTo(self.fullScreenButton);
        make.width.mas_equalTo(44.0);
    }];

    [self.progressSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(6.0);
        make.right.equalTo(self.durationLabel.mas_left).offset(-6.0);
        make.centerY.equalTo(self.bottomPlayButton);
        make.height.mas_equalTo(28.0);
    }];
}

- (void)applyFullScreenLayoutInContainer:(UIView *)containerView
                                  window:(UIView *)window
                               direction:(NSInteger)direction
                                animated:(BOOL)animated {
    if (!containerView || !window) {
        return;
    }

    direction = [self normalizedFullScreenDirection:direction];
    self.fullScreenDirection = direction;

    [window layoutIfNeeded];
    [containerView layoutIfNeeded];

    CGSize containerSize = containerView.bounds.size;
    if (containerSize.width <= 0 || containerSize.height <= 0) {
        containerSize = window.bounds.size;
    }

    CGSize layoutSize = [self layoutSizeForContainerSize:containerSize direction:direction];
    UIEdgeInsets safeInsets = [self safeInsetsForWindow:window direction:direction];
    CGAffineTransform targetTransform = [self transformForFullScreenDirection:direction];

    self.transform = CGAffineTransformIdentity;

    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(containerView);
        make.width.mas_equalTo(layoutSize.width);
        make.height.mas_equalTo(layoutSize.height);
    }];

    [self remakeChromeConstraintsWithSafeInsets:safeInsets];

    [containerView layoutIfNeeded];
    [self layoutIfNeeded];

    void (^changes)(void) = ^{
        self.transform = targetTransform;
        [containerView layoutIfNeeded];
        [self layoutIfNeeded];
    };

    if (animated) {
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:changes
                         completion:^(BOOL finished) {
                             [self applyObjectFit];
                         }];
    } else {
        changes();
        [self applyObjectFit];
    }
}

#pragma mark - Lazy Views

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = UIColor.clearColor;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.userInteractionEnabled = NO;
    }
    return _coverImageView;
}

- (UIView *)controlContainerView {
    if (!_controlContainerView) {
        _controlContainerView = [[UIView alloc] init];
        _controlContainerView.backgroundColor = UIColor.clearColor;
        _controlContainerView.clipsToBounds = YES;

        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0.5, 0.0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        gradientLayer.colors = @[
            (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0].CGColor,
            (__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor
        ];
        gradientLayer.locations = @[@0, @1.0];

        [_controlContainerView.layer insertSublayer:gradientLayer atIndex:0];
        self.controlGradientLayer = gradientLayer;
    }
    return _controlContainerView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
        _closeButton.layer.cornerRadius = 16.0;
        _closeButton.layer.masksToBounds = YES;
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightRegular];
        [_closeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_closeButton setTitle:@"×" forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIButton *)bottomPlayButton {
    if (!_bottomPlayButton) {
        _bottomPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomPlayButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        [_bottomPlayButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_bottomPlayButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_bottomPlayButton setTitle:@"▶︎" forState:UIControlStateNormal];
        [_bottomPlayButton setTitle:@"Ⅱ" forState:UIControlStateSelected];
    }
    return _bottomPlayButton;
}

- (UIButton *)fullScreenButton {
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        [_fullScreenButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_fullScreenButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_fullScreenButton setTitle:@"⛶" forState:UIControlStateNormal];
        [_fullScreenButton setTitle:@"⇲" forState:UIControlStateSelected];
    }
    return _fullScreenButton;
}

- (UIButton *)centerPlayButton {
    if (!_centerPlayButton) {
        _centerPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerPlayButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
        _centerPlayButton.layer.cornerRadius = 36.0;
        _centerPlayButton.layer.masksToBounds = YES;
        _centerPlayButton.titleLabel.font = [UIFont systemFontOfSize:32.0 weight:UIFontWeightMedium];
        [_centerPlayButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_centerPlayButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_centerPlayButton setTitle:@"▶︎" forState:UIControlStateNormal];
        [_centerPlayButton setTitle:@"Ⅱ" forState:UIControlStateSelected];
    }
    return _centerPlayButton;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = UIColor.whiteColor;
        _currentTimeLabel.font = [UIFont monospacedDigitSystemFontOfSize:11.0 weight:UIFontWeightRegular];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.textColor = UIColor.whiteColor;
        _durationLabel.font = [UIFont monospacedDigitSystemFontOfSize:11.0 weight:UIFontWeightRegular];
        _durationLabel.textAlignment = NSTextAlignmentCenter;
        _durationLabel.text = @"00:00";
    }
    return _durationLabel;
}

- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        _progressSlider.minimumValue = 0;
        _progressSlider.maximumValue = 1;
        _progressSlider.value = 0;
        _progressSlider.minimumTrackTintColor = UIColor.whiteColor;
        _progressSlider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.35];
        _progressSlider.thumbTintColor = UIColor.whiteColor;
    }
    return _progressSlider;
}

#pragma mark - Setters

- (void)setCoverPlaceholderImage:(UIImage *)coverPlaceholderImage {
    _coverPlaceholderImage = coverPlaceholderImage;
    [self reloadCoverImage];
    [self applyCoverState];
}

- (void)setCloseImage:(UIImage *)closeImage {
    _closeImage = closeImage;
    [self applyButtonImages];
}

- (void)setPlayImage:(UIImage *)playImage {
    _playImage = playImage;
    [self applyButtonImages];
}

- (void)setPauseImage:(UIImage *)pauseImage {
    _pauseImage = pauseImage;
    [self applyButtonImages];
}

- (void)setFullScreenImage:(UIImage *)fullScreenImage {
    _fullScreenImage = fullScreenImage;
    [self applyButtonImages];
}

- (void)setExitFullScreenImage:(UIImage *)exitFullScreenImage {
    _exitFullScreenImage = exitFullScreenImage;
    [self applyButtonImages];
}

- (void)setCenterPlayImage:(UIImage *)centerPlayImage {
    _centerPlayImage = centerPlayImage;
    [self applyButtonImages];
}

- (void)setCenterPauseImage:(UIImage *)centerPauseImage {
    _centerPauseImage = centerPauseImage;
    [self applyButtonImages];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.progressGestureRecognizer) {
        if (!self.video.enableProgressGesture) {
            return NO;
        }

        if (self.duration <= 0) {
            return NO;
        }

        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint velocity = [panGestureRecognizer velocityInView:self];

        /*
         只响应明显的左右滑动，避免和上下滑动、系统手势或其他交互冲突。
         */
        if (fabs(velocity.x) <= fabs(velocity.y)) {
            return NO;
        }

        return YES;
    }

    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    UIView *touchView = touch.view;

    if (gestureRecognizer == self.playGestureRecognizer) {
        if ([touchView isKindOfClass:UIControl.class]) {
            return NO;
        }

        if ([touchView isDescendantOfView:self.controlContainerView]) {
            return NO;
        }

        return YES;
    }

    if (gestureRecognizer == self.progressGestureRecognizer) {
        if (!self.video.enableProgressGesture) {
            return NO;
        }

        if ([touchView isKindOfClass:UIControl.class]) {
            return NO;
        }

        /*
         进度滑动手势不接管底部控制栏区域，避免影响按钮、Slider。
         */
        if ([touchView isDescendantOfView:self.controlContainerView]) {
            return NO;
        }

        return YES;
    }

    return YES;
}

#pragma mark - Helper

- (NSString *)formatTime:(NSTimeInterval)time {
    if (time < 0 || isnan(time) || isinf(time)) {
        time = 0;
    }

    NSInteger totalSeconds = (NSInteger)round(time);
    NSInteger hours = totalSeconds / 3600;
    NSInteger minutes = (totalSeconds % 3600) / 60;
    NSInteger seconds = totalSeconds % 60;

    if (hours > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",
                (long)hours,
                (long)minutes,
                (long)seconds];
    }

    return [NSString stringWithFormat:@"%02ld:%02ld",
            (long)minutes,
            (long)seconds];
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    if (![hexString isKindOfClass:NSString.class]) {
        return nil;
    }

    NSString *hex = [hexString stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];

    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }

    if (hex.length == 3) {
        NSString *r = [hex substringWithRange:NSMakeRange(0, 1)];
        NSString *g = [hex substringWithRange:NSMakeRange(1, 1)];
        NSString *b = [hex substringWithRange:NSMakeRange(2, 1)];
        hex = [NSString stringWithFormat:@"%@%@%@%@%@%@",
               r, r, g, g, b, b];
    }

    if (hex.length != 6) {
        return nil;
    }

    unsigned int rgb = 0;
    BOOL success = [[NSScanner scannerWithString:hex] scanHexInt:&rgb];
    if (!success) {
        return nil;
    }

    CGFloat r = ((rgb >> 16) & 0xFF) / 255.0;
    CGFloat g = ((rgb >> 8) & 0xFF) / 255.0;
    CGFloat b = (rgb & 0xFF) / 255.0;

    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

- (UIView *)sud_keyWindow {
    UIWindow *keyWindow = nil;

    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *connectedScenes = UIApplication.sharedApplication.connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if (![scene isKindOfClass:UIWindowScene.class]) {
                continue;
            }

            UIWindowScene *windowScene = (UIWindowScene *)scene;
            if (windowScene.activationState != UISceneActivationStateForegroundActive) {
                continue;
            }

            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    keyWindow = window;
                    break;
                }
            }

            if (keyWindow) {
                break;
            }
        }
    }

    if (!keyWindow) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        keyWindow = UIApplication.sharedApplication.keyWindow;
#pragma clang diagnostic pop
    }

    return keyWindow;
}

- (BOOL)string:(NSString *)string equalsIgnoreCase:(NSString *)target {
    if (![string isKindOfClass:NSString.class] || ![target isKindOfClass:NSString.class]) {
        return NO;
    }

    return [string compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame;
}

- (double)doubleValueForVideoKey:(NSString *)key {
    if (key.length <= 0 || !self.video) {
        return 0;
    }

    @try {
        id value = [self.video valueForKey:key];

        if ([value respondsToSelector:@selector(doubleValue)]) {
            return [value doubleValue];
        }
    } @catch (NSException *exception) {
        return 0;
    }

    return 0;
}

@end
