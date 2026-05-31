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

/// SDK AppId
@property (nonatomic, copy) NSString *appId;

/// SDK AppKey
@property (nonatomic, copy) NSString *appKey;

/// 当前用户 ID
@property (nonatomic, copy) NSString *userId;

/// 如果业务侧已经有 userSignature，可以直接设置
@property (nonatomic, copy, nullable) NSString *userSignature;

/// 如果需要异步获取 userSignature，通过这个 provider 获取
@property (nonatomic, copy, nullable) SUDOPUserSignatureProvider userSignatureProvider;

/// 单游戏场景可以直接传 handler
@property (nonatomic, strong, nullable) id<SUDOPWrappedClientDelegate> wrappedClientHandler;

/// 多游戏场景推荐使用 provider，为每个 session 创建独立 handler
@property (nonatomic, copy, nullable) SUDOPWrappedClientHandlerProvider wrappedClientHandlerProvider;

@end

NS_ASSUME_NONNULL_END
