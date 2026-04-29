//
//  SUDOPGamePortalAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SUDOPGamePortalAd;
/// Game->APP event
@protocol SUDOPGamePortalAdDelegate <NSObject>
- (void)gamePortalAdLoad:(SUDOPGamePortalAd *)gamePortalAd;
- (void)gamePortalAdShow:(SUDOPGamePortalAd *)gamePortalAd;
- (void)gamePortalAdDestroy:(SUDOPGamePortalAd *)gamePortalAd;
@end


/// banner
@interface SUDOPGamePortalAd : NSObject
@property(nonatomic, strong)NSString *adUnitId;
@property(nonatomic, weak)id<SUDOPGamePortalAdDelegate> delegte;

/// notify ad Loaded
- (void)notifyOnLoad;

- (void)notifyOnShow;

- (void)notifyOnClose;

- (void)notifyOnClickWith:(NSInteger)code msg:(NSString *)msg;

/// notify ad error
- (void)notifyOnError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
