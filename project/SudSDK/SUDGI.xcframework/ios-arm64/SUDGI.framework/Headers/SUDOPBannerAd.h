//
//  SUDOPBannerAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPAd.h"
NS_ASSUME_NONNULL_BEGIN
 
/// ad style
@interface SUDOPBannerAdStyle : NSObject
@property(nonatomic, assign)NSInteger left;
@property(nonatomic, assign)NSInteger top;
@property(nonatomic, assign)NSInteger width;
@property(nonatomic, assign)NSInteger height;
@property(nonatomic, assign)NSInteger realWidth;
@property(nonatomic, assign)NSInteger realHeight;
@end

/// Banner ad
@interface SUDOPBannerAd : SUDOPAd
@property(nonatomic, strong)SUDOPBannerAdStyle *style;
@end

NS_ASSUME_NONNULL_END
