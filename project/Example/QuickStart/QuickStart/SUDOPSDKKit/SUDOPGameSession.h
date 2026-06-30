//
//  SUDOPGameSession.h
//  HelloSud-iOS
//
//  Created by kaniel on 5/31/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SUDOPGameConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SUDOPGameSessionState) {
    SUDOPGameSessionStateIdle = 0,
    SUDOPGameSessionStateStarting,
    SUDOPGameSessionStateRunning,
    SUDOPGameSessionStateFailed,
    SUDOPGameSessionStateDestroyed
};

typedef void(^SUDOPGameSessionStartCompletion)(NSError * _Nullable error);
/// Game startup session.
@interface SUDOPGameSession : NSObject

/// The unique ID of the game session.
@property (nonatomic, copy, readonly) NSString *sessionId;

/// The game ID.
@property (nonatomic, copy, readonly) NSString *gameId;

/// The game configuration.
@property (nonatomic, strong, readonly) SUDOPGameConfig *config;

/// The view used to display the game.
@property (nonatomic, weak, readonly) UIView *gameView;

/// The current state of the game session.
@property (nonatomic, assign, readonly) SUDOPGameSessionState state;

/// Indicates whether the game session is currently running.
@property (nonatomic, assign, readonly, getter=isRunning) BOOL running;

/// Initializes a game session with the specified game view, game ID, and configuration.
///
/// @param gameView The view used to display the game.
/// @param gameId The ID of the game.
/// @param config The game configuration.
- (instancetype)initWithGameView:(UIView *)gameView
                          gameId:(NSString *)gameId
                          config:(SUDOPGameConfig *)config;

- (instancetype)initWithGameView:(UIView *)gameView
                   gameSignature:(NSString *)gameSignature
                          config:(SUDOPGameConfig *)config;

/// Starts the game asynchronously.
///
/// @param completion The completion callback invoked after the game starts.
- (void)startWithCompletion:(nullable SUDOPGameSessionStartCompletion)completion;

/// Destroys the game.
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
