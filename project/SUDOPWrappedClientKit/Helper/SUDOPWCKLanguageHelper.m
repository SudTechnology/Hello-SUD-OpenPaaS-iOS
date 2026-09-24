//
//  SUDOPWCKLanguageHelper.m
//  SUDGI
//
//  Created by kaniel on 5/28/26.
//

#import "SUDOPWCKLanguageHelper.h"
#import "SUDOPWCKCommon.h"

NSNotificationName const SUDOPWCKLanguageDidChangeNotification = @"SUDOPWCKLanguageDidChangeNotification";

static NSString * const SUDOPWCKDefaultLanguage = @"en";
static NSString * const SUDOPWCKDefaultStringsTable = @"SUDOPWrappedClientKit";
static NSString *SUDOPWCKCurrentLanguage = nil;
static NSMutableDictionary<NSString *, NSBundle *> *SUDOPWCKLanguageBundleCache = nil;

@interface SUDOPWCKLanguageHelper ()

+ (nullable NSString *)matchedLanguageForLanguage:(nullable NSString *)language;
+ (NSString *)defaultLanguage;
+ (nullable NSBundle *)languageBundleForLanguage:(nullable NSString *)language;
+ (nullable NSString *)localizedStringForKey:(NSString *)key
                                        table:(NSString *)table
                                     language:(NSString *)language;
+ (nullable NSString *)localizedValueFromDictionary:(NSDictionary<NSString *, NSString *> *)languageMap
                                            language:(NSString *)language;

@end

@implementation SUDOPWCKLanguageHelper

+ (void)setPreferredLanguage:(NSString *)language {
    NSString *requestedLanguage = nil;
    if ([language isKindOfClass:[NSString class]] && language.length > 0) {
        requestedLanguage = [language copy];
    }

    NSString *matchedLanguage = [self matchedLanguageForLanguage:requestedLanguage]
        ?: SUDOPWCKDefaultLanguage;

    __block BOOL didChange = NO;
    @synchronized (self) {
        NSString *oldLanguage = SUDOPWCKCurrentLanguage ?: [self defaultLanguage];
        didChange = ![oldLanguage isEqualToString:matchedLanguage];
        SUDOPWCKCurrentLanguage = [matchedLanguage copy];
        [SUDOPWCKLanguageBundleCache removeAllObjects];
    }

    if (!didChange) {
        return;
    }

    void (^postNotification)(void) = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SUDOPWCKLanguageDidChangeNotification
                                                            object:nil
                                                          userInfo:@{@"language" : matchedLanguage}];
    };
    if ([NSThread isMainThread]) {
        postNotification();
    } else {
        dispatch_async(dispatch_get_main_queue(), postNotification);
    }
}

+ (NSString *)currentLanguage {
    @synchronized (self) {
        if (!SUDOPWCKCurrentLanguage) {
            SUDOPWCKCurrentLanguage = [[self defaultLanguage] copy];
        }
        return [SUDOPWCKCurrentLanguage copy];
    }
}

+ (NSString *)localizedStringForKey:(NSString *)key
                       defaultValue:(NSString *)defaultValue {
    return [self localizedStringForKey:key
                                 table:SUDOPWCKDefaultStringsTable
                          defaultValue:defaultValue];
}

+ (NSString *)localizedStringForKey:(NSString *)key
                              table:(NSString *)table
                       defaultValue:(NSString *)defaultValue {
    if (![key isKindOfClass:[NSString class]] || key.length == 0) {
        return defaultValue ?: @"";
    }

    NSString *tableName = ([table isKindOfClass:[NSString class]] && table.length > 0)
        ? table
        : SUDOPWCKDefaultStringsTable;
    NSString *language = [self currentLanguage];
    NSString *localizedValue = [self localizedStringForKey:key
                                                     table:tableName
                                                  language:language];
    if (localizedValue) {
        return localizedValue;
    }

    if (![language isEqualToString:SUDOPWCKDefaultLanguage]) {
        localizedValue = [self localizedStringForKey:key
                                               table:tableName
                                            language:SUDOPWCKDefaultLanguage];
        if (localizedValue) {
            return localizedValue;
        }
    }

    if (defaultValue) {
        return defaultValue;
    }
    return key;
}

+ (NSString *)localizedStringFromDictionary:(NSDictionary<NSString *,NSString *> *)languageMap {
    return [self localizedStringFromDictionary:languageMap language:[self currentLanguage]];
}

