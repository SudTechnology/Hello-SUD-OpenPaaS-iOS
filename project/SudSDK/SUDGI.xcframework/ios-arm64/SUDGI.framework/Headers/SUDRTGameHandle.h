//
//  SUDRTGameHandle.h
//  SUDGI
//
//  Created by kaniel on 10/18/25.
//

#ifndef SUDRTGameHandle_h
#define SUDRTGameHandle_h

#import <Foundation/Foundation.h>
#import "SUDRTGameMediaPlayerHandle.h"
#import "SUDRTGameAudioSession.h"
#import "SUDOPCommon.h"
NS_ASSUME_NONNULL_BEGIN

/// Pixel ratio
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_PIXEL_RATIO;
/// Limit download content size
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_LIMIT_DOWNLOAD_CONTENT_SIZE;
/// Limit user storage size
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_LIMIT_USER_STORAGE;
/// Limit localStorage size
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_LIMIT_LOCAL_STORAGE;
/// JSC obfuscation secret key
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_JSC_SECRET_KEY;
/// Custom JS entry
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_CUSTOM_JS_ENTRY;
/// Custom search path
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_CUSTOM_SEARCH_PATH;
/// Disable default JS entry
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_DISABLE_DEFAULT_JS_ENTRY;
/// Game version
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_GAME_VERSION;
/// Game launch parameters
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_LAUNCH_OPTIONS;
/// Company name
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_COMPANY_NAME;
/// Company ID
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_COMPANY_ID;
/// Statistics service ID
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_STATISTICS_SERVICE_ID;

/// Whether to enable JS debugger support
extern NSString * const SUDRT_KEY_GAME_DEBUG_OPTION_ENABLE_DEBUGGER;
/// Whether to enable FPS display
extern NSString * const SUDRT_KEY_GAME_DEBUG_OPTION_ENABLE_FPS;
/// Whether to enable VConsole
extern NSString * const SUDRT_KEY_GAME_DEBUG_OPTION_ENABLE_V_CONSOLE;

/// Download network timeout
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_DOWNLOAD;
/// Upload network timeout
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_UPLOAD;
/// WebSocket network timeout
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_WEB_SOCKET;
/// XMLHttpRequest network timeout
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_XML_HTTP_REQUEST;

/// Whether to allow execution of dynamic scripts
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_ENABLE_THIRD_SCRIPT;
/// Whether to enable game launch timing logs
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_ENABLE_TIMING_LOG;
/// Set game render thread mode
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_RENDER_THREAD_MODE;

/// HTTP cache storage limit
extern NSString * const SUDRT_KEY_GAME_HTTP_CACHE_LIMIT_STORAGE;
/// HTTP cache path
extern NSString * const SUDRT_KEY_GAME_HTTP_CACHE_PATH;

/// Game user ID
extern NSString * const SUDRT_KEY_GAME_USER_ID;

/// Whether to force WebGLContextAttributes alpha to true
extern NSString * const SUDRT_KEY_GAME_START_OPTIONS_WEBGL_CONTEXT_FORCE_ALPHA;

#pragma mark - Enumerations

/**
 * Represents the current lifecycle state of the game runtime.
 */
typedef NS_ENUM(NSUInteger, SUDRTGameState) {
    /// Game is not initialized or is currently unavailable.
    SUD_RT_GAME_STATE_UNAVAILABLE = 0,
    /// Game is initialized and waiting for a start command.
    SUD_RT_GAME_STATE_WAITING = 1,
    /// Game logic is running (may be in the background).
    SUD_RT_GAME_STATE_RUNNING = 2,
    /// Game is actively playing and visible to the user.
    SUD_RT_GAME_STATE_PLAYING = 3,
};

/**
 * Defines the threading model for the game's rendering engine.
 */
typedef NS_ENUM(NSUInteger, SUDRTRenderThreadMode) {
    /// Automatically determines the best rendering thread based on system load.
    SUD_RT_RENDER_THREAD_MODE_AUTO = 0,
    /// Renders on the dedicated game logic thread.
    SUD_RT_RENDER_THREAD_MODE_GAME_THREAD = 1,
    /// Renders on a standalone, high-priority background thread.
    SUD_RT_RENDER_THREAD_MODE_STANDALONE = 2,
    /// Renders on the main UI thread (use with caution to avoid stutters).
    SUD_RT_RENDER_THREAD_MODE_UI_THREAD = 3
};

