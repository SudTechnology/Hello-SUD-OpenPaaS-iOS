//
//  SUDOPGameSession.m
//  HelloSud-iOS
//
//  Created by kaniel on 5/31/26.
//

#import "SUDOPGameSession.h"
#import "SUDOPGameConfig.h"
#import "SUDGI/SUDGI-umbrella.h"

static NSString * const SUDOPGameSessionErrorDomain = @"com.sudop.game.session";

typedef NS_ENUM(NSInteger, SUDOPGameSessionErrorCode) {
    /// 参数错误统一错误码
    SUDOPGameSessionErrorCodeInvalidParam = -10104
};

@interface SUDOPGameSession ()

@property (nonatomic, copy, readwrite) NSString *sessionId;
@property (nonatomic, copy, readwrite) NSString *gameId;
@property (nonatomic, copy, readwrite) NSString *gameSignature;
@property (nonatomic, strong, readwrite) SUDOPGameConfig *config;
@property (nonatomic, weak, readwrite) UIView *gameView;
@property (nonatomic, assign, readwrite) SUDOPGameSessionState state;

@property (nonatomic, strong) UIView *gameContentView;
@property (nonatomic, strong) id<SUDRTGameHandle> gameHandle;
@property (nonatomic, strong) id<SUDOPGameHandleProvider> gameHandleProvider;

@property (nonatomic, strong) id<SUDOPWrappedClientDelegate> wrappedClientHandler;
@property (nonatomic, assign) BOOL wrappedClientRegistered;

@property (nonatomic, copy) SUDOPGameSessionStartCompletion startCompletion;
@property (nonatomic, assign) BOOL startCompletionCalled;

/// 启动序列号，用于屏蔽重复 start 或 destroy 后的旧异步回调
@property (nonatomic, assign) NSUInteger startSequence;
@property (nonatomic, strong)id<SUDOPGameTask> gameTask;

@end

@implementation SUDOPGameSession

- (instancetype)initWithGameView:(UIView *)gameView
                          gameId:(NSString *)gameId
                          config:(SUDOPGameConfig *)config {
    self = [super init];
    if (self) {
        _sessionId = [[NSUUID UUID] UUIDString];
        _gameView = gameView;
        _gameId = [gameId copy];
        _config = config;
        _state = SUDOPGameSessionStateIdle;
        _startSequence = 0;
    }
    return self;
}

- (instancetype)initWithGameView:(UIView *)gameView
                   gameSignature:(NSString *)gameSignature
                          config:(SUDOPGameConfig *)config {
    self = [super init];
    if (self) {
        _sessionId = [[NSUUID UUID] UUIDString];
        _gameView = gameView;
        _gameSignature = [gameSignature copy];
        _config = config;
        _state = SUDOPGameSessionStateIdle;
        _startSequence = 0;
    }
    return self;
}

- (BOOL)isRunning {
    return self.state == SUDOPGameSessionStateRunning;
}

