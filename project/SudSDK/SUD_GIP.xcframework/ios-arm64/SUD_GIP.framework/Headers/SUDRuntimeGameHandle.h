//
//  SUDRuntimeGameHandle.h
//  SUD_GIP
//
//  Created by kaniel on 10/18/25.
//

#ifndef SUDRuntimeGameHandle_h
#define SUDRuntimeGameHandle_h

#import <Foundation/Foundation.h>
#import "SUDRuntimeGameMediaPlayerHandle.h"
#import "SUDRuntimeGameAudioSession.h"

NS_ASSUME_NONNULL_BEGIN

/// Pixel ratio
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_PIXEL_RATIO;
/// Limit download content size
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_LIMIT_DOWNLOAD_CONTENT_SIZE;
/// Limit user storage size
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_LIMIT_USER_STORAGE;
/// Limit localStorage size
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_LIMIT_LOCAL_STORAGE;
/// JSC obfuscation secret key
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_JSC_SECRET_KEY;
/// Custom JS entry
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_CUSTOM_JS_ENTRY;
/// Custom search path
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_CUSTOM_SEARCH_PATH;
/// Disable default JS entry
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_DISABLE_DEFAULT_JS_ENTRY;
/// Game version
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_GAME_VERSION;
/// Game launch parameters
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_LAUNCH_OPTIONS;
/// Company name
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_COMPANY_NAME;
/// Company ID
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_COMPANY_ID;
/// Statistics service ID
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_STATISTICS_SERVICE_ID;

/// Whether to enable JS debugger support
extern NSString * const SUD_RT_KEY_GAME_DEBUG_OPTION_ENABLE_DEBUGGER;
/// Whether to enable FPS display
extern NSString * const SUD_RT_KEY_GAME_DEBUG_OPTION_ENABLE_FPS;
/// Whether to enable VConsole
extern NSString * const SUD_RT_KEY_GAME_DEBUG_OPTION_ENABLE_V_CONSOLE;

/// Download network timeout
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_DOWNLOAD;
/// Upload network timeout
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_UPLOAD;
/// WebSocket network timeout
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_WEB_SOCKET;
/// XMLHttpRequest network timeout
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_NETWORK_TIMEOUT_XML_HTTP_REQUEST;

/// Whether to allow execution of dynamic scripts
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_ENABLE_THIRD_SCRIPT;
/// Whether to enable game launch timing logs
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_ENABLE_TIMING_LOG;
/// Set game render thread mode
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_RENDER_THREAD_MODE;

/// HTTP cache storage limit
extern NSString * const SUD_RT_KEY_GAME_HTTP_CACHE_LIMIT_STORAGE;
/// HTTP cache path
extern NSString * const SUD_RT_KEY_GAME_HTTP_CACHE_PATH;

/// Game user ID
extern NSString * const SUD_RT_KEY_GAME_USER_ID;

/// Whether to force WebGLContextAttributes alpha to true
extern NSString * const SUD_RT_KEY_GAME_START_OPTIONS_WEBGL_CONTEXT_FORCE_ALPHA;


typedef NS_ENUM(NSUInteger, SUDRuntimeGameState) {
    SUD_RT_GAME_STATE_UNAVAILABLE = 0,
    SUD_RT_GAME_STATE_WAITING = 1,
    SUD_RT_GAME_STATE_RUNNING = 2,
    SUD_RT_GAME_STATE_PLAYING = 3,
};

typedef NS_ENUM(NSUInteger, SUDRuntimeRenderThreadMode) {
    SUD_RT_RENDER_THREAD_MODE_AUTO = 0,
    SUD_RT_RENDER_THREAD_MODE_GAME_THREAD = 1,
    SUD_RT_RENDER_THREAD_MODE_STANDALONE = 2,
    SUD_RT_RENDER_THREAD_MODE_UI_THREAD = 3
};

typedef NS_ENUM(NSUInteger, SUDRuntimePermissionAuthStatus) {
    SUD_RT_PERMISSION_AUTH_STATUS_UNDETERMINED = 0,
    SUD_RT_PERMISSION_AUTH_STATUS_GRANTED = 1,
    SUD_RT_PERMISSION_AUTH_STATUS_DENIED = 2,
};

