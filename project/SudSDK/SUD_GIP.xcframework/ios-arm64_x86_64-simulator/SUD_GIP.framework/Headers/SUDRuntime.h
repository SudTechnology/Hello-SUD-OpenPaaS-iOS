//
//  SUDRuntime.h
//  SUD_GIP
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>
#import "ISUDLogger.h"
#import "SUDRuntimeInitSDKParamModel.h"
#import "SUDRuntimeLoadPackageParamModel.h"
#import "SUDRuntimeGameRuntime.h"
#import "SUDRuntimeGameMediaPlayerHandle.h"
#import "SUDRuntimeGameAudioSession.h"
NS_ASSUME_NONNULL_BEGIN


/// Game SUDRuntime
@interface SUDRuntime : NSObject

/// Initialize the SDK
/// - Parameter paramModel: Required parameters
/// - Parameter completion: completion description
+(void)initSDK:(SUDRuntimeInitSDKParamModel *)paramModel
    completion:(nullable void(^)(NSError *_Nullable error))completion;

/// Create a runtime instance (single process has only one)
/// @param options Optional configuration parameters for the runtime
/// @param completion Completion callback
+(void)createRuntime:(NSDictionary *_Nullable)options
          completion:(nullable void(^)(id<SUDRuntimeGameRuntime> _Nullable runtime, NSError *_Nullable error))completion;

/// Reset the initialized SDK, called when SDK re-initialization is needed
+(void)uninitSDK;
@end

NS_ASSUME_NONNULL_END