/**
 * Authentication status for specific game-level permissions.
 */
typedef NS_ENUM(NSUInteger, SUDRTPermissionAuthStatus) {
    /// The user has not yet been asked for permission.
    SUD_RT_PERMISSION_AUTH_STATUS_UNDETERMINED = 0,
    /// Permission has been granted by the user.
    SUD_RT_PERMISSION_AUTH_STATUS_GRANTED = 1,
    /// Permission has been explicitly denied.
    SUD_RT_PERMISSION_AUTH_STATUS_DENIED = 2,
};

/**
 * Authentication status for OS-level system permissions (e.g., Camera, Mic).
 */
typedef NS_ENUM(NSUInteger, SUDRTSystemPermissionAuthStatus) {
    /// System permission state is unknown.
    SUD_RT_SYSTEM_PERMISSION_AUTH_STATUS_UNDETERMINED = 0,
    /// System permission is granted.
    SUD_RT_SYSTEM_PERMISSION_AUTH_STATUS_GRANTED = 1,
    /// System permission is denied.
    SUD_RT_SYSTEM_PERMISSION_AUTH_STATUS_DENIED = 2,
};

@class UIView;
@protocol SUDRTGameAudioSession;

#pragma mark - Protocols (Listeners & Handles)

/**
 * Handle for responding to custom commands sent from the game script.
 */
@protocol SUDRTGameCustomCommandHandle <NSObject>
/// Reports a failed command execution with an error message.
- (void)customCommandFailure:(NSString *)err;
/// Reports a successful command execution.
- (void)customCommandSuccess;
/// Returns a boolean result to the game.
- (void)pushResultWithBool:(BOOL)res;
/// Returns an array of booleans to the game.
- (void)pushResultWithBoolArr:(NSArray<NSNumber *> *)res;
/// Returns a double-precision floating point result.
- (void)pushResultWithDouble:(double)res;
/// Returns raw double array data.
- (void)pushResultWithDoubleArr:(NSData *)res;
/// Returns raw float array data.
- (void)pushResultWithFloatArr:(NSData *)res;
/// Returns raw Int8 array data.
- (void)pushResultWithInt8Arr:(NSData *)res;
/// Returns raw Int16 array data.
- (void)pushResultWithInt16Arr:(NSData *)res;
/// Returns raw Int32 array data.
- (void)pushResultWithInt32Arr:(NSData *)res;
/// Returns a long integer result.
- (void)pushResultWithLong:(long)res;
/// Returns a string result.
- (void)pushResultWithString:(NSString *)res;
/// Returns an array of strings.
- (void)pushResultWithStringArr:(NSArray<NSString *> *)res;
/// Returns a null/void result to the game.
- (void)pushResultNull;
@end

/**
 * Listener for custom business logic commands invoked by the game.
 */
@protocol SUDRTGameCustomCommandListener <NSObject>
@optional
/// Asynchronous custom command callback.
- (void)onCallCustomCommand:(id<SUDRTGameCustomCommandHandle>)handle info:(nullable NSDictionary *)argv;
/// Synchronous custom command callback.
- (void)onCallCustomCommandSync:(id<SUDRTGameCustomCommandHandle>)handle info:(nullable NSDictionary *)argv;
@end

/**
 * Listener for frame-by-frame rendering events.
 */
@protocol SUDRTGameDrawFrameListener <NSObject>
@optional
/// Called every time the game renders a frame.
- (void)onDrawFrame:(long)frameCounter;
@end

/**
 * Listener for unrecoverable game errors.
 */
@protocol SUDRTGameFatalErrorListener <NSObject>
@optional
/// Called when the game encounters a fatal error that prevents it from running.
- (void)onGameFatalError:(NSString *)message;
@end

/**
 * Handle for controlling the sub-package loading process.
 */
