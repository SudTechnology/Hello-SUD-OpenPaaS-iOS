//
//  SUDOPCustomAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SUDOPCustomAd;
/// Game->APP event
@protocol SUDOPCustomAdDelegate <NSObject>
- (void)customAdShow:(SUDOPCustomAd *)bannerAd;
- (BOOL)customAdIsShow:(SUDOPCustomAd *)bannerAd;
- (void)customAdHide:(SUDOPCustomAd *)bannerAd;
- (void)customAdDestroy:(SUDOPCustomAd *)bannerAd;
@end
 
/// ad style
@interface SUDOPCustomAdStyle : NSObject
@property(nonatomic, assign)NSInteger left;
@property(nonatomic, assign)NSInteger top;
@property(nonatomic, assign)BOOL fixed;
@end

/// banner
@interface SUDOPCustomAd : NSObject
@property(nonatomic, strong)NSString *adUnitId;
@property(nonatomic, strong)SUDOPCustomAdStyle *style;
@property(nonatomic, weak)id<SUDOPCustomAdDelegate> delegte;

/// notify ad Loaded
- (void)notifyOnLoad;
/// notify ad closed
- (void)notifyOnClose;
/// notify ad error
- (void)notifyOnError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
