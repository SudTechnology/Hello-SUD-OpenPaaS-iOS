//
//  SUDOPGameDrawerAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SUDOPGameDrawerAd;
/// Game->APP event
@protocol SUDOPGameDrawerAdDelegate <NSObject>
- (void)gameDrawerAdShow:(SUDOPGameDrawerAd *)gameDrawerAd;
- (void)gameDrawerAdHide:(SUDOPGameDrawerAd *)gameDrawerAd;
- (void)gameDrawerAdDestroy:(SUDOPGameDrawerAd *)gameDrawerAd;
@end


@interface SUDOPGameDrawerAdStyle : NSObject
@property(nonatomic, assign)NSInteger top;
@end


/// banner
@interface SUDOPGameDrawerAd : NSObject
@property(nonatomic, strong)NSString *adUnitId;
@property(nonatomic, strong, nullable)SUDOPGameDrawerAdStyle *style;
@property(nonatomic, weak)id<SUDOPGameDrawerAdDelegate> delegte;

- (void)notifyOnShow;

- (void)notifyOnClickWith:(NSInteger)code msg:(NSString *)msg;

/// notify ad error
- (void)notifyOnError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
