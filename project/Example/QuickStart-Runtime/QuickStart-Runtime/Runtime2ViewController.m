//
//  ViewController.m
//  QuickStart-Runtime
//
//  Created by kaniel on 10/27/25.
//

#import "Runtime2ViewController.h"
#import "QsrCommon.h"

@interface Runtime2ViewController()

<SUDRuntimeGameDrawFrameListener,
SUDRuntimeGameLoadSubpackageListener,
SUDRuntimeGameQueryExitListener,
SUDRuntimeGameStateChangeListener,
SUDRuntimeGameScreenStateChangeListener,
SUDRuntimeGameQueryClipboardListener,
SUDRuntimeGameCustomCommandListener>

@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UIButton *startBtn;
@property(nonatomic, strong)UIButton *destroyBtn;
@property(nonatomic, strong)UIView *gameContentView;
@property(nonatomic, strong)id<SUDRuntimeGameRuntime> runtime;
@property(nonatomic, strong)id<SUDRuntimeGameHandle> gameHandle;
@property(nonatomic, strong)UIView *gameView;
@property(nonatomic, strong)NSDictionary *gameInfo;
@end

@implementation Runtime2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *gamePkgPath = [[NSBundle mainBundle]pathForResource:@"game.creator.cccshooter.13" ofType:@"cpk"];// local path
    //gamePkgPath = @"http://test-runtime.cocos.com/cocos-runtime-demo/cpk/13/game.creator.cccshooter.13.cpk";// or remote url
    self.gameInfo = @{@"gameId": @"sud.tech.test",
                      @"version":@"1.0.0",
                      @"path": gamePkgPath};
    
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
    
    [self destroyClick:nil];
    [[SUD_GIP getCfg] setLogLevel:SudLogDEBUG];
    [SVProgressHUD showWithStatus:@"Login"];
    [SVProgressHUD setMaximumDismissTimeInterval:3];
    
    /// get the code, next initSDK
    [QsrCommon.shared reqGetCode:^(NSString *code) {
        [SVProgressHUD dismiss];
        
        SUDRuntimeInitSDKParamModel *paramModel = [[SUDRuntimeInitSDKParamModel alloc]init];
        paramModel.appId = SUD_GIP_APP_ID;
        paramModel.appKey = SUD_GIP_APP_KEY;
        paramModel.code = code;
        /// Initialize the SDK. Once successful, internal logic ensures it won't be re-initialized.
        [SUDRuntime initSDK:paramModel completion:^(NSError *_Nullable error) {
            if (error) {
                NSLog(@"initSDK result:%@", error.localizedDescription);
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                [self updateBtnStateWithIsLoadedGame:NO];
                return;
            }
            [self handleLoadGame];
        }];
    } fail:^(NSInteger code, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        [self updateBtnStateWithIsLoadedGame:NO];
    }];

}

- (void)handleLoadGame {
    
    SUDRuntimeLoadPackageParamModel *paramModel = SUDRuntimeLoadPackageParamModel.new;
    paramModel.gameId = self.gameInfo[@"gameId"];
    paramModel.version = self.gameInfo[@"version"];
    paramModel.path = self.gameInfo[@"path"];

    [SVProgressHUD showProgress:0 status:@"Loading package"];
    WeakSelf
    // create runtime
    [SUDRuntime createRuntime:nil completion:^(id<SUDRuntimeGameRuntime>  _Nullable runtime, NSError *_Nullable error) {
        weakSelf.runtime = runtime;
        if (error) {
            NSLog(@"createRuntime error:%@", error.localizedDescription);
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        /// load the game package
        [runtime loadPackage:paramModel progress:^(NSInteger progress) {
            NSLog(@"loadGame progress:%@", @(progress));
            [SVProgressHUD showProgress:progress/100.0 status:@"Loading package"];
        } completion:^(NSError * _Nullable error) {
            [SVProgressHUD dismiss];
            NSLog(@"loadGame result:%@", error.localizedDescription);
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                [weakSelf updateBtnStateWithIsLoadedGame:NO];
                return;
            }
            /// run game
            [weakSelf handleRunGame:paramModel];
        }];
    }];

}

