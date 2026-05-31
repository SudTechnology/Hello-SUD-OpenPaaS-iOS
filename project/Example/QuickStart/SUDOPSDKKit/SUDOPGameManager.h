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
/// SUDOP游戏管理模块,提供便捷调用SDK接口及管理启动游戏
@interface SUDOPGameManager : NSObject

+ (instancetype)sharedManager;

- (void)startGameWithGameId:(NSString *)gameId
                     config:(SUDOPGameConfig *)config
                   gameView:(UIView *)gameView
                   completion:(nullable SUDOPGameStartCompletion)completion;

- (void)destroyGameWithSessionId:(NSString *)sessionId;

- (void)destroyGameWithSession:(SUDOPGameSession *)session;

- (void)destroyAllGames;

@end

NS_ASSUME_NONNULL_END