typedef NS_ENUM(NSUInteger, SUDRuntimeSystemPermissionAuthStatus) {
    SUD_RT_SYSTEM_PERMISSION_AUTH_STATUS_UNDETERMINED = 0,
    SUD_RT_SYSTEM_PERMISSION_AUTH_STATUS_GRANTED = 1,
    SUD_RT_SYSTEM_PERMISSION_AUTH_STATUS_DENIED = 2,
};

@class UIView;

@protocol SUDRuntimeGameAudioSession;

@protocol SUDRuntimeGameCustomCommandHandle <NSObject>
- (void)customCommandFailure:(NSString *)err;
- (void)customCommandSuccess;
- (void)pushResultWithBool:(BOOL)res;
- (void)pushResultWithBoolArr:(NSArray<NSNumber *> *)res;
- (void)pushResultWithDouble:(double)res;
- (void)pushResultWithDoubleArr:(NSData *)res;
- (void)pushResultWithFloatArr:(NSData *)res;
- (void)pushResultWithInt8Arr:(NSData *)res;
- (void)pushResultWithInt16Arr:(NSData *)res;
- (void)pushResultWithInt32Arr:(NSData *)res;
- (void)pushResultWithLong:(long)res;
- (void)pushResultWithString:(NSString *)res;
- (void)pushResultWithStringArr:(NSArray<NSString *> *)res;
- (void)pushResultNull;
@end

@protocol SUDRuntimeGameCustomCommandListener <NSObject>

@optional
- (void)onCallCustomCommand:(id<SUDRuntimeGameCustomCommandHandle>)handle info:(nullable NSDictionary *)argv;

- (void)onCallCustomCommandSync:(id<SUDRuntimeGameCustomCommandHandle>)handle info:(nullable NSDictionary *)argv;

@end

@protocol SUDRuntimeGameDrawFrameListener <NSObject>

@optional
- (void)onDrawFrame:(long)frameCounter;

@end

@protocol SUDRuntimeGameFatalErrorListener <NSObject>

@optional
- (void)onGameFatalError:(NSString *)message;

@end

@protocol SUDRuntimeGameLoadSubpackageHandle <NSObject>

- (void)loadSubpackageFailure:(NSString *)packageName withError:(NSString *)error;

- (void)loadSubpackageProgress:(NSString *)packageName downloaded:(long)written total:(long)total;

- (void)loadSubpackageSuccess:(NSString *)packageName root:(NSString *)packageRoot;

@end

@protocol SUDRuntimeGameLoadSubpackageListener <NSObject>

@optional
- (void)onLoadSubpackage:(id<SUDRuntimeGameLoadSubpackageHandle>)handle name:(NSString *)name root:(NSString *)root;

@end

@protocol SUDRuntimeGameQueryClipboardHandle <NSObject>

- (void)allowGetClipboardData:(NSString *)data;

- (void)allowSetClipboardData:(NSString *)data;

- (void)rejectGetClipboardData;

- (void)rejectSetClipboardData;

@end

@protocol SUDRuntimeGameQueryClipboardListener <NSObject>

@optional
- (void)onGetClipboardData:(id<SUDRuntimeGameQueryClipboardHandle>)handle
                      data:(NSString *)data
                     appId:(NSString *)appId;

- (void)onSetClipboardData:(id<SUDRuntimeGameQueryClipboardHandle>)handle
                      data:(NSString *)data
                     appId:(NSString *)appId;

@end

@protocol SUDRuntimeGameQueryExitListener <NSObject>

@optional
- (void)onQueryExit:(NSString *)appID result:(nullable NSString *)result;

@end

@protocol SUDRuntimeGameQueryPermissionHandle <NSObject>

- (void)completeQueryPermission:(NSString *)permission authStatus:(SUDRuntimePermissionAuthStatus)authStatus;

@end

@protocol SUDRuntimeGameQueryPermissionListener <NSObject>

