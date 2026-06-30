//
//  DemoWrappedClientHandler.m
//  HelloSud-iOS
//
//  Created by kaniel on 4/13/26.
//

#import "DemoWrappedClientHandler.h"

#import "Common.h"
#import "SheetViewController.h"
#import "SUDDemoInterstitialAdView.h"
#import "BannerAdHandler.h"
#import "CustomAdHandler.h"
#import "InterstitialAdHandler.h"
#import "GameBannerAdHandler.h"
#import "GamePortalAdHandler.h"
#import "GameDrawerAdHandler.h"
#import "RewardVideoAdHandler.h"

@interface DemoWrappedClientHandler()

@property(nonatomic, strong)SUDOPInterstitialAd *interstitialAd;

@property(nonatomic, strong)SUDDemoInterstitialAdView *interstitialAdView;

@property(nonatomic, strong)BannerAdHandler *bannerAdHandler;
@property(nonatomic, strong)CustomAdHandler *customAdHandler;
@property(nonatomic, strong)InterstitialAdHandler *interstitialAdHandler;
@property(nonatomic, strong)GameBannerAdHandler *gameBannerAdHandler;
@property(nonatomic, strong)GamePortalAdHandler *gamePortalAdHandler;
@property(nonatomic, strong)GameDrawerAdHandler *gameDrawerAdHandler;
@property(nonatomic, strong)RewardVideoAdHandler *rewardVideoAdHandler;

@end

@implementation DemoWrappedClientHandler

- (BannerAdHandler *)bannerAdHandler {
    if (!_bannerAdHandler) {
        _bannerAdHandler = [[BannerAdHandler alloc]init];
    }
    return _bannerAdHandler;
}

- (CustomAdHandler *)customAdHandler {
    if (!_customAdHandler) {
        _customAdHandler = [[CustomAdHandler alloc]init];
    }
    return _customAdHandler;
}

- (InterstitialAdHandler *)interstitialAdHandler {
    if (!_interstitialAdHandler) {
        _interstitialAdHandler = [[InterstitialAdHandler alloc]init];
    }
    return _interstitialAdHandler;
}

- (GameBannerAdHandler *)gameBannerAdHandler {
    if (!_gameBannerAdHandler) {
        _gameBannerAdHandler = [[GameBannerAdHandler alloc]init];
    }
    return _gameBannerAdHandler;
}

- (GamePortalAdHandler *)gamePortalAdHandler {
    if (!_gamePortalAdHandler) {
        _gamePortalAdHandler = [[GamePortalAdHandler alloc]init];
    }
    return _gamePortalAdHandler;
}

- (GameDrawerAdHandler *)gameDrawerAdHandler {
    if (!_gameDrawerAdHandler) {
        _gameDrawerAdHandler = [[GameDrawerAdHandler alloc]init];
    }
    return _gameDrawerAdHandler;
}

- (RewardVideoAdHandler *)rewardVideoAdHandler {
    if (!_rewardVideoAdHandler) {
        _rewardVideoAdHandler = [[RewardVideoAdHandler alloc]init];
    }
    return _rewardVideoAdHandler;
}


- (void)onGetLegacyUserIdentity:(id<SUDOPStateHandle>)stateHandle dataJson:(NSString*)dataJson {

    NSDictionary *dic = @{
        @"uid":@"1234",
    };
    NSString *result = [dic mj_JSONString];
    [stateHandle success:result];
    
}

- (void)onGetUserInfo:(id<SUDOPStateHandle>)stateHandle dataJson:(NSString*)dataJson {
    NSDictionary *dic = @{
        @"nickname":@"demo name",
        @"avatar":@"demo avatar",
    };
    NSString *result = [dic mj_JSONString];
    [stateHandle success:result];
}

- (void)onGetUserProfile:(id<SUDOPStateHandle>)stateHandle dataJson:(NSString*)dataJson {
    
    NSString *userId = [Common getUserName];
    if (Common.shared.customUserId.length > 0) {
        userId = Common.shared.customUserId;
    }
    NSDictionary *dic = [dataJson mj_JSONObject];
    NSString *encryptedData = dic[@"encryptedData"];
    NSDictionary * param = @{@"user_id": userId, @"encrypted_data":encryptedData, @"app_id":Common.shared.selectedGameAppId};
    [SUDDemoHttpService.shared reqUserProfileWithOptions:param completion:^(NSDictionary * _Nonnull dicUserProfile, NSError * _Nonnull error) {
        if (error) {
            [stateHandle failure:error];
            return;
        }
        NSString *userProfileJsonStr = dicUserProfile[@"user_profile_data"];
        [stateHandle success:userProfileJsonStr];
    }];
}


