#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SUDMReportEventType) {
    SUDMReportEventTypeSDKInit = 1,
    SUDMReportEventTypeADNInit = 2,
    SUDMReportEventTypeAppAdRequest = 3,
    SUDMReportEventTypeMediationRequest = 8,
    SUDMReportEventTypeMediationFill = 9,
    SUDMReportEventTypeMediaRequest = 10,
    SUDMReportEventTypeMediaFill = 11,
    SUDMReportEventTypeWin = 17,
    SUDMReportEventTypeShow = 18,
    SUDMReportEventTypeClick = 19,
    SUDMReportEventTypeMediaRevenuePaid = 20,
    SUDMReportEventTypePriceFilter = 21,
    SUDMReportEventTypePlay = 22,
    SUDMReportEventTypeClose = 23,
};

FOUNDATION_EXPORT NSString * const SUDMReportEventNameSDKInitStart;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameSDKGetConfigStart;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameSDKGetConfigEnd;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameSDKGetConfigFailed;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameSDKInitEnd;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameSDKInitFailed;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameADNInitStart;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameADNInitEnd;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameADNInitFailed;

FOUNDATION_EXPORT NSString * const SUDMReportEventNameAppAdRequest;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameMediationRequestStart;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameMediationFillEnd;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameMediationFillFailed;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameMediaRequestStart;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameMediaFillEnd;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameMediaFillNotMatch;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameMediaFillFailed;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameMediaFillTimeout;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameMediaPriceFilter;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameWin;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameShowReady;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameShowStart;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameShowEnd;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameShowFailed;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameClickStart;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameClickEnd;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameMediaRevenuePaid;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameClose;
FOUNDATION_EXPORT NSString * const SUDMReportEventNamePlayStart;
FOUNDATION_EXPORT NSString * const SUDMReportEventNamePlayEnd;
FOUNDATION_EXPORT NSString * const SUDMReportEventNamePlayFailed;
FOUNDATION_EXPORT NSString * const SUDMReportEventNameReward;

NS_ASSUME_NONNULL_END
