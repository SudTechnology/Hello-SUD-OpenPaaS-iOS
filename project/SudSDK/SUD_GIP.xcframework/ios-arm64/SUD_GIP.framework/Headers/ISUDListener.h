//
//  ISUDListener.h
//  Pods
//
//  Created by kaniel on 2/14/25.
//

#import <Foundation/Foundation.h>
#import "SUDNetworkCheckParamModel.h"
#import "SUDGameCheckoutStatus.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^INetworkDetectionListener)(SudNetworkDetectionResult *result);
typedef void (^ISUDListenerGetMGList)(int retCode, const NSString* retMsg, const NSString* _Nullable dataJson);
typedef void (^ISUDListenerInitSDK)(int retCode, const NSString* retMsg);
typedef void (^ISUDListenerNotifyStateChange)(int retCode, const NSString* retMsg, const NSString* dataJson);
typedef void (^ISUDListenerReportStatsEvent)(const NSString* event, int retCode, const NSString* stats);
typedef void (^ISUDListenerUninitSDK)(int retCode, const NSString* retMsg);

@protocol ISUDListenerPrepareGame <NSObject>

-(void) onPrepareSuccess:(int64_t) mgId;

-(void) onPrepareFailure:(int64_t) mgId errCode:(int) errCode errMsg:(NSString *) errMsg;

-(void) onPrepareStatus:(int64_t) mgId checkoutedSize:(long) checkoutedSize totalSize:(long) totalSize status:(SUDGameCheckoutStatus) status;

@end

NS_ASSUME_NONNULL_END
