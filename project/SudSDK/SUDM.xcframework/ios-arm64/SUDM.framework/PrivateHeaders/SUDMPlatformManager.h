

#import <Foundation/Foundation.h>
#import "SUDM.h"
#import "SUDMBaseAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUDMPlatformManager : NSObject

+ (BOOL)isPlatformAdapterAvailable:(NSString *)className;
+ (nullable SUDMBaseAdapter *)getPlatformAdapter:(NSString *)className;
@end

NS_ASSUME_NONNULL_END
