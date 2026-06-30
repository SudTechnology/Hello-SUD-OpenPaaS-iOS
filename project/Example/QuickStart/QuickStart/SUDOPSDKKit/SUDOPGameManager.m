//
//  SUDOPGameManager.m
//  HelloSud-iOS
//
//  Created by kaniel on 5/31/26.
//

#import "SUDOPGameManager.h"
#import "SUDGI/SUDGI-umbrella.h"
static NSString * const SUDOPGameManagerErrorDomain = @"com.sudop.game.manager";

typedef NS_ENUM(NSInteger, SUDOPGameManagerErrorCode) {
    SUDOPGameManagerErrorCodeInvalidParam = -10104,
};

typedef NS_ENUM(NSInteger, SUDOPGameStartType) {
    SUDOPGameManagerStartTypeGameId,
    SUDOPGameManagerStartTypeGameSignature,
};

@interface SUDOPGameManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, SUDOPGameSession *> *sessionMap;

/// SDK
@property (nonatomic, assign) BOOL sdkInitialized;

/// appId
@property (nonatomic, copy, nullable) NSString *initializedAppId;

@end

@implementation SUDOPGameManager

+ (instancetype)sharedManager {
    static SUDOPGameManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SUDOPGameManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)startGameWithIdentifier:(NSString *)identifier
                           type:(SUDOPGameStartType)type
                         config:(SUDOPGameConfig *)config
                       gameView:(UIView *)gameView
                     completion:(nullable SUDOPGameStartCompletion)completion {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSError *validateError = [self validateGameView:gameView
                                                 gameId:identifier
                                                 config:config];
        if (validateError) {
            if (completion) {
                completion(nil, validateError);
            }
            return;
        }
        
        [self obtainUserSignatureWithConfig:config
                                 completion:^(NSString * _Nullable userSignature, NSError * _Nullable error) {
            
            if (error) {
                if (completion) {
                    completion(nil, error);
                }
                return;
            }
            
            if (userSignature.length == 0) {
                NSError *signatureError = [self errorWithCode:SUDOPGameManagerErrorCodeInvalidParam
                                                      message:@"userSignature is empty"];
                if (completion) {
                    completion(nil, signatureError);
                }
                return;
            }
            
            [self initializeSDKIfNeededWithConfig:config
                                       completion:^(NSError * _Nullable error) {
                
                if (error) {
                    if (completion) {
                        completion(nil, error);
                    }
                    return;
                }
                
                [self authWithUserSignature:userSignature
                                 completion:^(NSError * _Nullable error) {
                    
                    if (error) {
                        if (completion) {
                            completion(nil, error);
                        }
                        return;
                    }
                    
                    SUDOPGameSession *session = nil;
                    
                    switch (type) {
                        case SUDOPGameManagerStartTypeGameId: {
                            session = [[SUDOPGameSession alloc] initWithGameView:gameView
                                                                          gameId:identifier
                                                                          config:config];
                        } break;
                            
                        case SUDOPGameManagerStartTypeGameSignature: {
                            session = [[SUDOPGameSession alloc] initWithGameView:gameView
                                                                   gameSignature:identifier
                                                                          config:config];
                        } break;
                    }
                    
                    self.sessionMap[session.sessionId] = session;
                    
                    [session startWithCompletion:^(NSError * _Nullable error) {
                        
                        if (error) {
                            [self.sessionMap removeObjectForKey:session.sessionId];
                            [session destroy];
                            
                            if (completion) {
                                completion(nil, error);
                            }
                            return;
                        }
                        
                        if (completion) {
                            completion(session, nil);
                        }
                    }];
                }];
            }];
        }];
    });
}

- (void)startGameWithGameId:(NSString *)gameId
                     config:(SUDOPGameConfig *)config
                   gameView:(UIView *)gameView
                 completion:(nullable SUDOPGameStartCompletion)completion {
    
    [self startGameWithIdentifier:gameId
                             type:SUDOPGameManagerStartTypeGameId
                           config:config
                         gameView:gameView
                       completion:completion];
}

