#import <Foundation/Foundation.h>
#import "SUDReportContext.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SUDReportContextProvider <NSObject>

- (nullable SUDReportContext *)currentReportContext;

@end

@interface SUDReportContextRegistry : NSObject

+ (void)setProvider:(nullable id<SUDReportContextProvider>)provider;
+ (nullable SUDReportContext *)snapshot;
+ (void)clearProvider:(id<SUDReportContextProvider>)provider;

@end

NS_ASSUME_NONNULL_END