- (void)handleRunGame:(SUDRuntimeLoadPackageParamModel *)loadGamePramModel {

    NSString *gameUserId = [NSString stringWithFormat:@"%@", QsrCommon.shared.userId];
    WeakSelf
    [_runtime createGameHandleWithOptions:@{
        SUD_RT_KEY_GAME_USER_ID: gameUserId,
        SUD_RT_KEY_GAME_HTTP_CACHE_LIMIT_STORAGE: @(200),
        SUD_RT_KEY_GAME_HTTP_CACHE_PATH: [NSTemporaryDirectory() stringByAppendingPathComponent:@"http"],
    } completion:^(id<SUDRuntimeGameHandle>  _Nullable handle, NSError * _Nullable error) {
        NSLog(@"createGameHandleWithOptions gameTag:%@， error:%@, gameUserId:%@", loadGamePramModel.gameId, error, gameUserId);
        if (error) {
            [weakSelf updateBtnStateWithIsLoadedGame:NO];
            return;
        }
        [weakSelf destroyCurrentGame];
        weakSelf.gameHandle = handle;
        [weakSelf onGameHandleCreateSuccess:loadGamePramModel];
    }];
}

- (void)onGameHandleCreateSuccess:(SUDRuntimeLoadPackageParamModel *)loadGamePramModel {
    
    /// add gameview
    UIView *gameView = [self.gameHandle getGameView];
    self.gameView = gameView;
    [self.gameContentView addSubview:gameView];
    [gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.gameContentView);
    }];
    
    /// config the game options
    ///
    NSMutableDictionary *_gameOptions = [[NSMutableDictionary alloc]init];
    [_gameOptions setValue:loadGamePramModel.version forKey:SUD_RT_KEY_GAME_START_OPTIONS_GAME_VERSION];
    // Add the application directory to the search path. custom.js is a custom module for app-to-game interaction.
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *customJsPath = [bundlePath stringByAppendingPathComponent:@"custom.js"];
    [_gameOptions setValue:bundlePath
                    forKey:SUD_RT_KEY_GAME_START_OPTIONS_CUSTOM_SEARCH_PATH];
    [_gameOptions setValue:customJsPath
                    forKey:SUD_RT_KEY_GAME_START_OPTIONS_CUSTOM_JS_ENTRY];
#if DEBUG
    [_gameOptions setValue:@(1)
                    forKey:SUD_RT_KEY_GAME_DEBUG_OPTION_ENABLE_V_CONSOLE];
#endif
    [_gameOptions setValue:@(1)
                    forKey:SUD_RT_KEY_GAME_START_OPTIONS_ENABLE_THIRD_SCRIPT];

    NSLog(@"_onGameHandleCreateSuccess:%@", loadGamePramModel.gameId);
    /// 设置相关运行时状态监听
    [_gameHandle setGameDrawFrameListener:self];
    [_gameHandle setCustomCommandListener:self];
    [_gameHandle setGameStateListener:self];

    [_gameHandle setGameStartOptions:loadGamePramModel.gameId
                             options:_gameOptions];

    // create game handler
    [_gameHandle create];
    // start game
    NSData *startData = [NSJSONSerialization dataWithJSONObject:@{@"appId": loadGamePramModel.gameId}
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:nil];
    NSLog(@"_gameHandle start:%@", loadGamePramModel.gameId);
    [_gameHandle start:[[NSString alloc] initWithData:startData encoding:NSUTF8StringEncoding]];
    // play game
    [_gameHandle play];
    
    [self updateBtnStateWithIsLoadedGame:YES];
}

#pragma mark - CRGameStateChangeListener
- (void)onStateChangedFailureFrom:(int)fromState to:(int)toState error:(nonnull NSError *)error {

    NSLog(@"game state change failed: from=%d to=%d error=%@", fromState, toState, error);
}

- (void)onStateChangedFrom:(int)fromState to:(int)toState {
    NSLog(@"onStateChangedFrom:%@->%@", @(fromState), @(toState));
}

/// In-game commands will call back to the native side.
- (void)onCallCustomCommand:(id<SUDRuntimeGameCustomCommandHandle>)handle info:(nullable NSDictionary *)argv {
    NSLog(@"onCallCustomCommand:%@", argv);
}

/// In-game commands will call back to the native side. sync
- (void)onCallCustomCommandSync:(id<SUDRuntimeGameCustomCommandHandle>)handle info:(nullable NSDictionary *)argv {
    NSLog(@"onCallCustomCommandSync:%@", argv);
}

- (void)onDrawFrame:(long)frameCounter {
    NSLog(@"onDrawFrame:%@", @(frameCounter));
    [_gameHandle setGameDrawFrameListener:nil];
}

- (void)destroyCurrentGame {
    if (_gameHandle) {
        [_gameHandle destroy];
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