- (void)startWithCompletion:(SUDOPGameSessionStartCompletion)completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIView *containerView = self.gameView;
        if (!containerView) {
            self.state = SUDOPGameSessionStateFailed;
            NSError *error = [self errorWithCode:SUDOPGameSessionErrorCodeInvalidParam
                                         message:@"Invalid param: gameView has been released or does not exist"];
            if (completion) {
                completion(error);
            }
            return;
        }
        
        BOOL hasGameSignature = self.gameSignature.length > 0;
        BOOL hasGameId = self.gameId.length > 0;
        
        if (!hasGameSignature && !hasGameId) {
            self.state = SUDOPGameSessionStateFailed;
            NSError *error = [self errorWithCode:SUDOPGameSessionErrorCodeInvalidParam
                                         message:@"Invalid param: gameId and gameSignature cannot both be empty"];
            if (completion) {
                completion(error);
            }
            return;
        }
        
        if (!self.config) {
            self.state = SUDOPGameSessionStateFailed;
            NSError *error = [self errorWithCode:SUDOPGameSessionErrorCodeInvalidParam
                                         message:@"Invalid param: config is nil"];
            if (completion) {
                completion(error);
            }
            return;
        }
        
        id<SUDOPWrappedClientDelegate> wrappedClientHandler = [self createWrappedClientHandler];
        if (!wrappedClientHandler) {
            self.state = SUDOPGameSessionStateFailed;
            NSError *error = [self errorWithCode:SUDOPGameSessionErrorCodeInvalidParam
                                         message:@"Invalid param: wrappedClientHandler or wrappedClientHandlerProvider is not set"];
            if (completion) {
                completion(error);
            }
            return;
        }
        
        /*
         重复 start 直接重新执行：
         1. 递增 startSequence，让旧的异步回调失效
         2. 丢弃旧 startCompletion，不回调错误
         3. 清理旧游戏资源
         4. 重新发起启动
         */
        self.startSequence += 1;
        NSUInteger currentStartSequence = self.startSequence;
        
        [self discardStartCompletionWithoutCallback];
        [self cleanupGameResources];
        
        self.state = SUDOPGameSessionStateStarting;
        self.startCompletion = completion;
        self.startCompletionCalled = NO;
        self.wrappedClientHandler = wrappedClientHandler;
        self.wrappedClientRegistered = NO;
        
        __weak typeof(self) weakSelf = self;
        
        SUDOPDidGameViewCreatedBlock didGameViewCreated = ^(UIView * _Nonnull createdGameView) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) self = weakSelf;
                if (!self) {
                    [createdGameView removeFromSuperview];
                    return;
                }
                
                if (self.startSequence != currentStartSequence) {
                    [createdGameView removeFromSuperview];
                    return;
                }
                
                if (self.state == SUDOPGameSessionStateDestroyed ||
                    self.state == SUDOPGameSessionStateFailed) {
                    [createdGameView removeFromSuperview];
                    return;
                }
                
                UIView *containerView = self.gameView;
                if (!containerView) {
                    [createdGameView removeFromSuperview];
                    
                    NSError *error = [self errorWithCode:SUDOPGameSessionErrorCodeInvalidParam
                                                 message:@"Invalid param: gameView has been released or does not exist"];
                    [self finishStartWithError:error forSequence:currentStartSequence];
                    return;
                }
                
                self.gameContentView = createdGameView;
                createdGameView.translatesAutoresizingMaskIntoConstraints = NO;
                [containerView addSubview:createdGameView];
                
                [NSLayoutConstraint activateConstraints:@[
                    [createdGameView.topAnchor constraintEqualToAnchor:containerView.topAnchor],
                    [createdGameView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
                    [createdGameView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor],
                    [createdGameView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor]
                ]];
            });
        };
        
        SUDOPDidGameHandleCreatedBlock didGameHandleCreated = ^(id<SUDRTGameHandle>  _Nonnull gameHandle, SUDOPGameInfo *_Nonnull gameInfo) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) self = weakSelf;
                if (!self) {
                    [gameHandle destroy];
                    return;
                }
                
                if (self.startSequence != currentStartSequence) {
                    [gameHandle destroy];
                    return;
                }
                
                if (self.state == SUDOPGameSessionStateDestroyed ||
                    self.state == SUDOPGameSessionStateFailed) {
                    [gameHandle destroy];
                    return;
                }
                
                self.gameHandle = gameHandle;
                
                // Bind the wrappedClientHandler after the gameHandle is created.
                [self bindWrappedClientIfNeeded];
                if (self.config.gameDeviceOrientationUpdated) {
                    self.config.gameDeviceOrientationUpdated(gameInfo);
                }
            });
        };
        
        void (^progressBlock)(NSInteger progress) = ^(NSInteger progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) self = weakSelf;
                if (!self) {
                    return;
                }
                
                if (self.startSequence != currentStartSequence) {
                    return;
                }
                
                if (self.state != SUDOPGameSessionStateStarting) {
                    return;
                }
                
                NSLog(@"SUDOP game loading progress, gameId: %@, gameSignature: %@, progress: %@",
                      self.gameId,
                      self.gameSignature.length > 0 ? @"YES" : @"NO",
                      @(progress));
            });
        };
        
        SUDOPGameOperationCompletionBlock completionBlock = ^(id<SUDOPGameHandleProvider>  _Nullable gameHandleProvider,
                                                              NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) self = weakSelf;
                if (!self) {
                    return;
                }
                
                if (self.startSequence != currentStartSequence) {
                    return;
                }
                
                /*
                 主动 destroy 后，不再回调 startCompletion 错误。
                 这里直接忽略 SDK 后续启动结果。
                 */
                if (self.state == SUDOPGameSessionStateDestroyed) {
                    return;
                }
                
                if (error) {
                    [self finishStartWithError:error forSequence:currentStartSequence];
                    return;
                }
                
                self.gameHandleProvider = gameHandleProvider;
                
                [self bindWrappedClientIfNeeded];
                
                [self finishStartWithError:nil forSequence:currentStartSequence];
            });
        };
        
        if (hasGameSignature) {
            self.gameTask = [SUDOP startGameWithSignature:self.gameSignature
                       didGameViewCreated:didGameViewCreated
                     didGameHandleCreated:didGameHandleCreated
                                 progress:progressBlock
                               completion:completionBlock];
        } else {
            self.gameTask = [SUDOP startGame:self.gameId
          didGameViewCreated:didGameViewCreated
        didGameHandleCreated:didGameHandleCreated
                    progress:progressBlock
                  completion:completionBlock];
        }
    });
}

