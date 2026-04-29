//
//  SUDOPBannerAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SUDOPBannerAd;
/// Game->APP event
@protocol SUDOPBannerAdDelegate <NSObject>
- (void)bannerAdShow:(SUDOPBannerAd *)bannerAd;
- (void)bannerAdHide:(SUDOPBannerAd *)bannerAd;
- (void)bannerAdDestroy:(SUDOPBannerAd *)bannerAd;
@end
 
/// ad style
@interface SUDOPBannerAdStyle : NSObject
@property(nonatomic, assign)NSInteger left;
@property(nonatomic, assign)NSInteger top;
@property(nonatomic, assign)NSInteger width;
@end

/// banner
@interface SUDOPBannerAd : NSObject
@property(nonatomic, strong)NSString *adUnitId;
@property(nonatomic, strong)SUDOPBannerAdStyle *style;
@property(nonatomic, weak)id<SUDOPBannerAdDelegate> delegte;

/// notify ad Loaded
- (void)notifyOnLoad;

/// notify ad error
- (void)notifyOnError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