- (void)createBannerAd:(SUDOPBannerAd *)bannerAd {
    [self.bannerAdHandler createWithAd:bannerAd viewController:self.viewController];
}

- (void)createCustomAd:(SUDOPCustomAd *)customAd {
    [self.customAdHandler createWithAd:customAd viewController:self.viewController];
}

- (void)createInterstitialAd:(SUDOPInterstitialAd *)interstitialAd {
    [self.interstitialAdHandler createWithAd:interstitialAd viewController:self.viewController];
}

- (void)createGameBannerAd:(SUDOPGameBannerAd *)gameBannerAd {
    [self.gameBannerAdHandler createBoxBannerAdWithAd:gameBannerAd viewController:self.viewController];
}

- (void)createGamePortalAd:(SUDOPGamePortalAd *)gamePortalAd {
    [self.gamePortalAdHandler createBoxPortalAdWithAd:gamePortalAd viewController:self.viewController];
}

- (void)createGameDrawerAd:(SUDOPGameDrawerAd *)gameDrawerAd {
    [self.gameDrawerAdHandler createBoxDrawerAdWithAd:gameDrawerAd viewController:self.viewController];
}

- (void)createRewardedVideoAd:(SUDOPRewardVideoAd *)rewardVideoAd {
    [self.rewardVideoAdHandler createWithAd:rewardVideoAd viewController:self.viewController];
}

- (void)requestPayment:(id<SUDOPStateHandle>)stateHandle options:(SUDOPRequestPaymentOptions *)options {
    
    
    NSString *userId = [Common getUserName];
    if (Common.shared.customUserId.length > 0) {
        userId = Common.shared.customUserId;
    }
    NSMutableArray *actions = [NSMutableArray array];
    
    // 添加操作项
    SheetAction *action1 = [SheetAction actionWithTitle:@"去支付"];
    [actions addObject:action1];

    [SheetViewController showInViewController:self.viewController
                                        title:options.sudTradeNo
                                      message:options.signData
                                      actions:actions completion:^(SheetAction *action) {
        if (action == action1) {
            NSLog(@"选中了：%@", action.title);

            [SVProgressHUD showWithStatus:@"创建订单"];
            NSDictionary * param = @{@"user_id": userId,
                                     @"sign_data":options.signData,
                                     @"signature":options.signature,
                                     @"app_id":Common.shared.selectedGameAppId};
            [SUDDemoHttpService.shared reqCreateOrderWithOptions:param
                                   completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
                if (error) {
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                    return;
                }
                [SVProgressHUD showWithStatus:@"获取支付信息"];
                NSString *sud_trade_no = result[@"sud_trade_no"];
                /// 这里的user_id是设置游戏中用户名，由接入方传入,这里uuid只是示例
                NSDictionary * param = @{@"user_id": userId,
                                         @"sud_trade_no":sud_trade_no,
                                         @"app_id":Common.shared.selectedGameAppId};
                [SUDDemoHttpService.shared reqPayInfoWithOptions:param
                                   completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                        return;
                    }
                    NSString *pay_url = result[@"pay_url"];
                    if (pay_url.length == 0) {
                        [SVProgressHUD showErrorWithStatus:@"pay_url 为空"];
                        return;
                    }
                    [SVProgressHUD dismiss];
                    [Common.shared openLink:pay_url];
                    [self showCheckOrderMenuWith:options.sudTradeNo stateHandle:stateHandle];
                }];
                
            }];
        } else {
            NSLog(@"取消了选择");
            NSError *retError = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{
                NSLocalizedDescriptionKey:@"用户取消支付",
            }];
            [stateHandle failure:retError];
        }
    }];

}

- (NSString *)payStatusDescWithStatus:(NSInteger)status {
    switch (status) {
        case 1:
            return @"待支付";
        case 2:
            return @"支付处理中";
        case 3:
            return @"支付成功";
        case 4:
            return @"支付失败";
        case 5:
            return @"超时关闭";
        case 6:
            return @"主动撤销";
        case 7:
            return @"退款中";
        case 8:
            return @"退款完成";
        default:
            return @"未知状态";
    }
}

