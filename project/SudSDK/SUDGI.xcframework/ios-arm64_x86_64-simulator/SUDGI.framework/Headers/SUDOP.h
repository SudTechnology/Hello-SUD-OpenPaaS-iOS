//
//  SUDRuntime.h
//  SUDGI
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>
//#import "ISUDLogger.h"
#import "SUDOPCommon.h"
#import "SUDOPWrappedClientDelegate.h"
#import "SUDOPGameTask.h"
#import "SUDRTLoadPackageParamModel.h"
#import "SUDRT.h"
#import "SUDRTGameMediaPlayerHandle.h"
#import "SUDRTGameAudioSession.h"
#import "SUDOPAd.h"
#import "SUDOPPrivacyConfig.h"

NS_ASSUME_NONNULL_BEGIN

/// SUDOP
@interface SUDOP : NSObject

/**
 Returns the SDK version.
 @return The SDK version string, for example, `1.1.35.286`.
 */
+ (nonnull NSString *)getVersion;

/**
 Returns the SDK version alias.
 @return The SDK version alias string, for example, `v1.1.35.286-et`.
 */
+ (nonnull NSString *)getVersionAlias;

/**
 Initialize the SDK.
 @param configuration The configuration used to initialize the SDK environment.
 @param completion Called when initialization finishes.
 */
+(void)initializeWithConfiguration:(SUDOPSDKConfiguration *)configuration
                        completion:(nullable SUDOPCompletionBlock)completion;

/**
 Reset the initialized SDK, called when SDK re-initialization is needed.
 */
+(void)uninitialize;

/**
 * Sets the delegate client to handle required callbacks and interface
 * implementations from the SDK to the host application.
 */
+ (void)registerWrappedClientWithGameHandle:(nonnull id<SUDRTGameHandle>)gameHandle
                             clientDelegate:(nonnull id<SUDOPWrappedClientDelegate>)clientDelegate;

/**
 * 设置宿主广告事件监听，仅用于观察广告生命周期，不负责创建或展示广告。
 */
+ (void)setAdEventListener:(nullable id<SUDOPAdEventListener>)listener;

/**
 * 设置宿主已确认的隐私配置。
 * 可在初始化前调用（初始化时随广告 SDK 一起生效），也可在初始化后调用进行热更新。
 * 传入 nil 表示清除当前隐私配置快照。
 */
+ (void)setPrivacyConfig:(nullable SUDOPPrivacyConfig *)config;

/**
 Create a runtime instance (single process has only one).
 @param options Optional configuration parameters for the runtime.
 @param completion Completion callback.
 */
+(void)createRuntime:(NSDictionary *_Nullable)options
          completion:(nullable void(^)(id<SUDRT> _Nullable runtime, NSError *_Nullable error))completion;

/**
 Authenticate the SDK with a user signature.
 @param userSignature The signature used to authenticate the user.
 @param completion Called when authentication finishes.
 */
+ (void)authWithUserSignature:(NSString *)userSignature
                   completion:(nullable SUDOPCompletionBlock)completion;

/**
 Request a game signature from the server using the specified game ID.
 @param gameID The unique identifier of the game.
 @param completion Called when the signature request finishes.
 */
+ (void)getGameSignatureWithGameID:(nonnull NSString *)gameID
                        completion:(nullable void(^)(NSString *_Nullable gameSignature, NSError *_Nullable error))completion;

/**
 Request a localized game signature from the server.
 @param gameID The unique identifier of the game.
 @param language The language identifier, for example, `zh-CN`. Nil or empty uses the server default.
 @param completion Called when the signature request finishes.
 */
+ (void)getGameSignatureWithGameID:(nonnull NSString *)gameID
                            language:(nullable NSString *)language
                          completion:(nullable void(^)(NSString *_Nullable gameSignature, NSError *_Nullable error))completion;
/**
 Retrieves game information asynchronously for the specified game ID.
 @param gameID The unique identifier of the game. Must not be nil.
 @param completion The completion block to be called when the request finishes.
        The block contains the retrieved game information object, or an error if the request failed.
        Called on the main thread.
 */
+ (void)getGameInformationWithGameID:(nonnull NSString *)gameID
                          completion:(nullable void(^)(SUDOPGameInformation *_Nullable gameInformation, NSError *_Nullable error))completion;

