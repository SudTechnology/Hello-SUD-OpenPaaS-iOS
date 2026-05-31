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
    [Common reqUserProfileWithUserId:userId encryptedData:encryptedData completion:^(NSDictionary * _Nonnull dicUserProfile, NSError * _Nonnull error) {
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
    SheetAction *action1 = [SheetAction actionWithTitle:@"模拟支付成功"];
    [actions addObject:action1];
    
    SheetAction *action2 = [SheetAction actionWithTitle:@"模拟支付失败"];
    [actions addObject:action2];
    
//    SheetAction *action3 = [SheetAction actionWithTitle:@"模拟支付失败"];
//    [actions addObject:action3];
    
//    SheetAction *deleteAction = [SheetAction actionWithTitle:@"删除"];
//    deleteAction.isDestructive = YES;
//    [actions addObject:deleteAction];
    
    [SheetViewController showInViewController:self.viewController actions:actions completion:^(SheetAction *action) {
        if (action == action1) {
            NSLog(@"选中了：%@", action.title);

            [SVProgressHUD showWithStatus:@"验证订单"];
            [Common reqVerifyOrderWithUserId:userId signData:options.signData signature:options.signature completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
                if (error) {
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                    return;
                }
                [SVProgressHUD dismiss];
                NSString *sud_trade_no = result[@"sud_trade_no"];
                [Common reqMockPayWithUserId:userId sudTradeNo:sud_trade_no action:@"SUCCESS" completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                        return;
                    }
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                    [stateHandle success:@""];
                }];
                
            }];
        } else if(action == action2) {
            /// 模拟支付失败
            
            [SVProgressHUD showWithStatus:@"验证订单"];
            [Common reqVerifyOrderWithUserId:userId signData:options.signData signature:options.signature completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
                if (error) {
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                    return;
                }
                [SVProgressHUD dismiss];
                NSString *sud_trade_no = result[@"sud_trade_no"];
                [Common reqMockPayWithUserId:userId sudTradeNo:sud_trade_no action:@"FAILED" completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
                    if (error) {
                        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                        return;
                    }
                    [SVProgressHUD showSuccessWithStatus:@"模拟支付失败"];
                    NSError *retError = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{
                        NSLocalizedDescriptionKey:@"模拟支付失败",
                    }];
                    [stateHandle failure:retError];
                }];
                
            }];
        } else {
            NSLog(@"取消了选择");
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


- (NSDictionary *)getMenuButtonBoundingClientRect {
//    width    number    宽度，单位：px
//    height    number    高度，单位：px
//    top    number    上边界坐标，单位：px
//    right    number    右边界坐标，单位：px
//    bottom    number    下边界坐标，单位：px
//    left    number    左边界坐标，单位：px
    CGFloat scale = [UIScreen mainScreen].nativeScale;
    CGFloat width = 100 * scale;
    CGFloat height = 30 * scale;
    CGFloat top = 10 * scale;
    CGFloat right = 10 * scale;
    CGFloat bottom = 10 * scale;
    CGFloat left = 10 * scale;
    return @{
        @"width":@(width),
        @"height":@(height),
        @"top":@(top),
        @"right":@(right),
        @"bottom":@(bottom),
        @"left":@(left),
    };
}
@end