- (void)onQueryPermission:(id<SUDRuntimeGameQueryPermissionHandle>)handle
               permission:(NSString *)permission
                    appId:(NSString *)appId
               authStatus:(SUDRuntimePermissionAuthStatus)authStatus;

@end

@protocol SUDRuntimeGameQuerySystemPermissionHandle <NSObject>

- (void)continueQuerySystemPermission:(NSString *)permission;

@end

@protocol SUDRuntimeGameQuerySystemPermissionListener <NSObject>

@optional
- (void)beforeQuerySystemPermission:(id<SUDRuntimeGameQuerySystemPermissionHandle>)handle
                       fromJSMethod:(NSString *)methodName
                         permission:(NSString *)permission
                              appId:(NSString *)appId
                         authStatus:(SUDRuntimeSystemPermissionAuthStatus)authStatus
                      serviceStatus:(BOOL)enabled;

@end

@protocol SUDRuntimeGameStateChangeListener <NSObject>

@optional
- (void)onStateChangedFailureFrom:(int)fromState to:(int)toSstate error:(NSError *)error;

- (void)onStateChangedFrom:(int)fromState to:(int)toState;

- (void)preStateChangedFrom:(int)fromState to:(int)toState;

@end

@protocol SUDRuntimeGameScreenStateChangeListener <NSObject>

@optional
- (BOOL)queryChangeScreenBrightness:(float)brightness info:(NSDictionary *)info;

- (BOOL)queryChangeScreenKeepOn:(BOOL)keepOn info:(NSDictionary *)info;

@end

@protocol SUDRuntimeMediaPlayerListener <NSObject>

- (void)onMediaPlayerCreated:(UInt64) instanceID;

- (void)onMediaPlayerDestroyed:(UInt64) instanceID;

@end

@protocol SUDRuntimeGameHandle <NSObject>

- (void)create;

- (void)destroy;

- (id<SUDRuntimeGameAudioSession>)getGameAudioSession;

- (id<SUDRuntimeGameMediaPlayerHandle>)getMediaPlayerHandle:(UInt64) instanceID;

- (NSInteger)getGameState;

- (nullable UIView *)getGameView;

- (void)pause;

- (void)play;

- (void)runScript:(NSString *)script
       completion:(nullable void (^)(NSString * _Nullable returnType,
                                     NSDictionary * _Nullable returnValue,
                                     NSError * _Nullable error))completion;

- (void)setCustomCommandListener:(nullable id<SUDRuntimeGameCustomCommandListener>)listener;

- (void)setGameDrawFrameListener:(nullable id<SUDRuntimeGameDrawFrameListener>)listener;

- (void)setGameFatalErrorListener:(nullable id<SUDRuntimeGameFatalErrorListener>)listener;

- (void)setGameLoadSubpackageListener:(nullable id<SUDRuntimeGameLoadSubpackageListener>)listener;

- (void)setGameQueryClipboardListener:(nullable id<SUDRuntimeGameQueryClipboardListener>)listener;

- (void)setGameQueryExitListener:(nullable id<SUDRuntimeGameQueryExitListener>)listener;

- (void)setGameQueryPermissionListener:(nullable id<SUDRuntimeGameQueryPermissionListener>)listener;

- (void)setGameQuerySystemPermissionListener:(nullable id<SUDRuntimeGameQuerySystemPermissionListener>)listener;

- (BOOL)setGameStartOptions:(NSString *)gameId options:(NSDictionary *)options;

- (void)setGameStateListener:(nullable id<SUDRuntimeGameStateChangeListener>)listener;

- (void)setGameScreenStateChangeListener:(nullable id<SUDRuntimeGameScreenStateChangeListener>)listener;

- (void)setMediaPlayerListener:(nullable id<SUDRuntimeMediaPlayerListener>)listener;

- (void)start:(nullable NSString *)onShowMsg;

- (void)stop:(nullable NSString *)onHideMsg;

@end

NS_ASSUME_NONNULL_END


#endif /* SUDRuntimeGameHandle_h */