@protocol SUDRTGameLoadSubpackageHandle <NSObject>
/// Notify the game that a sub-package failed to load.
- (void)loadSubpackageFailure:(NSString *)packageName withError:(NSString *)error;
/// Update the game on sub-package download progress.
- (void)loadSubpackageProgress:(NSString *)packageName downloaded:(long)written total:(long)total;
/// Notify the game that a sub-package loaded successfully.
- (void)loadSubpackageSuccess:(NSString *)packageName root:(NSString *)packageRoot;
@end

/**
 * Listener for sub-package load requests from the game.
 */
@protocol SUDRTGameLoadSubpackageListener <NSObject>
@optional
/// Triggered when the game requests to load a specific code or resource sub-package.
- (void)onLoadSubpackage:(id<SUDRTGameLoadSubpackageHandle>)handle name:(NSString *)name root:(NSString *)root;
@end

/**
 * Handle for managing clipboard access requests.
 */
@protocol SUDRTGameQueryClipboardHandle <NSObject>
/// Grant permission and return data for a "get clipboard" request.
- (void)allowGetClipboardData:(NSString *)data;
/// Grant permission for a "set clipboard" request.
- (void)allowSetClipboardData:(NSString *)data;
/// Deny a "get clipboard" request.
- (void)rejectGetClipboardData;
/// Deny a "set clipboard" request.
- (void)rejectSetClipboardData;
@end

/**
 * Listener for clipboard interactions (Get/Set).
 */
@protocol SUDRTGameQueryClipboardListener <NSObject>
@optional
/// Called when the game attempts to read from the system clipboard.
- (void)onGetClipboardData:(id<SUDRTGameQueryClipboardHandle>)handle data:(NSString *)data appId:(NSString *)appId;
/// Called when the game attempts to write to the system clipboard.
- (void)onSetClipboardData:(id<SUDRTGameQueryClipboardHandle>)handle data:(NSString *)data appId:(NSString *)appId;
@end

/**
 * Listener for exit confirmation.
 */
@protocol SUDRTGameQueryExitListener <NSObject>
@optional
/// Called when the game requests to close or exit.
- (void)onQueryExit:(NSString *)appID result:(nullable NSString *)result;
@end

/**
 * Handle for completing a game-level permission query.
 */
@protocol SUDRTGameQueryPermissionHandle <NSObject>
/// Respond to the game with the final authorization status.
- (void)completeQueryPermission:(NSString *)permission authStatus:(SUDRTPermissionAuthStatus)authStatus;
@end

/**
 * Listener for game-level permission requests.
 */
@protocol SUDRTGameQueryPermissionListener <NSObject>
/// Called when the game asks for a specific app-level permission.
- (void)onQueryPermission:(id<SUDRTGameQueryPermissionHandle>)handle permission:(NSString *)permission appId:(NSString *)appId authStatus:(SUDRTPermissionAuthStatus)authStatus;
@end

/**
 * Handle for mediating system-level permission flows.
 */
@protocol SUDRTGameQuerySystemPermissionHandle <NSObject>
/// Tells the SDK to proceed with the native system permission prompt.
- (void)continueQuerySystemPermission:(NSString *)permission;
@end

/**
 * Listener for OS-level system permission requests (Microphone, Camera, etc.).
 */
@protocol SUDRTGameQuerySystemPermissionListener <NSObject>
@optional
/// Called before the system permission dialog is shown to allow the app to show a custom rationale UI.
- (void)beforeQuerySystemPermission:(id<SUDRTGameQuerySystemPermissionHandle>)handle fromJSMethod:(NSString *)methodName permission:(NSString *)permission appId:(NSString *)appId authStatus:(SUDRTSystemPermissionAuthStatus)authStatus serviceStatus:(BOOL)enabled;
@end

/**
 * Listener for tracking game lifecycle state transitions.
 */
@protocol SUDRTGameStateChangeListener <NSObject>
@optional
/// Called if a state transition (e.g., Waiting -> Running) fails.
- (void)onStateChangedFailureFrom:(int)fromState to:(int)toSstate error:(NSError *)error;
/// Called after a successful state transition.
- (void)onStateChangedFrom:(int)fromState to:(int)toState;
/// Called just before a state transition occurs.
- (void)preStateChangedFrom:(int)fromState to:(int)toState;
@end

