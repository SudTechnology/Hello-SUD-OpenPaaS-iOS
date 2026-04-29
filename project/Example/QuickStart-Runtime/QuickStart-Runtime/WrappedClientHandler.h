//
//  WrappedClientHandler.h
//  HelloSud-iOS
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import <SUDGI/SUDGI-umbrella.h>
NS_ASSUME_NONNULL_BEGIN

@interface WrappedClientHandler : NSObject<SUDOPWrappedClientDelegate>
@property(nonatomic, weak)UIView *gameContentView;
@property(nonatomic, weak)UIViewController *vc;

- (void)cleanup;
@end


NS_ASSUME_NONNULL_END
