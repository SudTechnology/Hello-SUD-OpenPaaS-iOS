//
//  CustomAdHandler.h
//  HelloSud-iOS
//
//  Created by kaniel on 4/28/26.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface CustomAdHandler : NSObject
- (void)createWithAd:(SUDOPCustomAd *)customAd viewController:(UIViewController *)viewController;
- (void)cleanup;
@end

NS_ASSUME_NONNULL_END
