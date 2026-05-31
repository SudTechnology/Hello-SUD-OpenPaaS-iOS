//
//  SUDOPWCKLanguageHelper.h
//  SUDGI
//
//  Created by kaniel on 5/28/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDOPWCKLanguageHelper : NSObject

/// 根据当前系统语言，从多语言字典中取值
+ (NSString *)localizedStringFromDictionary:(NSDictionary<NSString *, NSString *> *)languageMap;

/// 根据指定语言，从多语言字典中取值
+ (NSString *)localizedStringFromDictionary:(NSDictionary<NSString *, NSString *> *)languageMap
                                   language:(nullable NSString *)language;

@end

NS_ASSUME_NONNULL_END
