//
//  SUDOPGameBannerAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SUDOPGameBannerAd;
/// Game->APP event
@protocol SUDOPGameBannerAdDelegate <NSObject>
- (void)gameBannerAdShow:(SUDOPGameBannerAd *)gameBannerAd;
- (void)gameBannerAdHide:(SUDOPGameBannerAd *)gameBannerAd;
- (void)gameBannerAdAdDestroy:(SUDOPGameBannerAd *)gameBannerAd;
@end

@interface SUDOPGameBannerAdStyle : NSObject
@property(nonatomic, assign)NSInteger top;
@property(nonatomic, assign)NSInteger left;
/// vertical | horizontal
@property(nonatomic, strong)NSString * orientation;
@end

/// banner
@interface SUDOPGameBannerAd : NSObject
@property(nonatomic, strong)NSString *adUnitId;
@property(nonatomic, strong, nullable)SUDOPGameBannerAdStyle *style;
@property(nonatomic, weak)id<SUDOPGameBannerAdDelegate> delegte;

/// notify ad Loaded
- (void)notifyOnLoad;

- (void)notifyOnShow;

- (void)notifyOnClickWith:(NSInteger)code msg:(NSString *)msg;

/// notify ad error
- (void)notifyOnError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
