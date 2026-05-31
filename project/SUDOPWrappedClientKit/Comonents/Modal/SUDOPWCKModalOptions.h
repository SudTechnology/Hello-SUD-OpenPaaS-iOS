//
//  SUDOPWCKModalOptions.h
//  AFNetworking
//
//  Created by kaniel on 5/25/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKModalOptions : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, assign) BOOL showCancel;
@property(nonatomic, strong) NSString *cancelText;
@property(nonatomic, strong) NSString *cancelColor;
@property(nonatomic, strong) NSString *confirmText;
@property(nonatomic, strong) NSString *confirmColor;
@property(nonatomic, assign) BOOL editable;
@property(nonatomic, strong) NSString *placeholderText;
@property(nonatomic, assign) BOOL maskClosable;

@end

NS_ASSUME_NONNULL_END



