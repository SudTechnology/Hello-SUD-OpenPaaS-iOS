//
//  SUDRuntimeGameMediaPlayerHandle.h
//  SUD_GI
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SUDRuntimeGameMediaPlayerHandle <NSObject>
- (UInt64)getInstanceID;

- (void)setMediaCAEAGLLayer:(CAEAGLLayer *) layer;
@end

NS_ASSUME_NONNULL_END

