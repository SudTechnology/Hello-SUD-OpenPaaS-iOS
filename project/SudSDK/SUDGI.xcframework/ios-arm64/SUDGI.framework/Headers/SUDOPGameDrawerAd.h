//
//  SUDOPGameDrawerAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPAd.h"
NS_ASSUME_NONNULL_BEGIN

@interface SUDOPGameDrawerAdStyle : NSObject
@property(nonatomic, assign)NSInteger top;
@end


/// Game drawer ad
@interface SUDOPGameDrawerAd : SUDOPAd
@property(nonatomic, strong, nullable)SUDOPGameDrawerAdStyle *style;

@end

NS_ASSUME_NONNULL_END
