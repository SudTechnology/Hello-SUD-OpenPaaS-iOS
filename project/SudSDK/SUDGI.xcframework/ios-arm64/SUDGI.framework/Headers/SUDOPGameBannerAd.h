//
//  SUDOPGameBannerAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPAd.h"
NS_ASSUME_NONNULL_BEGIN
@class SUDOPGameBannerAd;

@interface SUDOPGameBannerAdStyle : NSObject
@property(nonatomic, assign)NSInteger top;
@property(nonatomic, assign)NSInteger left;
/// vertical | horizontal
@property(nonatomic, strong)NSString * orientation;
@end

/// Game banner ad
@interface SUDOPGameBannerAd : SUDOPAd
@property(nonatomic, strong, nullable)SUDOPGameBannerAdStyle *style;

@end

NS_ASSUME_NONNULL_END
