

#import <Foundation/Foundation.h>
#import "SUDMBaseAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface SUDMAdObject : NSObject

@property (nonatomic,weak)SUDMBaseAdapter * adapter;
@property (nonatomic,assign)CGFloat ecpm;
@property (nonatomic,assign)SUDMAdType adType;
@property (nonatomic,assign)NSInteger platformID;
@property (nonatomic,copy)NSString *platformName;
@property (nonatomic,copy)NSString *mediationPlacementId;
//mediation info
@property (nonatomic,copy)NSString *networkPlacement;
@property (nonatomic,copy)NSString *networkName;
@property (nonatomic,assign)NSInteger networkID;
@property (nonatomic,copy)NSString *revenuePrecision;
@property (nonatomic,strong)NSDictionary *networkAdInfo;

- (nullable id)getAdObject;
- (NSDictionary *)infoDic;
@end

NS_ASSUME_NONNULL_END