/**
 * Listener for hardware/screen state changes requested by the game.
 */
@protocol SUDRTGameScreenStateChangeListener <NSObject>
@optional
/// Called when the game wants to change screen brightness. Return YES to allow.
- (BOOL)queryChangeScreenBrightness:(float)brightness info:(NSDictionary *)info;
/// Called when the game wants to toggle "Keep Screen On". Return YES to allow.
- (BOOL)queryChangeScreenKeepOn:(BOOL)keepOn info:(NSDictionary *)info;
@end

/**
 * Listener for media player lifecycle events.
 */
@protocol SUDRuntimeMediaPlayerListener <NSObject>
/// Triggered when a new media player instance is created in the game.
- (void)onMediaPlayerCreated:(UInt64) instanceID;
/// Triggered when a media player instance is destroyed.
- (void)onMediaPlayerDestroyed:(UInt64) instanceID;
@end

/**
 * The primary interface for controlling an active game instance.
 */
@protocol SUDRTGameHandle <NSObject>

- (NSDictionary *)getDebuggableState;

/// Initializes the game resources.
- (void)create;

/// Destroys the game instance and releases all associated resources.
- (void)destroy;

/// Retrieves the audio session for managing game volume and routing.
- (id<SUDRTGameAudioSession>)getGameAudioSession;

/// Gets a specific media player handle by its instance ID.
- (id<SUDRTGameMediaPlayerHandle>)getMediaPlayerHandle:(UInt64) instanceID;

/// Returns the current SUDRTGameState.
- (NSInteger)getGameState;

/// Returns the UIView containing the game's rendered output.
- (nullable UIView *)getGameView;

/// Pauses the game logic and rendering.
- (void)pause;

/// Resumes the game from a paused state.
- (void)play;

- (void)preLoad;

- (void)preStart;

#pragma mark - Listener Registration

- (void)setGameDrawFrameListener:(nullable id<SUDRTGameDrawFrameListener>)listener;
- (void)setGameFatalErrorListener:(nullable id<SUDRTGameFatalErrorListener>)listener;
- (void)setGameLoadSubpackageListener:(nullable id<SUDRTGameLoadSubpackageListener>)listener;
- (void)setGameQueryClipboardListener:(nullable id<SUDRTGameQueryClipboardListener>)listener;
- (void)setGameQueryExitListener:(nullable id<SUDRTGameQueryExitListener>)listener;
- (void)setGameQueryPermissionListener:(nullable id<SUDRTGameQueryPermissionListener>)listener;
- (void)setGameQuerySystemPermissionListener:(nullable id<SUDRTGameQuerySystemPermissionListener>)listener;
- (void)setGameStateListener:(nullable id<SUDRTGameStateChangeListener>)listener;
- (void)setGameScreenStateChangeListener:(nullable id<SUDRTGameScreenStateChangeListener>)listener;
- (void)setMediaPlayerListener:(nullable id<SUDRuntimeMediaPlayerListener>)listener;

/// Configures initial startup options for a specific game ID.
- (BOOL)setGameStartOptions:(NSString *)gameId options:(NSDictionary *)options;

/// Starts the game. Optionally provide a message to pass to the game's "onShow" event.
- (void)start:(nullable NSString *)onShowMsg;

/// Stops the game. Optionally provide a message to pass to the game's "onHide" event.
- (void)stop:(nullable NSString *)onHideMsg;

/**
 * 注册客户端自定义功能模块
 * * 该方法允许 App 向 SDK 注册一个特定领域（Scope）的功能实现类。
 * 游戏引擎可以通过对应的 Scope 调用此 client 对象提供的方法。
 *
 * @param scope  功能所属的范围或命名空间（例如：@"wx"）。
 * 它决定了 SDK 如何识别和分发指令。
 * @param client 实现该功能的具体对象。通常需要符合 SDK 定义的某个特定 Protocol。
 */
- (void)registerExtendedClient:(NSString *)scope client:(NSObject *)client;
@end

NS_ASSUME_NONNULL_END


#endif /* SUDRTGameHandle_h */
