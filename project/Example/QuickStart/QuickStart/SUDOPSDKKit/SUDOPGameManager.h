//
//  SUDOPGameManager.h
//  HelloSud-iOS
//
//  Created by kaniel on 5/31/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SUDOPGameConfig.h"
#import "SUDOPGameSession.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SUDOPGameStartCompletion)(SUDOPGameSession * _Nullable session,
                                        NSError * _Nullable error);

/// SUDOP game management module.
/// Provides convenient APIs for calling the SDK and managing game startup.
@interface SUDOPGameManager : NSObject

/// Returns the shared game manager instance.
+ (instancetype)sharedManager;

/// Starts a game with the specified game ID, configuration, and game view.
///
/// @param gameId The ID of the game to start.
/// @param config The game configuration.
/// @param gameView The view used to display the game.
/// @param completion The completion callback invoked after the game starts, returning a game session or an error.
- (void)startGameWithGameId:(NSString *)gameId
                     config:(SUDOPGameConfig *)config
                   gameView:(UIView *)gameView
                 completion:(nullable SUDOPGameStartCompletion)completion;

/// Starts a game with the specified game signature, configuration, and game view.
///
/// @param gameSignature The signature of the game to start.
/// @param config The game configuration.
/// @param gameView The view used to display the game.
/// @param completion The completion callback invoked after the game starts, returning a game session or an error.
- (void)startGameWithGameSignature:(NSString *)gameSignature
                            config:(SUDOPGameConfig *)config
                          gameView:(UIView *)gameView
                        completion:(nullable SUDOPGameStartCompletion)completion;

/// Destroys the game associated with the specified session ID.
///
/// @param sessionId The ID of the game session to destroy.
- (void)destroyGameWithSessionId:(NSString *)sessionId;

/// Destroys the game associated with the specified session.
///
/// @param session The game session to destroy.
- (void)destroyGameWithSession:(SUDOPGameSession *)session;

/// Destroys all running games.
- (void)destroyAllGames;

@end

NS_ASSUME_NONNULL_END
