
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDMAdmobData : NSObject

+(SUDMAdmobData *)sharedInstance;

@property (nonatomic,copy)NSString *userID;
@end

NS_ASSUME_NONNULL_END
