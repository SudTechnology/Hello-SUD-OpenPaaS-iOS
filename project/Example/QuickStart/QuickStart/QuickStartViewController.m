//
//  ViewController.m
//  QuickStart
//
//  Created by kaniel on 10/27/25.
//

#import "QuickStartViewController.h"
#import "Common.h"
#import "DemoWrappedClientHandler.h"
#import "SUDOPGameManager.h"
#import "SUDDemoGameContainerView.h"
#import "SUDOPDemoGameInfoSheetView.h"
#import "SUDDemoGameInfoViewController.h"
#import "SUDOPGameManager.h"
@interface QuickStartViewController()

@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UIButton *startBtn;
@property(nonatomic, strong)UIButton *destroyBtn;
@property(nonatomic, strong)SUDDemoGameContainerView *gameContentView;
@property(nonatomic, strong)UIView *gameView;
@property(nonatomic, strong)NSDictionary *gameInfo;
@property(nonatomic, strong)DemoWrappedClientHandler *wrappedClientHandler;
@property(nonatomic, strong)SUDOPGameSession *gameSession;
@end

@implementation QuickStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 2 by gameId, contact SUD about how to getting gameId
    self.gameInfo = @{@"gameId": @"2061017615804846082",
                      @"version":@"1.0.0"};
    
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(self.view.frame.size.width/2., self.view.frame.size.height/2.)];
    self.view.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.destroyBtn];
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.leading.equalTo(@10);
        make.width.height.equalTo(@40);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_centerX).offset(-10);
        make.height.equalTo(@44);
        make.width.equalTo(@100);
        make.bottom.equalTo(@-90);
    }];
    
    [self.destroyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_centerX).offset(10);
        make.height.equalTo(@44);
        make.width.equalTo(@100);
        make.bottom.equalTo(@-90);
    }];
    [self updateBtnStateWithIsLoadedGame:NO];
}

- (DemoWrappedClientHandler *)wrappedClientHandler {
    if (!_wrappedClientHandler) {
        _wrappedClientHandler = [[DemoWrappedClientHandler alloc]init];
    }
    return _wrappedClientHandler;
}


- (void)backClick:(id)sender {
    [SUDOPGameManager.sharedManager destroyAllGames];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateBtnStateWithIsLoadedGame:(BOOL)isLoadGame {
    if (isLoadGame) {
        self.startBtn.enabled = NO;
        self.destroyBtn.enabled = YES;
    } else {
        self.startBtn.enabled = YES;
        self.destroyBtn.enabled = NO;
    }
}

- (void)startClick:(UIButton *)sender {
    WeakSelf
    [self destroyClick:nil];
    [[SUDGI getCfg] setLogLevel:SudLogDEBUG];
    [SVProgressHUD showWithStatus:@"Login"];
    [SVProgressHUD setMaximumDismissTimeInterval:3];

    NSString *gameID = self.gameInfo[@"gameId"];
    NSString *userId = Common.shared.currentUserId;
    SUDOPGameConfig *config = [SUDOPGameConfig alloc];
    config.appId = SUDGI_APP_ID;
    config.appKey = SUDGI_APP_KEY;
    config.userId = userId;
    config.userSignatureProvider = ^(NSString * _Nonnull userId, SUDOPUserSignatureCompletion  _Nonnull completion) {
        
        NSDictionary * param = @{@"user_id": userId, @"app_id":Common.shared.selectedGameAppId};
        [SUDDemoHttpService.shared requestUserSignatureWithOptions:param completion:^(NSDictionary * _Nonnull result, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            if (error) {
                completion(nil, error);
                return;
            }
            completion(result[@"user_signature"], nil);
        }];
    };
    
    config.wrappedClientHandler = self.wrappedClientHandler;
    [self.gameContentView showInView:self.view animated:YES];
    [SUDOPGameManager.sharedManager startGameWithGameId:gameID
                                                 config:config
                                               gameView:self.gameContentView.gameView
                                             completion:^(SUDOPGameSession * _Nullable session, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [weakSelf updateBtnStateWithIsLoadedGame:NO];
            return;
        }
            
    }];


}

- (void)destroyCurrentGame {
    [SUDOPGameManager.sharedManager destroyAllGames];
    if (self.gameView) {
        [self.gameView removeFromSuperview];
        self.gameView = nil;
    }
}


- (void)destroyClick:(id)sender {
    [self destroyCurrentGame];
    [self updateBtnStateWithIsLoadedGame:NO];
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:@"landscape_navi_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}


- (SUDDemoGameContainerView *)gameContentView {
    if (!_gameContentView) {
        _gameContentView = [[SUDDemoGameContainerView alloc]init];
        WeakSelf
        _gameContentView.leftActionBlock = ^{
            [weakSelf showGameMore];
        };
        _gameContentView.rightActionBlock = ^{
            [weakSelf destroyClick:nil];
        };
    }
    return _gameContentView;
}

- (void)showGameMore {
    NSString *gameID = self.gameInfo[@"gameId"];
    [SUDOP getGameInformationWithGameID:gameID completion:^(SUDOPGameInformation * _Nullable gameInformation, NSError * _Nullable error) {
        if (error){
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        [self showSheetWithGameInformation:gameInformation];
        NSLog(@"gameInformation:%@", gameInformation.gameDescription);
    }];

}

- (void)restartGame {
    [self startClick:nil];
}

- (void)showGameDetailWithGameInformation:(SUDOPGameInformation *)gameInformation {

    [SUDDemoGameInfoViewController presentFromViewController:self
                                              gameInformation:gameInformation];

}

- (void)showSheetWithGameInformation:(SUDOPGameInformation *)gameInformation {
    
    SUDOPDemoGameInfoSheetView *sheetView = [[SUDOPDemoGameInfoSheetView alloc] init];
    [sheetView setGameIconURLString:gameInformation.gameIcon placeholderImage:nil];
    NSString *gameName = [SUDOPWCKLanguageHelper localizedStringFromDictionary:gameInformation.gameName];
    [sheetView setGameName:gameName];
    [sheetView setCompanyName:gameInformation.subjectName];

    [sheetView setReenterButtonImage:[UIImage imageNamed:@"game_restart"]];
    [sheetView setGameInfoButtonImage:[UIImage imageNamed:@"game_detail"]];
    WeakSelf;
    sheetView.reenterBlock = ^{
        NSLog(@"点击重新进入");
        [weakSelf restartGame];
    };

    sheetView.gameInfoBlock = ^{
        NSLog(@"点击游戏信息");
        [weakSelf showGameDetailWithGameInformation:gameInformation];
    };

    [sheetView showInView:self.view];

}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setBackgroundImage:[self imageWithColor:UIColor.orangeColor] forState:UIControlStateNormal];
        [_startBtn setTitle:@"Start" forState:UIControlStateNormal];
        _startBtn.layer.cornerRadius = 8;
        _startBtn.clipsToBounds = YES;
        [_startBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIButton *)destroyBtn {
    if (!_destroyBtn) {
        _destroyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_destroyBtn setBackgroundImage:[self imageWithColor:UIColor.orangeColor] forState:UIControlStateNormal];
        [_destroyBtn setTitle:@"Destroy" forState:UIControlStateNormal];
        _destroyBtn.layer.cornerRadius = 8;
        _destroyBtn.clipsToBounds = YES;
        [_destroyBtn addTarget:self action:@selector(destroyClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _destroyBtn;
}

@end

