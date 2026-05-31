//
//  RewardVideoAdHandler.m
//  HelloSud-iOS
//
//  Created by kaniel on 4/28/26.
//

#import "RewardVideoAdHandler.h"
#import "SUDDemoRewardedVideoAdView.h"
#import "Common.h"

@interface RewardVideoAdHandler()<SUDOPAdDelegate,SUDDemoRewardedVideoAdViewDelegate>
@property(nonatomic, strong)SUDOPRewardVideoAd *ad;
@property(nonatomic, strong)SUDDemoRewardedVideoAdView *adView;
@property(nonatomic, weak)UIViewController *viewController;
@property(nonatomic, strong)NSString *transactionId;
@property(nonatomic, strong)SUDOPRewardVideoAdSSVData *ssvData;

@end

@implementation RewardVideoAdHandler

- (void)cleanup {
    if (self.adView) {
        [self.adView removeFromSuperview];
    }
}

- (void)createWithAd:(SUDOPRewardVideoAd *)ad viewController:(UIViewController *)viewController {
    self.ad = ad;
    self.viewController = viewController;
    
    ad.delegate = self;
    self.adView = [[SUDDemoRewardedVideoAdView alloc]initWithAdUnitId:ad.adUnitId];
    self.adView.delegate = self;
    [self.adView loadAd];
    
    WeakSelf
    NSString *userId = [Common.shared currentUserId];
    [Common reqAdMaterialWithUserId:userId completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"reqAdMaterialWithUserId:%@", error.localizedDescription);
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        
        NSString *transaction_id = result[@"transaction_id"];
        weakSelf.transactionId = transaction_id;
        [weakSelf.ad notifyDidLoad];
        [weakSelf checkIfNeedToReportSSVData];
    }];
    
}


- (void)sudopAdDestroy:(SUDOPRewardVideoAd *)rewardVideoAd {
    [self.adView removeFromSuperview];
    self.adView = nil;
    self.ad = nil;
}

- (void)sudopAdHide:(SUDOPRewardVideoAd *)rewardVideoAd {
    [self.adView closeAd];
}

- (void)sudopAdShow:(nonnull SUDOPRewardVideoAd *)rewardVideoAd {
    
    [self.adView showAdFromViewController:self.viewController];
}

- (void)sudopAd:(SUDOPRewardVideoAd *)rewardVideoAd setServerSideVerificationData:(SUDOPRewardVideoAdSSVData *)ssvData {
    self.ssvData = ssvData;

    [self checkIfNeedToReportSSVData];

}

- (void)checkIfNeedToReportSSVData {
    if (self.transactionId.length == 0 || self.ssvData == nil) {
        return;
    }
    NSMutableDictionary *options = [[NSMutableDictionary alloc]init];
    options[@"transaction_id"] = self.transactionId;
    options[@"sud_transaction_id"] = self.ssvData.sudTransactionId;
    options[@"reward_item"] = self.ssvData.rewardItem;
    options[@"reward_amount"] = @(self.ssvData.rewardAmount);
    
    [Common reqReportRewardAdSSVWithOptions:options completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"reqReportRewardAdSSVWithOptions error:%@", error.localizedDescription);
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        NSLog(@"reqReportRewardAdSSVWithOptions successfully");

    }];
}

/// 广告加载成功
- (void)rewardedVideoAdDidLoad:(SUDDemoRewardedVideoAdView *)adView {
    [self.ad notifyDidLoad];
}

/// 广告加载失败
- (void)rewardedVideoAd:(SUDDemoRewardedVideoAdView *)adView didFailWithError:(NSError *)error {
    [self.ad notifyError:error];
}

/// 广告展示成功
- (void)rewardedVideoAdDidShow:(SUDDemoRewardedVideoAdView *)adView {
    [self.ad notifyDidShow];
}

/// 广告点击
- (void)rewardedVideoAdDidClick:(SUDDemoRewardedVideoAdView *)adView {
    [self.ad notifyDidClickWithCode:0 msg:@""];
}

/// 广告关闭
/// @param isRewarded 是否完整观看并给予奖励
- (void)rewardedVideoAdDidClose:(SUDDemoRewardedVideoAdView *)adView isRewarded:(BOOL)isRewarded {
    [self.ad notifyDidCloseWithIsEnded:isRewarded];
    NSMutableDictionary *options = [[NSMutableDictionary alloc]init];
    options[@"transaction_id"] = self.transactionId;
    options[@"sud_transaction_id"] = self.ssvData.sudTransactionId;
    options[@"status"] = @(isRewarded ? 1 : 0);
    
    [Common reqReportRewardAdStatusWithOptions:options respClass:SUDDemoBaseRespModel.class completion:^(SUDDemoBaseRespModel * _Nonnull resp, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"reqReportRewardAdStatusWithOptions error:%@", error.localizedDescription);
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        
        NSLog(@"reqReportRewardAdStatusWithOptions successfully");
    }];
}
@end
