//
//  SUDOPVideo.h
//  SUDGI
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class SUDOPVideoPlayerView;

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPVideo : NSObject

#pragma mark - Basic

@property (nonatomic, assign, readonly) NSInteger instanceID;

#pragma mark - Render Target

/// 三方 gameHandle 渲染用 layer。
@property (nonatomic, strong, readonly) CAEAGLLayer *renderLayer;

/// 外部 UI 容器要添加的视频渲染视图。
@property (nonatomic, strong, readonly) UIView *renderView;

#pragma mark - Create Params Exposed

@property (nonatomic, assign, readonly) CGFloat x;
@property (nonatomic, assign, readonly) CGFloat y;

/// video 组件布局宽高，单位 pt。
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;

/// 视频真实宽高，来自 JS onResize 的 videoWidth/videoHeight。
/// 用于 contain/cover/fill 计算视频固有比例。
@property (nonatomic, assign, readonly) CGFloat videoWidth;
@property (nonatomic, assign, readonly) CGFloat videoHeight;

@property (nonatomic, copy, nullable, readonly) NSString *src;
@property (nonatomic, copy, nullable, readonly) NSString *poster;

@property (nonatomic, assign, readonly) NSTimeInterval initialTime;
@property (nonatomic, assign, readonly) CGFloat playbackRate;

@property (nonatomic, assign, readonly) BOOL live;
@property (nonatomic, copy, readonly) NSString *objectFit;

@property (nonatomic, assign, readonly) BOOL controls;
@property (nonatomic, assign, readonly) BOOL showProgress;
@property (nonatomic, assign, readonly) BOOL showProgressInControlMode;

@property (nonatomic, copy, readonly) NSString *backgroundColor;

@property (nonatomic, assign, readonly) BOOL autoplay;
@property (nonatomic, assign, readonly) BOOL loop;
@property (nonatomic, assign, readonly) BOOL muted;
@property (nonatomic, assign, readonly) BOOL obeyMuteSwitch;

@property (nonatomic, assign, readonly) BOOL enableProgressGesture;
@property (nonatomic, assign, readonly) BOOL enablePlayGesture;
@property (nonatomic, assign, readonly) BOOL showCenterPlayBtn;

@property (nonatomic, assign, readonly) BOOL underGameView;

@property (nonatomic, assign, readonly) BOOL autoPauseIfNavigate;
@property (nonatomic, assign, readonly) BOOL autoPauseIfOpenNative;

#pragma mark - Runtime State Exposed

@property (nonatomic, assign, readonly) BOOL playing;
@property (nonatomic, assign, readonly, getter=isDisabled) BOOL disabled;
@property (nonatomic, assign, readonly, getter=isFullScreen) BOOL fullScreen;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
@property (nonatomic, assign, readonly) NSTimeInterval duration;

/// 当前视频期望布局 frame，单位 pt。
/// 外层 SUDOPWCKVideoPlayerView 根据这个 frame 布局。
@property (nonatomic, assign, readonly) CGRect frameInPoint;

#pragma mark - UI Callback

/// frame 变化，外层刷新 Masonry 约束。
@property (nonatomic, copy, nullable) void (^layoutChangedHandler)(SUDOPVideo *video);

/// underGameView 变化，外层可自行调整层级。
@property (nonatomic, copy, nullable) void (^layerChangedHandler)(SUDOPVideo *video);

/// backgroundColor/objectFit/videoWidth/videoHeight 等样式变化。
@property (nonatomic, copy, nullable) void (^styleChangedHandler)(SUDOPVideo *video);

/// 播放进度变化，外层刷新进度条、当前时间、总时长。
@property (nonatomic, copy, nullable) void (^progressChangedHandler)(SUDOPVideo *video,
                                                                 NSTimeInterval currentTime,
                                                                 NSTimeInterval duration);

/// enable/disable。
@property (nonatomic, copy, nullable) void (^visibilityChangedHandler)(SUDOPVideo *video, BOOL visible);

/// 请求进入全屏，由外层播放器视图处理。
@property (nonatomic, copy, nullable) void (^requestFullScreenHandler)(SUDOPVideo *video, NSInteger direction);

/// 请求退出全屏，由外层播放器视图处理。
@property (nonatomic, copy, nullable) void (^exitFullScreenHandler)(SUDOPVideo *video);

/// destroy，由外层播放器视图移除 UI。
@property (nonatomic, copy, nullable) void (^destroyHandler)(SUDOPVideo *video);

#pragma mark - Init

- (instancetype)initWithInstanceID:(NSInteger)instanceID;

#pragma mark - Setup

- (void)setupWithX:(CGFloat)x
                 y:(CGFloat)y
             width:(CGFloat)width
            height:(CGFloat)height
               src:(nullable NSString *)src
            poster:(nullable NSString *)poster
       initialTime:(NSTimeInterval)initialTime
      playbackRate:(CGFloat)playbackRate
              live:(BOOL)live
         objectFit:(NSString *)objectFit
          controls:(BOOL)controls
      showProgress:(BOOL)showProgress
showProgressInControlMode:(BOOL)showProgressInControlMode
   backgroundColor:(NSString *)backgroundColor
          autoplay:(BOOL)autoplay
              loop:(BOOL)loop
             muted:(BOOL)muted
   obeyMuteSwitch:(BOOL)obeyMuteSwitch
enableProgressGesture:(BOOL)enableProgressGesture
 enablePlayGesture:(BOOL)enablePlayGesture
 showCenterPlayBtn:(BOOL)showCenterPlayBtn
     underGameView:(BOOL)underGameView
autoPauseIfNavigate:(BOOL)autoPauseIfNavigate
autoPauseIfOpenNative:(BOOL)autoPauseIfOpenNative;

#pragma mark - Layout Update

- (void)updateX:(CGFloat)x;
- (void)updateY:(CGFloat)y;
- (void)updateWidth:(CGFloat)width;
- (void)updateHeight:(CGFloat)height;

- (void)updateFrameWithX:(CGFloat)x
                       y:(CGFloat)y
                   width:(CGFloat)width
                  height:(CGFloat)height;

#pragma mark - Video Size Update

/// 更新视频真实宽高，来自 sud-video-onResize。
- (void)updateVideoSizeWithWidth:(CGFloat)videoWidth
                          height:(CGFloat)videoHeight;

#pragma mark - Style Update

- (void)updateUnderGameView:(BOOL)underGameView;
- (void)updateBackgroundColor:(NSString *)backgroundColor;
- (void)updateObjectFit:(NSString *)objectFit;

#pragma mark - Playback State

- (void)play;
- (void)pause;
- (void)stop;
- (void)seek:(NSTimeInterval)time;
- (void)destroy;

#pragma mark - FullScreen

- (void)requestFullScreenWithDirection:(NSInteger)direction;
- (void)exitFullScreen;

/// 外层完成全屏切换后回写状态。
- (void)notifyFullScreenChanged:(BOOL)fullScreen;

@end

NS_ASSUME_NONNULL_END
