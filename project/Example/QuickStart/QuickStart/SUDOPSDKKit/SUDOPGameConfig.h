//
//  SUDOPGameConfig.h
//  HelloSud-iOS
//
//  Created by kaniel on 5/31/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SUDGI/SUDGI-umbrella.h"

NS_ASSUME_NONNULL_BEGIN

@class SUDOPGameConfig;

typedef void(^SUDOPUserSignatureCompletion)(NSString * _Nullable userSignature,
                                            NSError * _Nullable error);

typedef void(^SUDOPUserSignatureProvider)(NSString *userId,
                                          SUDOPUserSignatureCompletion completion);

typedef id<SUDOPWrappedClientDelegate> _Nullable (^SUDOPWrappedClientHandlerProvider)(
    NSString *gameId,
    NSString *sessionId,
    SUDOPGameConfig *config
);

@interface SUDOPGameConfig : NSObject

/// SDK App ID.
@property (nonatomic, copy) NSString *appId;

/// SDK App Key.
@property (nonatomic, copy) NSString *appKey;

/// Current user ID.
@property (nonatomic, copy) NSString *userId;

/// The user signature.
/// If the business side already has a userSignature, it can be set directly.
@property (nonatomic, copy, nullable) NSString *userSignature;

/// Provider for asynchronously obtaining the user signature.
/// Use this provider if the userSignature needs to be fetched asynchronously.
@property (nonatomic, copy, nullable) SUDOPUserSignatureProvider userSignatureProvider;

/// Wrapped client handler for single-game scenarios.
/// In a single-game scenario, the handler can be passed directly.
@property (nonatomic, strong, nullable) id<SUDOPWrappedClientDelegate> wrappedClientHandler;

/// Wrapped client handler provider for multi-game scenarios.
/// Recommended for multi-game scenarios to create an independent handler for each session.
@property (nonatomic, copy, nullable) SUDOPWrappedClientHandlerProvider wrappedClientHandlerProvider;

@end

NS_ASSUME_NONNULL_END