- (void)startGameWithGameSignature:(NSString *)gameSignature
                            config:(SUDOPGameConfig *)config
                          gameView:(UIView *)gameView
                        completion:(nullable SUDOPGameStartCompletion)completion {
    
    [self startGameWithIdentifier:gameSignature
                             type:SUDOPGameManagerStartTypeGameSignature
                           config:config
                         gameView:gameView
                       completion:completion];
}


#pragma mark - UserSignature

- (void)obtainUserSignatureWithConfig:(SUDOPGameConfig *)config
                           completion:(SUDOPUserSignatureCompletion)completion {
  
    if (config.userSignature.length > 0) {
        if (completion) {
            completion(config.userSignature, nil);
        }
        return;
    }
  
    if (!config.userSignatureProvider) {
        NSError *error = [self errorWithCode:SUDOPGameManagerErrorCodeInvalidParam
                                     message:@"Neither userSignature nor userSignatureProvider is set"];
        if (completion) {
            completion(nil, error);
        }
        return;
    }
  
    config.userSignatureProvider(config.userId, ^(NSString * _Nullable userSignature, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(userSignature, error);
            }
        });
    });
}

#pragma mark - SDK Init

- (void)initializeSDKIfNeededWithConfig:(SUDOPGameConfig *)config
                             completion:(void(^)(NSError * _Nullable error))completion {
  
    if (self.sdkInitialized && [self.initializedAppId isEqualToString:config.appId]) {
        if (completion) {
            completion(nil);
        }
        return;
    }
  
  
    SUDOPSDKConfiguration *configuration = [[SUDOPSDKConfiguration alloc] init];
    configuration.appId = config.appId;
    configuration.appKey = config.appKey;
  
    [SUDOP initializeWithConfiguration:configuration completion:^(NSError * _Nullable error) {
        if (!error) {
            self.sdkInitialized = YES;
            self.initializedAppId = config.appId;
        }
      
        if (completion) {
            completion(error);
        }
    }];
}

#pragma mark - Auth

- (void)authWithUserSignature:(NSString *)userSignature
                   completion:(void(^)(NSError * _Nullable error))completion {
  
    [SUDOP authWithUserSignature:userSignature completion:^(NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

#pragma mark - Destroy

- (void)destroyGameWithSessionId:(NSString *)sessionId {
    if (sessionId.length == 0) {
        return;
    }
  
    dispatch_async(dispatch_get_main_queue(), ^{
        SUDOPGameSession *session = self.sessionMap[sessionId];
        if (!session) {
            return;
        }
      
        [session destroy];
        [self.sessionMap removeObjectForKey:sessionId];
    });
}

- (void)destroyGameWithSession:(SUDOPGameSession *)session {
    if (!session) {
        return;
    }
  
    [self destroyGameWithSessionId:session.sessionId];
}

- (void)destroyAllGames {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray<SUDOPGameSession *> *sessions = self.sessionMap.allValues;
        for (SUDOPGameSession *session in sessions) {
            [session destroy];
        }
        [self.sessionMap removeAllObjects];
    });
}

#pragma mark - Validate

- (NSError *)validateGameView:(UIView *)gameView
                       gameId:(NSString *)gameId
                       config:(SUDOPGameConfig *)config {
  
    if (!gameView) {
        return [self errorWithCode:SUDOPGameManagerErrorCodeInvalidParam
                           message:@"gameView cannot be empty"];
    }
  
    if (gameId.length == 0) {
        return [self errorWithCode:SUDOPGameManagerErrorCodeInvalidParam
                           message:@"gameId cannot be empty"];
    }
  
    if (config.appId.length == 0) {
        return [self errorWithCode:SUDOPGameManagerErrorCodeInvalidParam
                           message:@"appId cannot be empty"];
    }
  
    if (config.appKey.length == 0) {
        return [self errorWithCode:SUDOPGameManagerErrorCodeInvalidParam
                           message:@"appKey cannot be empty"];
    }
  
    if (config.userId.length == 0) {
        return [self errorWithCode:SUDOPGameManagerErrorCodeInvalidParam
                           message:@"userId cannot be empty"];
    }
  
    return nil;
}

- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:SUDOPGameManagerErrorDomain
                               code:code
                           userInfo:@{
        NSLocalizedDescriptionKey : message ?: @"Unknown error"
    }];
}

@end