+ (NSString *)localizedStringFromDictionary:(NSDictionary<NSString *,NSString *> *)languageMap
                                   language:(NSString *)language {
    if (![languageMap isKindOfClass:[NSDictionary class]] || languageMap.count == 0) {
        return @"";
    }
    
    NSString *matchedLanguage = ([language isKindOfClass:[NSString class]] && language.length > 0)
        ? language
        : [self currentLanguage];
    NSString *localizedValue = [self localizedValueFromDictionary:languageMap language:matchedLanguage];
    if (localizedValue.length > 0) {
        return localizedValue;
    }

    NSString *defaultValue = languageMap[@"default"];
    if ([defaultValue isKindOfClass:[NSString class]] && defaultValue.length > 0) {
        return defaultValue;
    }

    return @"";
}

#pragma mark - Private

+ (nullable NSString *)localizedValueFromDictionary:(NSDictionary<NSString *, NSString *> *)languageMap
                                            language:(NSString *)language {
    NSString *candidate = [language stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    while (candidate.length > 0) {
        NSString *value = languageMap[candidate];
        if ([value isKindOfClass:[NSString class]] && value.length > 0) {
            return value;
        }

        for (NSString *key in languageMap) {
            if ([key caseInsensitiveCompare:candidate] != NSOrderedSame) {
                continue;
            }
            value = languageMap[key];
            if ([value isKindOfClass:[NSString class]] && value.length > 0) {
                return value;
            }
        }

        NSRange separatorRange = [candidate rangeOfString:@"-" options:NSBackwardsSearch];
        if (separatorRange.location == NSNotFound) {
            break;
        }
        candidate = [candidate substringToIndex:separatorRange.location];
    }
    return nil;
}

+ (NSString *)defaultLanguage {
    NSString *systemLanguage = NSLocale.preferredLanguages.firstObject;
    return [self matchedLanguageForLanguage:systemLanguage] ?: SUDOPWCKDefaultLanguage;
}

+ (nullable NSString *)matchedLanguageForLanguage:(nullable NSString *)language {
    if (![language isKindOfClass:[NSString class]] || language.length == 0 ||
        ![language.lastPathComponent isEqualToString:language]) {
        return nil;
    }

    NSBundle *resourceBundle = [SUDOPWCKCommon resourceBundle];
    NSArray<NSString *> *availableLanguages = resourceBundle.localizations;
    NSString *candidate = [language stringByReplacingOccurrencesOfString:@"_" withString:@"-"];

    while (candidate.length > 0) {
        for (NSString *availableLanguage in availableLanguages) {
            if ([availableLanguage caseInsensitiveCompare:candidate] == NSOrderedSame) {
                return availableLanguage;
            }
        }

        NSRange separatorRange = [candidate rangeOfString:@"-" options:NSBackwardsSearch];
        if (separatorRange.location == NSNotFound) {
            break;
        }
        candidate = [candidate substringToIndex:separatorRange.location];
    }
    return nil;
}

+ (nullable NSBundle *)languageBundleForLanguage:(nullable NSString *)language {
    if (![language isKindOfClass:[NSString class]] || language.length == 0 ||
        ![language.lastPathComponent isEqualToString:language]) {
        return nil;
    }

    @synchronized (self) {
        NSBundle *cachedBundle = SUDOPWCKLanguageBundleCache[language];
        if (cachedBundle) {
            return cachedBundle;
        }
    }

    NSBundle *resourceBundle = [SUDOPWCKCommon resourceBundle];
    if (!resourceBundle) {
        return nil;
    }

    NSString *languageDirectory = [language stringByAppendingPathExtension:@"lproj"];
    NSString *languagePath = [resourceBundle.bundlePath stringByAppendingPathComponent:languageDirectory];
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:languagePath isDirectory:&isDirectory] || !isDirectory) {
        return nil;
    }

    NSBundle *languageBundle = [NSBundle bundleWithPath:languagePath];
    if (!languageBundle) {
        return nil;
    }

    @synchronized (self) {
        if (!SUDOPWCKLanguageBundleCache) {
            SUDOPWCKLanguageBundleCache = [NSMutableDictionary dictionary];
        }
        SUDOPWCKLanguageBundleCache[language] = languageBundle;
    }
    return languageBundle;
}

+ (nullable NSString *)localizedStringForKey:(NSString *)key
                                        table:(NSString *)table
                                     language:(NSString *)language {
    NSBundle *languageBundle = [self languageBundleForLanguage:language];
    if (!languageBundle) {
        return nil;
    }

    NSString *missingValue = [NSString stringWithFormat:@"__SUDOPWCK_MISSING_%@__", key];
    NSString *value = [languageBundle localizedStringForKey:key
                                                      value:missingValue
                                                      table:table];
    return [value isEqualToString:missingValue] ? nil : value;
}

@end
