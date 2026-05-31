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
/// 游戏启动会话
@interface SUDOPGameSession : NSObject

@property (nonatomic, copy, readonly) NSString *sessionId;
@property (nonatomic, copy, readonly) NSString *gameId;
@property (nonatomic, strong, readonly) SUDOPGameConfig *config;
@property (nonatomic, weak, readonly) UIView *gameView;
@property (nonatomic, assign, readonly) SUDOPGameSessionState state;

@property (nonatomic, assign, readonly, getter=isRunning) BOOL running;

- (instancetype)initWithGameView:(UIView *)gameView
                          gameId:(NSString *)gameId
                          config:(SUDOPGameConfig *)config;

/// 异步启动游戏
- (void)startWithCompletion:(nullable SUDOPGameSessionStartCompletion)completion;

/// 销毁游戏
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
