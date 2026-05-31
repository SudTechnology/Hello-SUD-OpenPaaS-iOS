//
//  SUDOPWCKCommon.h
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/13/26.
//

#import <Foundation/Foundation.h>
#import "MJExtension/MJExtension-umbrella.h"
#import "SUDGI/SUDGI-umbrella.h"
NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKCommon : NSObject
+ (NSError *)errorWithCode:(NSInteger)code msg:(NSString *)msg;
+(UIImage *)imageWithName:(NSString *)name;
+(CGFloat)pointFromPx:(CGFloat)px;
+(CGFloat)pxFromPoint:(CGFloat)point;
@end

NS_ASSUME_NONNULL_END
