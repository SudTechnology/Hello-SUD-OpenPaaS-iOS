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
    SUDOPGameSessionErrorCodeInvalidGameView = 2001,
    SUDOPGameSessionErrorCodeAlreadyStarting,
    SUDOPGameSessionErrorCodeAlreadyDestroyed,
    SUDOPGameSessionErrorCodeMissingWrappedClientHandler,
    SUDOPGameSessionErrorCodeStartFailed,
    SUDOPGameSessionErrorCodeDestroyedDuringStarting
};

@interface SUDOPGameSession ()

@property (nonatomic, copy, readwrite) NSString *sessionId;
@property (nonatomic, copy, readwrite) NSString *gameId;
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
    }
    return self;
}

- (BOOL)isRunning {
    return self.state == SUDOPGameSessionStateRunning;
}

- (void)startWithCompletion:(SUDOPGameSessionStartCompletion)completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.state == SUDOPGameSessionStateRunning) {
            if (completion) {
                completion(nil);
            }
            return;
        }
        
        if (self.state == SUDOPGameSessionStateStarting) {
            NSError *error = [self errorWithCode:SUDOPGameSessionErrorCodeAlreadyStarting
                                         message:@"游戏正在启动中"];
            if (completion) {
                completion(error);
            }
            return;
        }
        
        if (self.state == SUDOPGameSessionStateDestroyed) {
            NSError *error = [self errorWithCode:SUDOPGameSessionErrorCodeAlreadyDestroyed
                                         message:@"游戏实例已经销毁，不能启动"];
            if (completion) {
                completion(error);
            }
            return;
        }
        
        UIView *containerView = self.gameView;
        if (!containerView) {
            self.state = SUDOPGameSessionStateFailed;
            NSError *error = [self errorWithCode:SUDOPGameSessionErrorCodeInvalidGameView
                                         message:@"gameView 已释放或不存在"];
            if (completion) {
                completion(error);
            }
            return;
        }
        
        self.wrappedClientHandler = [self createWrappedClientHandler];
        if (!self.wrappedClientHandler) {
            self.state = SUDOPGameSessionStateFailed;
            NSError *error = [self errorWithCode:SUDOPGameSessionErrorCodeMissingWrappedClientHandler
                                         message:@"未设置 wrappedClientHandler 或 wrappedClientHandlerProvider"];
            if (completion) {
                completion(error);
            }
            return;
        }
        
        self.state = SUDOPGameSessionStateStarting;
        self.startCompletion = completion;
        self.startCompletionCalled = NO;
        self.wrappedClientRegistered = NO;
        
        __weak typeof(self) weakSelf = self;
        
        [SUDOP startGame:self.gameId
      didGameViewCreated:^(UIView * _Nonnull createdGameView) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) self = weakSelf;
                if (!self) {
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
                    
                    NSError *error = [self errorWithCode:SUDOPGameSessionErrorCodeInvalidGameView
                                                 message:@"gameView 已释放或不存在"];
                    [self finishStartWithError:error];
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
            
        } didGameHandleCreated:^(id<SUDRTGameHandle>  _Nonnull gameHandle) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) self = weakSelf;
                if (!self) {
                    return;
                }
                
                if (self.state == SUDOPGameSessionStateDestroyed ||
                    self.state == SUDOPGameSessionStateFailed) {
                    [gameHandle destroy];
                    return;
                }
                
                self.gameHandle = gameHandle;
                
                // gameHandle 创建后，绑定 wrappedClientHandler
                [self bindWrappedClientIfNeeded];
            });
            
        } progress:^(NSInteger progress) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) self = weakSelf;
                if (!self) {
                    return;
                }
                
                if (self.state != SUDOPGameSessionStateStarting) {
                    return;
                }
                
                NSLog(@"SUDOP game loading progress, gameId: %@, progress: %@", self.gameId, @(progress));
            });
            
        } completion:^(id<SUDOPGameHandleProvider>  _Nullable gameHandleProvider,
                       NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) self = weakSelf;
                if (!self) {
                    return;
                }
                
                if (self.state == SUDOPGameSessionStateDestroyed) {
                    NSError *destroyedError = [self errorWithCode:SUDOPGameSessionErrorCodeDestroyedDuringStarting
                                                          message:@"游戏启动过程中已被销毁"];
                    [self finishStartWithError:destroyedError];
                    return;
                }
                
                if (error) {
                    [self finishStartWithError:error];
                    return;
                }
                
                self.gameHandleProvider = gameHandleProvider;

                [self bindWrappedClientIfNeeded];
                
                [self finishStartWithError:nil];
            });
        }];
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
        
        BOOL wasStarting = self.state == SUDOPGameSessionStateStarting;
        
        self.state = SUDOPGameSessionStateDestroyed;
        
        [self cleanupGameResources];
        
        if (wasStarting) {
            NSError *error = [self errorWithCode:SUDOPGameSessionErrorCodeDestroyedDuringStarting
                                         message:@"游戏启动过程中被销毁"];
            [self callbackStartCompletionIfNeededWithError:error];
        }
    });
}

#pragma mark - Private

- (void)finishStartWithError:(NSError * _Nullable)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.startCompletionCalled) {
            return;
        }
        
        if (error) {
            if (self.state != SUDOPGameSessionStateDestroyed) {
                self.state = SUDOPGameSessionStateFailed;
            }
            
            [self cleanupGameResources];
            [self callbackStartCompletionIfNeededWithError:error];
            return;
        }
        
        if (self.state == SUDOPGameSessionStateDestroyed) {
            NSError *destroyedError = [self errorWithCode:SUDOPGameSessionErrorCodeDestroyedDuringStarting
                                                  message:@"游戏启动过程中已被销毁"];
            [self callbackStartCompletionIfNeededWithError:destroyedError];
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

- (void)cleanupGameResources {
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
        NSLocalizedDescriptionKey : message ?: @"未知错误"
    }];
}

@end
