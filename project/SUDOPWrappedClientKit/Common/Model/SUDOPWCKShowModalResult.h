//
//  SUDOPWCKShowModalResult.h
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/26/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKShowModalResult : NSObject
@property(nonatomic, strong)NSString *content;
@property(nonatomic, assign)BOOL confirm;
@property(nonatomic, assign)BOOL cancel;
@end

NS_ASSUME_NONNULL_END
