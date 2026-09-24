//
//  SudAsrManager.h
//  SudAsr
//
//  Created by kaniel on 5/9/25.
//

#import <Foundation/Foundation.h>
#import "ISudAsrClient.h"
NS_ASSUME_NONNULL_BEGIN

@interface SudAsrManager : NSObject

/// 返回当前版本号
- (NSString *)version;

/// 返回当前版本号别名
- (NSString *)versionAlis;

- (BOOL)supportAsr:(NSInteger)clientType;

/// 创建ASR客户端
/// - Parameter clientType: 客户端类型
- (id<ISudAsrClient>)createAsrClient:(NSInteger)clientType errorBlock:(void(^)(NSInteger code, NSString *msg))errorBlock;
@end

NS_ASSUME_NONNULL_END
