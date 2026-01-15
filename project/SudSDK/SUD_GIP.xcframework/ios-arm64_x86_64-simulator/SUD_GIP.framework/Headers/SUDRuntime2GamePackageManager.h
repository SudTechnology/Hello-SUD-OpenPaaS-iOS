//
//  SUDRuntime2GamePackageManager.h
//  SUD_GIP
//
//  Created by kaniel on 1/14/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** * SUD Runtime Asset & Package Management Constants
 * These keys are used for configuring and identifying game package metadata.
 */

/// The remote URL where the game package can be downloaded from.
extern NSString * const SUD_RT2_KEY_PACKAGE_URL;

/// The SHA-256 or MD5 hash string used to verify the integrity of the downloaded package.
extern NSString * const SUD_RT2_KEY_PACKAGE_HASH;

/// The local storage path where the package file (.zip/.cpk) is located.
extern NSString * const SUD_RT2_KEY_PACKAGE_PATH;

/// Boolean flag indicating whether the package should be unzipped (extract mode) or read directly.
extern NSString * const SUD_RT2_KEY_PACKAGE_IS_EXTRACT_MODE;

/// The unique identifier (ID) assigned to the specific game.
extern NSString * const SUD_RT2_KEY_PACKAGE_GAME_ID;

/// The version string of the game package (e.g., "1.0.2").
extern NSString * const SUD_RT2_KEY_PACKAGE_VERSION;

/// Boolean flag indicating whether to merge new package data with existing local files.
extern NSString * const SUD_RT2_KEY_PACKAGE_MERGE;

/// Boolean flag indicating whether the source CPK/package file should be deleted after extraction.
extern NSString * const SUD_RT2_KEY_PACKAGE_DELETE_CPK;

/// A dictionary or string for passing additional custom parameters or metadata.
extern NSString * const SUD_RT2_KEY_PACKAGE_EXTRA;

/// The relative or absolute path to the main content directory inside the package.
extern NSString * const SUD_RT2_KEY_PACKAGE_CONTENT_PATH;

/// The file path to the package's detailed configuration or manifest file.
extern NSString * const SUD_RT2_KEY_PACKAGE_DETAIL_PATH;

/// The root directory for sub-packages or split asset bundles.
extern NSString * const SUD_RT2_KEY_PACKAGE_SUBPACKAGE_ROOT;

@protocol SUDRuntime2GameConfig;

/**
 * @protocol SUDRuntime2GamePackageManager
 * @brief Manages the lifecycle of game packages, including downloading, installation, and retrieval.
 */
@protocol SUDRuntime2GamePackageManager <NSObject>

/**
 * Updates or sets the package metadata for a specific game.
 * @param gameId Unique identifier for the game.
 * @param info Dictionary containing package configuration (refer to SUD_RT2_KEY_PACKAGE constants).
 * @return YES if the info was successfully set, NO otherwise.
 */
- (BOOL)setPackageInfo:(nonnull NSString *)gameId info:(nonnull NSDictionary *)info;

/**
 * Retrieves the configuration object for the Cocos engine for a specific game.
 * @param gameId Unique identifier for the game.
 * @return An object conforming to CRCocosGameConfigV2.
 */
- (id<SUDRuntime2GameConfig>)getGameConfig:(nonnull NSString *)gameId;

/**
 * Retrieves the currently stored package information for a game.
 * @param gameId Unique identifier for the game.
 * @return A dictionary of package metadata, or nil if not found.
 */
- (nullable NSDictionary *)getPackageInfo:(nonnull NSString *)gameId;

/**
 * Cancels all ongoing package download requests.
 */
- (void)cancelPackageRequest;

/**
 * Downloads a game package from a remote server.
 * @param info Metadata containing SUD_RT2_KEY_PACKAGE_URL and HASH.
 * @param start Callback triggered when the download begins.
 * @param retry Callback triggered upon a retry attempt, providing the current retry count.
 * @param progress Callback providing the downloaded size and total expected size in bytes.
 * @param completion Callback triggered when finished. Path is the local file location on success.
 */
- (void)downloadPackage:(nonnull NSDictionary *)info
                  start:(nullable void (^)(void))start
                  retry:(nullable void (^)(int retryNo))retry
               progress:(nullable void (^)(long downloadedSize, long totalSize))progress
             completion:(nullable void (^)(NSString * _Nullable path, NSError * _Nullable error))completion;

/**
 * Installs (extracts/verifies) a downloaded game package.
 * @param info Metadata containing extraction paths and modes.
 * @param start Callback triggered when the installation process begins.
 * @param progress Callback providing the completion percentage (0.0 to 1.0).
 * @param completion Callback triggered when finished. Error is nil if installation succeeded.
 */
- (void)installPackage:(NSDictionary *)info
                 start:(nullable void (^)(void))start
              progress:(nullable void (^)(float percent))progress
            completion:(nullable void (^)(NSError * _Nullable error))completion;

/**
 * Fetches a list of all locally cached or available game packages.
 * @param completion Callback providing an array of package info dictionaries.
 */
- (void)listPackageWithCompletion:(nullable void (^)(NSArray<NSDictionary *> * _Nullable list, NSError * _Nullable error))completion;

/**
 * Deletes a game package and its associated assets from local storage.
 * @param gameId Unique identifier for the game to be removed.
 * @param completion Callback triggered once the deletion is finalized.
 */
- (void)removePackage:(nonnull NSString *)gameId completion:(nullable void (^)(NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
