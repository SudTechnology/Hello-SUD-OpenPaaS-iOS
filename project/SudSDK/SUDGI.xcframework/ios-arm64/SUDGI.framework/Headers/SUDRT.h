//
//  SUDRT.h
//  SUDGI
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>
#import "SUDRTGameHandle.h"
#import "SUDRTLoadPackageParamModel.h"
NS_ASSUME_NONNULL_BEGIN

#pragma mark - Runtime Constants

/// Key for the directory path where Core resource assets are located.
extern NSString * const SUDRT_KEY_RUNTIME_ASSETS_PATH;
/// Key for retrieving the Game Package Manager component.
extern NSString * const SUDRT_KEY_MANAGER_GAME_PACKAGE;
/// Key for retrieving the User Manager component.
extern NSString * const SUDRT_KEY_MANAGER_USER;
/// Key for retrieving the Plugin Manager component.
extern NSString * const SUDRT_KEY_MANAGER_PLUGIN;
/// Key for the storage path where the Runtime installs game packages.
extern NSString * const SUDRT_KEY_RUNTIME_STORAGE_PATH_APP;
/// Key for the temporary directory used for Runtime caching.
extern NSString * const SUDRT_KEY_RUNTIME_STORAGE_PATH_CACHE;
/// Key for the storage path where Runtime persists user-specific game data.
extern NSString * const SUDRT_KEY_RUNTIME_STORAGE_PATH_USER;
/// Key for the storage path dedicated to Runtime plugins.
extern NSString * const SUDRT_KEY_RUNTIME_STORAGE_PATH_PLUGIN;
/// Key identifying the specific Runtime engine type.
extern NSString * const SUDRT_KEY_RUNTIME_TYPE;

@protocol SUDRT;

/**
 * Protocol defining the core capabilities and lifecycle of the Game Runtime.
 */
@protocol SUDRT <NSObject>

/**
 * Returns a descriptive string of the current Runtime.
 */
+ (NSString *)getRuntimeDescription;

/**
 * Returns a list of supported features or capabilities of this Runtime.
 */
+ (nullable NSArray<NSString *> *)getRuntimeFeatures;

/**
 * Returns the version string of the Runtime engine.
 */
+ (NSString *)getRuntimeVersion;

/**
 * Cancels any active file cleanup or maintenance tasks.
 */
- (void)cancelCleanUp;

/**
 * Cleans up expired temporary files and caches.
 * * @param keepTimeInMinute Files older than this duration (in minutes) will be deleted.
 * @param start Called when the cleanup process begins.
 * @param progress Called per file, providing the path and any error encountered.
 * @param completion Called when the entire cleanup task is finished.
 */
- (void)cleanUpExpiredTemporaryFiles:(NSInteger)keepTimeInMinute
                               start:(nullable void (^)(void))start
                            progress:(nullable void (^)(NSString *path, NSError * _Nullable error))progress
                          completion:(nullable void (^)(NSError * _Nullable error))completion;

/**
 * Initializes a game handle with specific configuration options.
 * * @param options Dictionary containing parameters for handle creation.
 * @param completion Callback returning the handle or an error.
 */
- (void)createGameHandleWithOptions:(NSDictionary *)options
                         completion:(nullable void (^)(id<SUDRTGameHandle> _Nullable handle,
                                                       NSError * _Nullable error))completion;

/**
 * Retrieves a specific manager component by name.
 * * @param name The constant key identifying the manager (e.g., SUDRT_KEY_MANAGER_USER).
 * @param options Optional parameters for manager retrieval.
 * @return The manager instance, or nil if not found.
 */
- (nullable NSObject *)getManagerWithName:(NSString *)name options:(nullable NSDictionary *)options;

/**
 * Loads a game package based on provided parameters.
 * * @param paramModel Model containing package metadata and load settings.
 * @param progress Callback for monitoring load progress (0-100).
 * @param completion Callback indicating success or failure of the load.
 */
- (void)loadPackage:(SUDRTLoadPackageParamModel *)paramModel
           progress:(nullable void(^)(NSInteger progress))progress
         completion:(nullable void(^)(NSError *_Nullable error))completion;

@end
NS_ASSUME_NONNULL_END
