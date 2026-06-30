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
    
    
    WeakSelf
    NSString *userId = [Common.shared currentUserId];
    /// 这里的user_id是设置游戏中用户名，由接入方传入,这里uuid只是示例
    NSDictionary * param = @{@"user_id": userId,
                             @"slot_code":@"",
                             @"app_id":SUDGI_APP_ID};
    [SUDDemoHttpService.shared reqAdMaterialWithOptions:param completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"reqAdMaterialWithOptions:%@", error.localizedDescription);
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        
        NSString *transaction_id = result[@"transaction_id"];
        weakSelf.transactionId = transaction_id;
        [weakSelf.ad notifyDidLoad];
        [weakSelf checkIfNeedToReportSSVData];
    }];
    
}


- (void)destroyAd:(SUDOPRewardVideoAd *)rewardVideoAd {
    [self.adView removeFromSuperview];
    self.adView = nil;
    self.ad = nil;
}

- (void)loadAd:(SUDOPAd *)ad withStateHandle:(id<SUDOPStateHandle>)stateHandle {
    [self.adView loadAd];
    [stateHandle success:nil];
}

- (void)hideAd:(SUDOPRewardVideoAd *)rewardVideoAd withStateHandle:(id<SUDOPStateHandle>)stateHandle {
    [self.adView closeAd];
    [stateHandle success:nil];
}

- (void)showAd:(nonnull SUDOPRewardVideoAd *)rewardVideoAd withStateHandle:(id<SUDOPStateHandle>)stateHandle {
    
    [self.adView showAdFromViewController:self.viewController];
    [stateHandle success:nil];
}

- (void)setServerSideVerificationData:(SUDOPRewardVideoAdSSVData *)ssvData forAd:(SUDOPAd *)ad {
    
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
    
    [SUDDemoHttpService.shared reqReportRewardAdSSVWithOptions:options completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
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
    
    [SUDDemoHttpService.shared reqReportRewardAdStatusWithOptions:options respClass:SUDDemoBaseRespModel.class completion:^(SUDDemoBaseRespModel * _Nonnull resp, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"reqReportRewardAdStatusWithOptions error:%@", error.localizedDescription);
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        
        NSLog(@"reqReportRewardAdStatusWithOptions successfully");
    }];
}
@end
