//
//  SUDRuntime2GameConfig.h
//  SUD_GIP
//
//  Created by kaniel on 1/14/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Network timeout keys used for mapping specific network operations
 * to their respective timeout durations in milliseconds.
 */
/// Timeout key for file download operations.
extern NSString * const SUD_RT2_GAME_CONFIG_NETWORK_TIMEOUT_DOWNLOAD;
/// Timeout key for file upload operations.
extern NSString * const SUD_RT2_GAME_CONFIG_NETWORK_TIMEOUT_UPLOAD;
/// Timeout key for establishing WebSocket connections.
extern NSString * const SUD_RT2_GAME_CONFIG_NETWORK_TIMEOUT_WEB_SOCKET;
/// Timeout key for general HTTP/REST API requests.
extern NSString * const SUD_RT2_GAME_CONFIG_NETWORK_TIMEOUT_REQUEST;

/**
 * Plugin configuration keys used within the plugin dictionaries.
 */
/// The provider or vendor name of the plugin.
extern NSString * const SUD_RT2_GAME_CONFIG_PLUGIN_PROVIDER;
/// The specific version string of the plugin.
extern NSString * const SUD_RT2_GAME_CONFIG_PLUGIN_VERSION;
/// The local filesystem path or resource path for the plugin.
extern NSString * const SUD_RT2_GAME_CONFIG_PLUGIN_PATH;

/**
 * @protocol SUDRuntime2GameConfig
 * @brief Provides configuration settings for the Cocos engine runtime environment.
 * Maps closely to the standard 'game.json' or 'project.config.json' settings in game development.
 */
@protocol SUDRuntime2GameConfig <NSObject>

/**
 * Determines whether the system status bar should be visible during gameplay.
 * @return YES to show the status bar, NO to hide it (full-screen mode).
 */
- (BOOL)showStatusBar;

/**
 * Returns a list of required game plugins and their metadata.
 * @return An array of dictionaries, or nil if no plugins are defined.
 */
- (nullable NSArray<NSDictionary *> *)plugins;

/**
 * Returns the configuration for split subpackages (on-demand loading).
 * @return An array of dictionaries containing subpackage root and name, or nil.
 */
- (nullable NSArray<NSDictionary *> *)subpackages;

/**
 * Returns a list of script paths designated for multi-threaded Worker execution.
 * @return An array of worker script strings, or nil.
 */
- (nullable NSArray<NSString *> *)workers;

/**
 * Returns the required system permissions for the game (e.g., UserInfo, Album, Camera).
 * @return A dictionary mapping permission keys to their descriptions, or nil.
 */
- (nullable NSDictionary *)permissions;

/**
 * Retrieves the timeout duration for a specific network operation type.
 * @param type Use the CR_GAME_CONFIG_NETWORK_TIMEOUT constants.
 * @return The timeout duration in milliseconds.
 */
- (NSInteger)getNetworkTimeout:(NSString *)type;

/**
 * Returns the preferred screen orientation for the game.
 * @return A string value (e.g., "portrait", "landscape", or "landscapeLeft").
 */
- (NSString *)deviceOrientation;

/**
 * Returns the target engine or runtime version required for compatibility.
 * @return The version string, or nil to use the default runtime.
 */
- (nullable NSString *)runtimeVersion;

@end

NS_ASSUME_NONNULL_END
