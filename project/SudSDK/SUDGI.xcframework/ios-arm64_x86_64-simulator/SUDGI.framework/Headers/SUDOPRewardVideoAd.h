//
//  SUDOPRewardVideoAd.h
//  SUDGI
//
//  Created by kaniel on 4/13/26.
//

#import <Foundation/Foundation.h>
#import "SUDOPAd.h"
NS_ASSUME_NONNULL_BEGIN
@class SUDOPRewardVideoAd;

@interface SUDOPRewardVideoAdSSVData : NSObject
@property(nonatomic, strong)NSString *sudTransactionId;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *rewardItem;
@property(nonatomic, assign)NSInteger rewardAmount;
@property(nonatomic, strong)NSString *customData;
@end


/// RewardVideo ad
@interface SUDOPRewardVideoAd : SUDOPAd 

/// notify ad close
- (void)notifyDidCloseWithIsEnded:(BOOL)isEnded;
@end

NS_ASSUME_NONNULL_END