- (void)showCheckOrderMenuWith:(NSString *)tradeNo stateHandle:(id<SUDOPStateHandle>)stateHandle {
    NSString *userId = [Common getUserName];
    if (Common.shared.customUserId.length > 0) {
        userId = Common.shared.customUserId;
    }
    NSMutableArray *actions = [NSMutableArray array];
    
    // 添加操作项
    SheetAction *action1 = [SheetAction actionWithTitle:@"查询支付结果"];
    [actions addObject:action1];

    
    [SheetViewController showInViewController:self.viewController
                                        title:tradeNo
                                      message:@""
                                      actions:actions completion:^(SheetAction *action) {
        if (action == action1) {
            NSLog(@"选中了：%@", action.title);

            [SVProgressHUD showWithStatus:@"正在查询支付结果..."];
            /// 这里的user_id是设置游戏中用户名，由接入方传入,这里uuid只是示例
            NSDictionary * param = @{@"user_id": userId,
                                     @"sud_trade_no":tradeNo,
                                     @"app_id":Common.shared.selectedGameAppId};
            [SUDDemoHttpService.shared reqPayResultWithOptions:param
                                completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
                if (error) {
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                    return;
                }
                
                
                NSInteger order_status = [result[@"order_status"] intValue];
                if (order_status == 3) {
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    [stateHandle success:@""];
                } else {
                    NSString *tip = [NSString stringWithFormat:@"%@(%@)",[self payStatusDescWithStatus:order_status],@(order_status)];
                    [SVProgressHUD showErrorWithStatus:tip];
                    [self showCheckOrderMenuWith:tradeNo stateHandle:stateHandle];
                }

            }];
        } else {
            NSLog(@"取消了选择");
            NSError *retError = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{
                NSLocalizedDescriptionKey:@"用户取消查询结果",
            }];
            [stateHandle failure:retError];
        }
    }];
}

- (NSDictionary *)getAppBaseInfo {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];

    return @{
        @"version":version
    };
}



- (void)cleanup {

    [_customAdHandler cleanup];
    [_bannerAdHandler cleanup];
    [_interstitialAdHandler cleanup];
}

- (void)onQueryPermission:(id<SUDRTGameQueryPermissionHandle>)handle permission:(NSString *)permission appId:(NSString *)appId authStatus:(SUDRTPermissionAuthStatus)authStatus {
    [super onQueryPermission:handle permission:permission appId:appId authStatus:authStatus];
}

- (void)beforeQuerySystemPermission:(id<SUDRTGameQuerySystemPermissionHandle>)handle fromJSMethod:(NSString *)methodName permission:(NSString *)permission appId:(NSString *)appId authStatus:(SUDRTSystemPermissionAuthStatus)authStatus serviceStatus:(BOOL)enabled {
    [super beforeQuerySystemPermission:handle fromJSMethod:methodName permission:permission appId:appId authStatus:authStatus serviceStatus:enabled];
}


- (nonnull SUDOPMenuButtonBoundingClientRect *)getMenuButtonBoundingClientRect {

    CGRect capsuleViewRect = CGRectZero;
    if (self.boundRectBlock){
        capsuleViewRect = self.boundRectBlock();
    }
    CGFloat width = CGRectGetWidth(capsuleViewRect);
    CGFloat height = CGRectGetHeight(capsuleViewRect);
    CGFloat top = CGRectGetMinY(capsuleViewRect);
    CGFloat right = CGRectGetMaxX(capsuleViewRect);
    CGFloat bottom = CGRectGetMaxY(capsuleViewRect);
    CGFloat left = CGRectGetMinX(capsuleViewRect);
    SUDOPMenuButtonBoundingClientRect *menuButtonBoundingClientRect = [[SUDOPMenuButtonBoundingClientRect alloc]init];
    menuButtonBoundingClientRect.width = width;
    menuButtonBoundingClientRect.height = height;
    menuButtonBoundingClientRect.top = top;
    menuButtonBoundingClientRect.left = left;
    menuButtonBoundingClientRect.right = right;
    menuButtonBoundingClientRect.bottom = bottom;
    return menuButtonBoundingClientRect;
}
@end
