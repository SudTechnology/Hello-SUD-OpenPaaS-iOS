//
//  ViewController.m
//  QuickStart-Runtime
//
//  Created by kaniel on 10/27/25.
//

#import "QuickStartViewController.h"
#import "QsrCommon.h"
#import "WrappedClientHandler.h"
@interface QuickStartViewController()

<SUDRTGameDrawFrameListener,
SUDRTGameLoadSubpackageListener,
SUDRTGameQueryExitListener,
SUDRTGameStateChangeListener,
SUDRTGameScreenStateChangeListener,
SUDRTGameQueryAudioOptionsListener,
SUDRTGameQueryClipboardListener,
SUDRuntimeMediaPlayerListener,
SUDRTGameCustomCommandListener>

@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UIButton *startBtn;
@property(nonatomic, strong)UIButton *destroyBtn;
@property(nonatomic, strong)UIView *gameContentView;
@property(nonatomic, strong)id<SUDRTGameHandle> gameHandle;
@property(nonatomic, strong)UIView *gameView;
@property(nonatomic, strong)NSDictionary *gameInfo;
@property(nonatomic, strong)WrappedClientHandler *wrappedClientHandler;
@end

@implementation QuickStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 2 by gameId, contact SUD about how to getting gameId
    self.gameInfo = @{@"gameId": @"2017065825404788738",
                      @"version":@"1.0.0"};
    
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(self.view.frame.size.width/2., self.view.frame.size.height/2.)];
    self.view.backgroundColor = UIColor.redColor;
    
    [self.view addSubview:self.gameContentView];
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
    
    [self.gameContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self updateBtnStateWithIsLoadedGame:NO];
}

- (WrappedClientHandler *)wrappedClientHandler {
    if (!_wrappedClientHandler) {
        _wrappedClientHandler = [[WrappedClientHandler alloc]init];
    }
    return _wrappedClientHandler;
}


- (void)backClick:(id)sender {
    [self.gameHandle destroy];
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
    [QsrCommon.shared requestUserSignatureWithUserId:QsrCommon.shared.userId completion:^(NSString * _Nonnull userSignature, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.debugDescription];
            return;
        }
        SUDOPSDKConfiguration *configuration = [[SUDOPSDKConfiguration alloc]init];
        configuration.appId = SUDGI_APP_ID;
        configuration.appKey = SUDGI_APP_KEY;
        /// 初始化SDK
        [SUDOP initializeWithConfiguration:configuration completion:^(NSError *_Nullable error) {
            NSLog(@"initSDK result:%@", error);
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                [weakSelf updateBtnStateWithIsLoadedGame:NO];
                return;
            }
            /// 授权
            [SUDOP authWithUserSignature:userSignature completion:^(NSError * _Nullable error) {
                if (error) {
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                    [weakSelf updateBtnStateWithIsLoadedGame:NO];
                    return;
                }
                [weakSelf handleRunGame];
            }];

        }];
    }];


}


- (void)handleRunGame {

    NSString *gameID = @"2049100752121937922";
    
    [SVProgressHUD showProgress:0 status:@"加载游戏"];
    
    WeakSelf

    [SUDOP startGame:gameID didGameHandleCreated:^(id<SUDRTGameHandle>  _Nonnull gameHandle) {
        weakSelf.wrappedClientHandler.gameContentView = weakSelf.gameContentView;
        [SUDOP registerWrappedClientWithGameHandle:gameHandle clientDelegate:weakSelf.wrappedClientHandler];
    } completion:^(id<SUDOPGameHandleProvider>  _Nullable gameHandleProvider, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (error) {
            NSLog(@"createRuntime error:%@", error);
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        [weakSelf destroyCurrentGame];
        /// 运行游戏
        weakSelf.gameHandle = gameHandleProvider.gameHandle;
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        
        [weakSelf onGameHandleCreateSuccess];
    }];
}

- (void)onGameHandleCreateSuccess {

    UIView *gameView = [self.gameHandle getGameView];
    self.gameView = gameView;
    [self.gameContentView addSubview:gameView];
    [gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.gameContentView);
    }];

    [self updateBtnStateWithIsLoadedGame:YES];
}



- (void)destroyCurrentGame {
    if (_gameHandle) {
        [_gameHandle destroy];
        _gameHandle = nil;
    }
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

- (UIView *)gameContentView {
    if (!_gameContentView) {
        _gameContentView = [[UIView alloc]init];
    }
    return _gameContentView;
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