/**
 Retrieves localized game information asynchronously for the specified game ID.
 @param gameID The unique identifier of the game. Must not be nil.
 @param language The requested language identifier, for example, `zh-CN`. Must not be nil.
 @param completion The completion block to be called when the request finishes.
        The block contains the retrieved game information object, or an error if the request failed.
        Called on the main thread.
 */
+ (void)getGameInformationWithGameID:(nonnull NSString *)gameID
                            language:(nonnull NSString *)language
                          completion:(nullable void(^)(SUDOPGameInformation *_Nullable gameInformation, NSError *_Nullable error))completion;

/**
 Retrieves a page of games.
 @param options Pagination and language options. Nil uses pageNo 0, pageSize 10 and the server default language.
 @param completion Called on the main thread with the game list result or an error.
 */
+ (void)getGameListWithOptions:(nullable SUDOPGameListOptions *)options
                    completion:(nullable void(^)(SUDOPGameListResult *_Nullable result, NSError *_Nullable error))completion;

/**
 Retrieves a page of games for a selection.
 @param selectionId Non-empty game selection ID string, passed without numeric conversion.
 @param options Pagination and language options. Nil uses pageNo 0, pageSize 10 and the server default language.
 @param completion Called on the main thread with the game list result or an error.
 */
+ (void)getGameListWithSelectionId:(NSString *)selectionId
                          options:(nullable SUDOPGameListOptions *)options
                       completion:(nullable void(^)(SUDOPGameListResult *_Nullable result, NSError *_Nullable error))completion;

/**
 Retrieves game selections from /v1/game/getSelectionList after SDK initialization.
 User authentication is not required. Nil options default to page 0 and size 10.
 */
+ (void)getSelectionListWithOptions:(nullable SUDOPSelectionListOptions *)options
                        completion:(nullable void(^)(SUDOPSelectionListResult *_Nullable result, NSError *_Nullable error))completion;

/**
 Retrieves game categories from /v1/game/getCategories after SDK initialization.
 User authentication is required. Nil options default to page 0 and size 10.
 */
+ (void)getCategoryListWithOptions:(nullable SUDOPCategoryListOptions *)options
                        completion:(nullable void(^)(SUDOPCategoryListResult *_Nullable result, NSError *_Nullable error))completion;

/**
 Retrieves a page of games filtered by category from /v1/game/getListByCategory.
 User authentication is required. Nil options default to page 0 and size 10.
 */
+ (void)getGameListWithCategoryOptions:(nullable SUDOPGameListByCategoryOptions *)options
                            completion:(nullable void(^)(SUDOPGameListResult *_Nullable result, NSError *_Nullable error))completion;

#pragma mark - Pre-download Operations

+ (id<SUDOPGameTask>)preDownloadGame:(nonnull NSString *)gameID
                          completion:(nullable SUDOPCompletionBlock)completion;

+ (id<SUDOPGameTask>)preDownloadGameWithSignature:(nonnull NSString *)gameSignature
                                       completion:(nullable SUDOPCompletionBlock)completion;

+ (id<SUDOPGameTask>)preDownloadGameWithURL:(NSString *)url
                                    options:(nullable SUDOPGamePackageOptions *)options
                                 completion:(nullable SUDOPCompletionBlock)completion;

#pragma mark - Preload Operations

+ (id<SUDOPGameTask>)preLoadGame:(NSString *)gameID
                      completion:(nullable SUDOPGameOperationCompletionBlock)completion;

+ (id<SUDOPGameTask>)preLoadGameWithSignature:(NSString *)gameSignature
                                   completion:(nullable SUDOPGameOperationCompletionBlock)completion;

+ (id<SUDOPGameTask>)preLoadGameWithPkgPath:(NSString *)pkgPath
                                    options:(SUDOPGamePackageOptions *)options
                                 completion:(nullable SUDOPGameOperationCompletionBlock)completion;

+ (id<SUDOPGameTask>)preLoadGameWithDirectoryPath:(NSString *)directoryPath
                                          options:(SUDOPGamePackageOptions *)options
                                       completion:(nullable SUDOPGameOperationCompletionBlock)completion;

+ (id<SUDOPGameTask>)preLoadGameWithURL:(NSString *)url
                                options:(SUDOPGamePackageOptions *)options
                             completion:(nullable SUDOPGameOperationCompletionBlock)completion;


