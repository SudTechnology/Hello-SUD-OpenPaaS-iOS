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
                        completion:(nullable SUDOPCompletion)completion;

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
                   completion:(nullable SUDOPCompletion)completion;

/**
 Request a game signature from the server using the specified game ID.
 @param gameID The unique identifier of the game.
 @param completion Called when the signature request finishes.
 */
+ (void)getGameSignatureWithGameID:(nonnull NSString *)gameID
                        completion:(nullable void(^)(NSString *_Nullable gameSignature, NSError *_Nullable error))completion;

#pragma mark - Pre-download Operations

+ (id<SUDOPGameTask>)preDownloadGame:(nonnull NSString *)gameID
                          completion:(nullable SUDOPCompletion)completion;

+ (id<SUDOPGameTask>)preDownloadGameWithSignature:(nonnull NSString *)gameSignature
                                       completion:(nullable SUDOPCompletion)completion;

+ (id<SUDOPGameTask>)preDownloadGameWithURL:(NSString *)url
                                    options:(nullable SUDOPGamePackageOptions *)options
                                 completion:(nullable SUDOPCompletion)completion;

#pragma mark - Preload Operations

+ (id<SUDOPGameTask>)preLoadGame:(NSString *)gameID
                      completion:(nullable SUDOPGameOperationCompletion)completion;

+ (id<SUDOPGameTask>)preLoadGameWithSignature:(NSString *)gameSignature
                                   completion:(nullable SUDOPGameOperationCompletion)completion;

+ (id<SUDOPGameTask>)preLoadGameWithPkgPath:(NSString *)pkgPath
                                    options:(SUDOPGamePackageOptions *)options
                                 completion:(nullable SUDOPGameOperationCompletion)completion;

+ (id<SUDOPGameTask>)preLoadGameWithDirectoryPath:(NSString *)directoryPath
                                          options:(SUDOPGamePackageOptions *)options
                                       completion:(nullable SUDOPGameOperationCompletion)completion;

+ (id<SUDOPGameTask>)preLoadGameWithURL:(NSString *)url
                                options:(SUDOPGamePackageOptions *)options
                             completion:(nullable SUDOPGameOperationCompletion)completion;


#pragma mark - Pre-start Operations

+ (id<SUDOPGameTask>)preStartGame:(NSString *)gameID
                       completion:(nullable SUDOPGameOperationCompletion)completion;

+ (id<SUDOPGameTask>)preStartGameWithSignature:(NSString *)gameSignature
                                    completion:(nullable SUDOPGameOperationCompletion)completion;

+ (id<SUDOPGameTask>)preStartGameWithPkgPath:(NSString *)pkgPath
                                     options:(SUDOPGamePackageOptions *)options
                                  completion:(nullable SUDOPGameOperationCompletion)completion;

+ (id<SUDOPGameTask>)preStartGameWithDerectoryPath:(NSString *)directoryPath
                                           options:(SUDOPGamePackageOptions *)options
                                        completion:(nullable SUDOPGameOperationCompletion)completion;

+ (id<SUDOPGameTask>)preStartGameWithURL:(NSString *)url
                                 options:(SUDOPGamePackageOptions *)options
                              completion:(nullable SUDOPGameOperationCompletion)completion;

#pragma mark - Start Operations

+ (id<SUDOPGameTask>)startGame:(NSString *)gameID
          didGameHandleCreated:(nullable SUDOPDidGameHandleCreated)didGameHandleCreated
                    completion:(nullable SUDOPGameOperationCompletion)completion;

+ (id<SUDOPGameTask>)startGameWithSignature:(NSString *)gameSignature
                       didGameHandleCreated:(nullable SUDOPDidGameHandleCreated)didGameHandleCreated
                                 completion:(nullable SUDOPGameOperationCompletion)completion;

+ (id<SUDOPGameTask>)startGameWithPkgPath:(NSString *)pkgPath
                                  options:(SUDOPGamePackageOptions *)options
                     didGameHandleCreated:(nullable SUDOPDidGameHandleCreated)didGameHandleCreated
                               completion:(nullable SUDOPGameOperationCompletion)completion;

+ (id<SUDOPGameTask>)startGameWithDerectoryPath:(NSString *)directoryPath
                                        options:(SUDOPGamePackageOptions *)options
                           didGameHandleCreated:(nullable SUDOPDidGameHandleCreated)didGameHandleCreated
                                     completion:(nullable SUDOPGameOperationCompletion)completion;

+ (id<SUDOPGameTask>)startGameWithURL:(NSString *)url
                              options:(SUDOPGamePackageOptions *)options
                 didGameHandleCreated:(nullable SUDOPDidGameHandleCreated)didGameHandleCreated
                           completion:(nullable SUDOPGameOperationCompletion)completion;

@end

NS_ASSUME_NONNULL_END
