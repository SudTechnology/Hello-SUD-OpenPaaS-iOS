//
//  SUDRuntime2GamePluginManager.h
//  SUD_GIP
//
//  Created by kaniel on 1/14/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * Plugin Package Management Keys
 * These constants are used to define the metadata for external game plugins.
 */

/// The remote source URL for downloading the plugin package.
extern NSString * const SUD_RT2_KEY_PLUGIN_PACKAGE_URL;

/// The local filesystem path where the plugin package is or should be stored.
extern NSString * const SUD_RT2_KEY_PLUGIN_PACKAGE_PATH;

/// The hash value (e.g., MD5/SHA256) used to verify the integrity of the plugin file.
extern NSString * const SUD_RT2_KEY_PLUGIN_PACKAGE_HASH;

/// A boolean flag indicating whether the plugin needs to be unzipped/extracted before use.
extern NSString * const SUD_RT2_KEY_PLUGIN_PACKAGE_IS_EXTRACT_MODE;


/**
 * @protocol SUDRuntime2GamePluginManager
 * @brief Handles the discovery, downloading, and installation of game-specific plugins.
 */
@protocol SUDRuntime2GamePluginManager <NSObject>

/**
 * Aborts all current plugin-related network requests (downloads).
 */
- (void)cancelPluginRequest;

/**
 * Retrieves information about a specific plugin based on provided metadata.
 * @param info Dictionary containing plugin identification keys.
 * @return A dictionary containing plugin details, or nil if not found.
 */
- (nullable NSDictionary *)getPluginInfo:(nonnull NSDictionary *)info;

/**
 * Downloads a plugin package from a remote server.
 * @param info Metadata containing SUD_RT2_KEY_PLUGIN_PACKAGE_URL and HASH.
 * @param start Callback invoked when the download task initializes.
 * @param retry Callback invoked on network retry, providing the current attempt count.
 * @param progress Callback providing real-time download metrics in bytes.
 * @param completion Callback invoked when finished. 'path' is provided on success.
 */
- (void)downloadPlugin:(nonnull NSDictionary *)info
                 start:(nullable void (^)(void))start
                 retry:(nullable void (^)(int retryNo))retry
              progress:(nullable void (^)(long downloadedSize, long totalSize))progress
            completion:(nullable void (^)(NSString * _Nullable path, NSError * _Nullable error))completion;

/**
 * Installs or deploys a downloaded plugin package to the runtime environment.
 * @param info Metadata describing the installation source and destination.
 * @param start Callback invoked when the installation begins.
 * @param progress Callback providing installation completion percentage (0.0 - 1.0).
 * @param completion Callback invoked when finished. 'error' is nil on success.
 */
- (void)installPluginPackage:(nonnull NSDictionary *)info
                       start:(nullable void (^)(void))start
                    progress:(nullable void (^)(float percent))progress
                  completion:(nullable void (^)(NSError * _Nullable error))completion;

/**
 * Retrieves a list of all currently registered or available plugins.
 * @param completion Callback providing an array of plugin info dictionaries.
 */
- (void)listPluginWithCompletion:(nullable void (^)(NSArray<NSDictionary *> * _Nullable list, NSError * _Nullable error))completion;

/**
 * Removes a plugin package and cleans up its associated local assets.
 * @param info Metadata identifying the plugin to be removed.
 * @param completion Callback invoked once the uninstallation is complete.
 */
- (void)uninstallPluginPackage:(nonnull NSDictionary *)info
                    completion:(nullable void (^)(NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