#pragma mark - Pre-start Operations

+ (id<SUDOPGameTask>)preStartGame:(NSString *)gameID
                       completion:(nullable SUDOPGameOperationCompletionBlock)completion;

+ (id<SUDOPGameTask>)preStartGameWithSignature:(NSString *)gameSignature
                                    completion:(nullable SUDOPGameOperationCompletionBlock)completion;

+ (id<SUDOPGameTask>)preStartGameWithPkgPath:(NSString *)pkgPath
                                     options:(SUDOPGamePackageOptions *)options
                                  completion:(nullable SUDOPGameOperationCompletionBlock)completion;

+ (id<SUDOPGameTask>)preStartGameWithDerectoryPath:(NSString *)directoryPath
                                           options:(SUDOPGamePackageOptions *)options
                                        completion:(nullable SUDOPGameOperationCompletionBlock)completion;

+ (id<SUDOPGameTask>)preStartGameWithURL:(NSString *)url
                                 options:(SUDOPGamePackageOptions *)options
                              completion:(nullable SUDOPGameOperationCompletionBlock)completion;

#pragma mark - Start Operations

+ (id<SUDOPGameTask>)startGame:(NSString *)gameID
            didGameViewCreated:(nullable SUDOPDidGameViewCreatedBlock)didGameViewCreated
          didGameHandleCreated:(nullable SUDOPDidGameHandleCreatedBlock)didGameHandleCreated
                      progress:(nullable SUDOPProgressBlock)progress
                    completion:(nullable SUDOPGameOperationCompletionBlock)completion;

/** Starts a game with the requested language. Nil or empty uses the system language for the loading name.
 The language is forwarded to the signature API; nil or empty uses its server default.
 An existing task for the same game is reused with its original language. */
+ (id<SUDOPGameTask>)startGame:(NSString *)gameID
                      language:(nullable NSString *)language
            didGameViewCreated:(nullable SUDOPDidGameViewCreatedBlock)didGameViewCreated
          didGameHandleCreated:(nullable SUDOPDidGameHandleCreatedBlock)didGameHandleCreated
                      progress:(nullable SUDOPProgressBlock)progress
                    completion:(nullable SUDOPGameOperationCompletionBlock)completion;

+ (id<SUDOPGameTask>)startGameWithSignature:(NSString *)gameSignature
                         didGameViewCreated:(nullable SUDOPDidGameViewCreatedBlock)didGameViewCreated
                       didGameHandleCreated:(nullable SUDOPDidGameHandleCreatedBlock)didGameHandleCreated
                                   progress:(nullable SUDOPProgressBlock)progress
                                 completion:(nullable SUDOPGameOperationCompletionBlock)completion;

+ (id<SUDOPGameTask>)startGameWithPkgPath:(NSString *)pkgPath
                                  options:(SUDOPGamePackageOptions *)options
                       didGameViewCreated:(nullable SUDOPDidGameViewCreatedBlock)didGameViewCreated
                     didGameHandleCreated:(nullable SUDOPDidGameHandleCreatedBlock)didGameHandleCreated
                                 progress:(nullable SUDOPProgressBlock)progress
                               completion:(nullable SUDOPGameOperationCompletionBlock)completion;

+ (id<SUDOPGameTask>)startGameWithDerectoryPath:(NSString *)directoryPath
                                        options:(SUDOPGamePackageOptions *)options
                             didGameViewCreated:(nullable SUDOPDidGameViewCreatedBlock)didGameViewCreated
                           didGameHandleCreated:(nullable SUDOPDidGameHandleCreatedBlock)didGameHandleCreated
                                       progress:(nullable SUDOPProgressBlock)progress
                                     completion:(nullable SUDOPGameOperationCompletionBlock)completion;

+ (id<SUDOPGameTask>)startGameWithURL:(NSString *)url
                              options:(SUDOPGamePackageOptions *)options
                   didGameViewCreated:(nullable SUDOPDidGameViewCreatedBlock)didGameViewCreated
                 didGameHandleCreated:(nullable SUDOPDidGameHandleCreatedBlock)didGameHandleCreated
                             progress:(nullable SUDOPProgressBlock)progress
                           completion:(nullable SUDOPGameOperationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