#pragma mark - Wrapped Client

- (id<SUDOPWrappedClientDelegate>)createWrappedClientHandler {
    if (self.config.wrappedClientHandlerProvider) {
        return self.config.wrappedClientHandlerProvider(self.gameId, self.sessionId, self.config);
    }
    
    return self.config.wrappedClientHandler;
}

- (void)bindWrappedClientIfNeeded {
    if (self.wrappedClientRegistered) {
        return;
    }
    
    if (!self.gameHandle || !self.wrappedClientHandler) {
        return;
    }
    
    [self.gameHandle setGameQueryPermissionListener:(id)self.wrappedClientHandler];
    [self.gameHandle setGameQuerySystemPermissionListener:(id)self.wrappedClientHandler];
    
    [SUDOP registerWrappedClientWithGameHandle:self.gameHandle
                                clientDelegate:self.wrappedClientHandler];
    
    self.wrappedClientRegistered = YES;
}

#pragma mark - Destroy

- (void)destroy {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.state == SUDOPGameSessionStateDestroyed) {
            return;
        }
        
        /*
         主动 destroy：
         1. 递增 startSequence，让未完成的 SDK 异步回调失效
         2. 清理游戏资源
         3. 丢弃 startCompletion，不回调错误
         */
        self.startSequence += 1;
        self.state = SUDOPGameSessionStateDestroyed;
        
        [self cleanupGameResources];
        [self discardStartCompletionWithoutCallback];
    });
}

#pragma mark - Private

- (void)finishStartWithError:(NSError * _Nullable)error
                 forSequence:(NSUInteger)sequence {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.startSequence != sequence) {
            return;
        }
        
        if (self.startCompletionCalled) {
            return;
        }
        
        /*
         主动 destroy 后，不再回调 startCompletion。
         */
        if (self.state == SUDOPGameSessionStateDestroyed) {
            [self discardStartCompletionWithoutCallback];
            return;
        }
        
        if (error) {
            self.state = SUDOPGameSessionStateFailed;
            
            [self cleanupGameResources];
            [self callbackStartCompletionIfNeededWithError:error];
            return;
        }
        
        self.state = SUDOPGameSessionStateRunning;
        [self callbackStartCompletionIfNeededWithError:nil];
    });
}

- (void)callbackStartCompletionIfNeededWithError:(NSError * _Nullable)error {
    if (self.startCompletionCalled) {
        return;
    }
    
    self.startCompletionCalled = YES;
    
    SUDOPGameSessionStartCompletion completion = self.startCompletion;
    self.startCompletion = nil;
    
    if (completion) {
        completion(error);
    }
}

- (void)discardStartCompletionWithoutCallback {
    if (self.startCompletionCalled) {
        return;
    }
    
    self.startCompletionCalled = YES;
    self.startCompletion = nil;
}

- (void)cleanupGameResources {
    if (self.gameTask) {
        [self.gameTask destroy];
        self.gameTask = nil;
    }
    if (self.gameHandle) {
        [self.gameHandle destroy];
        self.gameHandle = nil;
    }
    
    if (self.gameContentView) {
        [self.gameContentView removeFromSuperview];
        self.gameContentView = nil;
    }
    
    self.gameHandleProvider = nil;
    self.wrappedClientHandler = nil;
    self.wrappedClientRegistered = NO;
}

- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:SUDOPGameSessionErrorDomain
                               code:code
                           userInfo:@{
        NSLocalizedDescriptionKey : message ?: @"Unknown error"
    }];
}

@end
