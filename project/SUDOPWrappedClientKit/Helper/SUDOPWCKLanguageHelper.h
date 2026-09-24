//
//  SUDOPWCKLanguageHelper.h
//  SUDGI
//
//  Created by kaniel on 5/28/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSNotificationName const SUDOPWCKLanguageDidChangeNotification;

@interface SUDOPWCKLanguageHelper : NSObject

/// Sets the language used by the Kit. Nil, an empty string, or an unsupported value selects the default language, en.
+ (void)setPreferredLanguage:(nullable NSString *)language;

/// Returns the language identifier actually selected from the resource bundle. Defaults to the system language.
+ (NSString *)currentLanguage;

/// Returns a localized string from SUDOPWrappedClientKit.strings.
+ (NSString *)localizedStringForKey:(NSString *)key
                       defaultValue:(nullable NSString *)defaultValue;

/// Returns a localized string from the specified strings table.
+ (NSString *)localizedStringForKey:(NSString *)key
                              table:(NSString *)table
                       defaultValue:(nullable NSString *)defaultValue;

/// Looks up the Kit's current language using BCP 47 parent fallback, then falls back to the default entry.
+ (NSString *)localizedStringFromDictionary:(NSDictionary<NSString *, NSString *> *)languageMap;

/// Looks up the specified language using BCP 47 parent fallback, then falls back to the default entry.
/// For example, zh-Hans-CN falls back to zh-Hans, then zh, then default.
+ (NSString *)localizedStringFromDictionary:(NSDictionary<NSString *, NSString *> *)languageMap
                                   language:(nullable NSString *)language;

@end

NS_ASSUME_NONNULL_END
