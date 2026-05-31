//
//  SUDOPWCKLanguageHelper.m
//  SUDGI
//
//  Created by kaniel on 5/28/26.
//

#import "SUDOPWCKLanguageHelper.h"

@implementation SUDOPWCKLanguageHelper

+ (NSString *)localizedStringFromDictionary:(NSDictionary<NSString *,NSString *> *)languageMap {
    NSString *currentLanguage = NSLocale.preferredLanguages.firstObject;
    return [self localizedStringFromDictionary:languageMap language:currentLanguage];
}

+ (NSString *)localizedStringFromDictionary:(NSDictionary<NSString *,NSString *> *)languageMap
                                   language:(NSString *)language {
    if (![languageMap isKindOfClass:[NSDictionary class]] || languageMap.count == 0) {
        return @"";
    }
    
    if (![language isKindOfClass:[NSString class]] || language.length == 0) {
        language = NSLocale.preferredLanguages.firstObject;
    }
    
    if (language.length > 0) {
        // 1. 精确匹配，例如 zh-CN / en-US
        NSString *exactValue = languageMap[language];
        if ([exactValue isKindOfClass:[NSString class]] && exactValue.length > 0) {
            return exactValue;
        }
        
        // 2. 如果是 zh-Hans-CN 这种，再尝试截短一级
        NSArray<NSString *> *components = [language componentsSeparatedByString:@"-"];
        if (components.count > 2) {
            NSString *middleLanguage = [NSString stringWithFormat:@"%@-%@", components[0], components[1]];
            NSString *middleValue = languageMap[middleLanguage];
            if ([middleValue isKindOfClass:[NSString class]] && middleValue.length > 0) {
                return middleValue;
            }
        }
        
        // 3. 再按语言前缀匹配，例如 zh / en
        NSString *languageCode = [[language componentsSeparatedByString:@"-"] firstObject];
        if (languageCode.length > 0) {
            NSString *prefixValue = languageMap[languageCode];
            if ([prefixValue isKindOfClass:[NSString class]] && prefixValue.length > 0) {
                return prefixValue;
            }
            
            // 4. 遍历字典，找同语言前缀的 key，例如 zh-CN / zh-TW
            for (NSString *key in languageMap.allKeys) {
                if (![key isKindOfClass:[NSString class]]) {
                    continue;
                }
                NSString *keyLanguageCode = [[key componentsSeparatedByString:@"-"] firstObject];
                if ([keyLanguageCode isEqualToString:languageCode]) {
                    NSString *value = languageMap[key];
                    if ([value isKindOfClass:[NSString class]] && value.length > 0) {
                        return value;
                    }
                }
            }
        }
    }
    
    // 5. fallback 到 default
    NSString *defaultValue = languageMap[@"default"];
    if ([defaultValue isKindOfClass:[NSString class]] && defaultValue.length > 0) {
        return defaultValue;
    }
    
    // 6. 最后兜底，返回任意一个可用字符串
    for (id key in languageMap.allKeys) {
        id value = languageMap[key];
        if ([value isKindOfClass:[NSString class]] && [value length] > 0) {
            return value;
        }
    }
    
    return @"";
}

@end
