//
//  SUDRuntime.h
//  SUDGI
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>
#import "ISUDLogger.h"
#import "SUDOPCommon.h"
#import "SUDOPWrappedClientDelegate.h"
#import "SUDOPGameTask.h"
#import "SUDRTLoadPackageParamModel.h"
#import "SUDRT.h"
#import "SUDRTGameMediaPlayerHandle.h"
#import "SUDRTGameAudioSession.h"

NS_ASSUME_NONNULL_BEGIN

/// SUDOP
@interface SUDOP : NSObject

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
 Retrieves game information asynchronously for the specified game ID.
 @param gameID The unique identifier of the game. Must not be nil.
 @param completion The completion block to be called when the request finishes.
        The block contains the retrieved game information object, or an error if the request failed.
        Called on the main thread.
 */
+ (void)getGameInformationWithGameID:(nonnull NSString *)gameID
                        completion:(nullable void(^)(SUDOPGameInformation *_Nullable gameInformation, NSError *_Nullable error))completion;

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
