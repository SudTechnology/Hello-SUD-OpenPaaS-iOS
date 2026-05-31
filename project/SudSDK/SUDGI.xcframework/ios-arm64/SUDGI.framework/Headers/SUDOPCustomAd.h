//
//  SUDOPCustomAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPAd.h"
NS_ASSUME_NONNULL_BEGIN

/// ad style
@interface SUDOPCustomAdStyle : NSObject
@property(nonatomic, assign)NSInteger left;
@property(nonatomic, assign)NSInteger top;
@property(nonatomic, assign)BOOL fixed;
@end

/// Cutoms ad
@interface SUDOPCustomAd : SUDOPAd
@property(nonatomic, strong)SUDOPCustomAdStyle *style;
/**
 Notifies that the ad has been hidden.
 */
- (void)notifyDidHide;
@end

NS_ASSUME_NONNULL_END
