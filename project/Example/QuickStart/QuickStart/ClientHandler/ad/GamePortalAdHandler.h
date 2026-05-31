//
//  GamePortalAdHandler.h
//  HelloSud-iOS
//
//  Created by kaniel on 4/28/26.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface GamePortalAdHandler : NSObject
- (void)createBoxPortalAdWithAd:(SUDOPGamePortalAd *)ad viewController:(UIViewController *)viewController;
- (void)cleanup;
@end

NS_ASSUME_NONNULL_END
