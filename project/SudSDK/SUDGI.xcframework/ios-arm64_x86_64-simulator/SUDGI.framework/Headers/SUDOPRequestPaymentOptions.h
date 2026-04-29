//
//  SUDOPRequestPaymentOptions.h
//  SUDGI
//
//  Created by kaniel on 4/18/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPRequestPaymentOptions : NSObject
@property(nonatomic, copy)NSString *sudTradeNo;
@property(nonatomic, copy)NSString *signData;
@property(nonatomic, copy)NSString *signature;
@end

NS_ASSUME_NONNULL_END
