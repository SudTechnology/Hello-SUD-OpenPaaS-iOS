//
//  SUDRTExtendedClient.h
//  SUDGI
//
//  Created by kaniel on 4/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// JS callback protocol (aligned with Android SUDJSCallback).
@protocol SUDRTJSCallback <NSObject>

// Invoke the JS callback with arguments serialized by the SDK.
- (void)invoke:(NSArray * _Nullable)arguments;

// Release the JS callback reference to break cross-language retain cycles.
- (void)releaseCallback;

@end

// JS Promise resolve/reject blocks (aligned with Android SUDPromise<T>).
typedef void (^SUDRTPromiseResolveBlock)(id _Nullable result);
typedef void (^SUDRTPromiseRejectBlock)(NSString * _Nullable reason);

/**
 * Export an async method (aligned with Android @SUDASync).
 * Async method must return void; results are delivered via promise blocks.
 */
#define SUDRT_ASYNC(js_name, method) \
    + (NSArray<NSString *> *)__sud_async_##js_name { \
        return @[ @#js_name, @#method, @"async" ]; \
    } \
    - (void)method

/**
 * Export a sync method (aligned with Android @SUDSync).
 * Sync method returns a value directly.
 */
#define SUDRT_SYNC(js_name, return_type, method) \
    + (NSArray<NSString *> *)__sud_sync_##js_name { \
        return @[ @#js_name, @#method, @"sync" ]; \
    } \
    - (return_type)method



#define SUDRT_USE_PROTOCOL(proto) \
__attribute__((constructor)) static void sudrt_use_protocol_##proto(void) { \
    (void)@protocol(proto); \
}

/// tell compiler use this custom protocol
SUDRT_USE_PROTOCOL(SUDRTJSCallback);
NS_ASSUME_NONNULL_END
