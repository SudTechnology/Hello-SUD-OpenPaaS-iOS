//
//  SUDDemoRewardedVideoAdView.m
//  HelloSud-iOS
//
//  Created by kaniel on 4/29/26.
//

#import "SUDDemoRewardedVideoAdView.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>

@interface SUDDemoRewardedVideoAdView ()

@property (nonatomic, copy) NSString *adUnitId;
@property (nonatomic, assign) BOOL isAdLoaded;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *videoContainer;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *adTagLabel;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, strong) NSDictionary *adData;
@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, assign) NSInteger remainingSeconds;
@property (nonatomic, assign) BOOL hasRewarded;
@property (nonatomic, copy) void(^rewardCompletionBlock)(void);

@end

@implementation SUDDemoRewardedVideoAdView

#pragma mark - Initialization

- (instancetype)initWithAdUnitId:(NSString *)adUnitId {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _adUnitId = [adUnitId copy];
        _isAdLoaded = NO;
        _isPlaying = NO;
        _hasRewarded = NO;
        _remainingSeconds = 15; // 默认15秒视频
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithAdUnitId:@"default_rewarded_ad"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _adUnitId = @"default_rewarded_ad";
        _isAdLoaded = NO;
        _isPlaying = NO;
        _hasRewarded = NO;
        _remainingSeconds = 15;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - UI Setup

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    // 全屏遮罩
    self.coverView = [[UIView alloc] init];
    self.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.95];
    self.coverView.hidden = YES;
    self.coverView.alpha = 0;
    self.coverView.userInteractionEnabled = YES;
    [self addSubview:self.coverView];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 视频容器
    self.videoContainer = [[UIView alloc] init];
    self.videoContainer.backgroundColor = [UIColor blackColor];
    self.videoContainer.layer.cornerRadius = 16;
    self.videoContainer.clipsToBounds = YES;
    self.videoContainer.userInteractionEnabled = YES;
    [self.coverView addSubview:self.videoContainer];
    
    // 封面图片（模拟视频画面）
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.backgroundColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.5 alpha:1];
    self.coverImageView.userInteractionEnabled = YES;
    [self.videoContainer addSubview:self.coverImageView];
    
    // 广告标签
    self.adTagLabel = [[UILabel alloc] init];
    self.adTagLabel.text = @"激励视频广告";
    self.adTagLabel.font = [UIFont systemFontOfSize:12];
    self.adTagLabel.textColor = [UIColor whiteColor];
    self.adTagLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.adTagLabel.textAlignment = NSTextAlignmentCenter;
    self.adTagLabel.layer.cornerRadius = 4;
    self.adTagLabel.clipsToBounds = YES;
    [self.videoContainer addSubview:self.adTagLabel];
    
    // 倒计时标签
    self.countdownLabel = [[UILabel alloc] init];
    self.countdownLabel.font = [UIFont boldSystemFontOfSize:24];
    self.countdownLabel.textColor = [UIColor whiteColor];
    self.countdownLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.countdownLabel.textAlignment = NSTextAlignmentCenter;
    self.countdownLabel.layer.cornerRadius = 30;
    self.countdownLabel.clipsToBounds = YES;
    self.countdownLabel.hidden = YES;
    [self.videoContainer addSubview:self.countdownLabel];
    
    // 进度条
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressTintColor = [UIColor systemGreenColor];
    self.progressView.trackTintColor = [UIColor colorWithWhite:0.3 alpha:1];
    self.progressView.hidden = YES;
    [self.videoContainer addSubview:self.progressView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.videoContainer addSubview:self.titleLabel];
    
    // 描述
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.font = [UIFont systemFontOfSize:14];
    self.descriptionLabel.textColor = [UIColor lightGrayColor];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.videoContainer addSubview:self.descriptionLabel];
    
    // 操作按钮（观看/领取）
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.backgroundColor = [UIColor systemGreenColor];
    self.actionButton.tintColor = [UIColor whiteColor];
    self.actionButton.layer.cornerRadius = 25;
    self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.actionButton setTitle:@"观看视频领奖励" forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(handleActionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoContainer addSubview:self.actionButton];
    
    // 关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.closeButton setTitle:@"✕" forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    self.closeButton.tintColor = [UIColor whiteColor];
    self.closeButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.closeButton.layer.cornerRadius = 25;
    self.closeButton.clipsToBounds = YES;
    self.closeButton.userInteractionEnabled = YES;
    [self.closeButton addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
    [self.coverView addSubview:self.closeButton];
    
    // 加载指示器
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.loadingIndicator.hidesWhenStopped = YES;
    self.loadingIndicator.color = [UIColor whiteColor];
    [self.videoContainer addSubview:self.loadingIndicator];
}

- (void)setupLayout {
    // 视频容器
    [self.videoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverView);
        make.left.right.equalTo(self.coverView).inset(20);
        make.height.mas_equalTo(450);
    }];
    
    // 封面图片
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.videoContainer);
    }];
    
    // 广告标签
    [self.adTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.videoContainer).offset(12);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(24);
    }];
    
    // 倒计时标签
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoContainer);
        make.width.height.mas_equalTo(60);
    }];
    
    // 进度条
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoContainer).offset(-100);
        make.left.right.equalTo(self.videoContainer).inset(20);
        make.height.mas_equalTo(4);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.progressView.mas_top).offset(-20);
        make.left.right.equalTo(self.videoContainer).inset(20);
    }];
    
    // 描述
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLabel.mas_top).offset(-8);
        make.left.right.equalTo(self.videoContainer).inset(20);
    }];
    
    // 操作按钮
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoContainer).offset(-30);
        make.left.right.equalTo(self.videoContainer).inset(40);
        make.height.mas_equalTo(50);
    }];
    
    // 关闭按钮
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverView).offset(50);
        make.right.equalTo(self.coverView).offset(-20);
        make.width.height.mas_equalTo(50);
    }];
    
    // 加载指示器
    [self.loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoContainer);
    }];
}

#pragma mark - Public Methods

- (void)loadAd {
    if (self.isAdLoaded) {
        return;
    }
    
    [self.loadingIndicator startAnimating];
    
    // 模拟广告加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingIndicator stopAnimating];
        
        // 随机生成广告内容
        [self generateRandomAdContent];
        self.isAdLoaded = YES;
        
        if ([self.delegate respondsToSelector:@selector(rewardedVideoAdDidLoad:)]) {
            [self.delegate rewardedVideoAdDidLoad:self];
        }
    });
}

- (void)showAdFromViewController:(UIViewController *)viewController {
    [self showAdFromViewController:viewController rewardCompletion:nil];
}

- (void)showAdFromViewController:(UIViewController *)viewController
                rewardCompletion:(void(^)(void))rewardCompletion {
    if (!self.isAdLoaded) {
        [self loadAd];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.rewardCompletionBlock = rewardCompletion;
                [strongSelf showAdWithViewController:viewController];
            }
        });
        return;
    }
    
    self.rewardCompletionBlock = rewardCompletion;
    [self showAdWithViewController:viewController];
}

- (void)showAdWithViewController:(UIViewController *)viewController {
    self.presentingViewController = viewController;
    self.frame = viewController.view.bounds;
    [viewController.view addSubview:self];
    
    self.coverView.hidden = NO;
    self.coverView.alpha = 0;
    self.videoContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.alpha = 1;
        self.videoContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.isPlaying = YES;
        [self startVideoPlayback];
        
        if ([self.delegate respondsToSelector:@selector(rewardedVideoAdDidShow:)]) {
            [self.delegate rewardedVideoAdDidShow:self];
        }
    }];
}

- (void)closeAd {
    [self stopCountdownTimer];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 0;
        self.videoContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.isPlaying = NO;
        
        if ([self.delegate respondsToSelector:@selector(rewardedVideoAdDidClose:isRewarded:)]) {
            [self.delegate rewardedVideoAdDidClose:self isRewarded:self.hasRewarded];
        }
    }];
}

- (void)destroy {
    [self stopCountdownTimer];
    [self removeFromSuperview];
    self.isAdLoaded = NO;
    self.isPlaying = NO;
    self.hasRewarded = NO;
}

- (void)setAdData:(NSDictionary *)data {
    self.adData = data;
    [self updateUIWithAdData:data];
    self.isAdLoaded = YES;
}

#pragma mark - Video Playback Simulation

- (void)startVideoPlayback {
    self.remainingSeconds = 15;
    self.hasRewarded = NO;
    self.countdownLabel.hidden = NO;
    self.progressView.hidden = NO;
    self.progressView.progress = 0;
    
    // 更新按钮文字
    [self.actionButton setTitle:[NSString stringWithFormat:@"观看视频 (%ld秒)", (long)self.remainingSeconds] forState:UIControlStateNormal];
    self.actionButton.backgroundColor = [UIColor systemOrangeColor];
    self.actionButton.enabled = NO;
    
    // 显示倒计时
    [self updateCountdownDisplay];
    
    // 启动倒计时
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(updateCountdown)
                                                         userInfo:nil
                                                          repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.countdownTimer forMode:NSRunLoopCommonModes];
    
    // 模拟视频动画效果（封面图片闪烁）
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        self.coverImageView.alpha = 0.7;
    } completion:nil];
}

- (void)updateCountdown {
    self.remainingSeconds--;
    
    // 更新进度条
    float progress = (15.0 - self.remainingSeconds) / 15.0;
    [self.progressView setProgress:progress animated:YES];
    
    [self updateCountdownDisplay];
    
    if (self.remainingSeconds > 0) {
        [self.actionButton setTitle:[NSString stringWithFormat:@"观看视频 (%ld秒)", (long)self.remainingSeconds] forState:UIControlStateNormal];
    } else if (self.remainingSeconds == 0) {
        // 视频播放完成，可以发放奖励
        [self stopCountdownTimer];
        self.countdownLabel.hidden = YES;
        self.progressView.hidden = YES;
        self.hasRewarded = YES;
        
        // 更新按钮
        [self.actionButton setTitle:@"领取奖励" forState:UIControlStateNormal];
        self.actionButton.backgroundColor = [UIColor systemGreenColor];
        self.actionButton.enabled = YES;
        
        // 停止动画
        [self.coverImageView.layer removeAllAnimations];
        self.coverImageView.alpha = 1;
        
        // 显示完成效果
        [self showRewardAvailableEffect];
    }
}

- (void)updateCountdownDisplay {
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld", (long)self.remainingSeconds];
    
    // 倒计时动画
    self.countdownLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.3 animations:^{
        self.countdownLabel.transform = CGAffineTransformIdentity;
    }];
}

- (void)showRewardAvailableEffect {
    // 显示获得奖励的提示
    UILabel *rewardLabel = [[UILabel alloc] init];
    rewardLabel.text = @"🎉 获得奖励 🎉";
    rewardLabel.font = [UIFont boldSystemFontOfSize:20];
    rewardLabel.textColor = [UIColor whiteColor];
    rewardLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    rewardLabel.textAlignment = NSTextAlignmentCenter;
    rewardLabel.layer.cornerRadius = 10;
    rewardLabel.clipsToBounds = YES;
    [self.videoContainer addSubview:rewardLabel];
    
    [rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoContainer);
        make.left.right.equalTo(self.videoContainer).inset(40);
        make.height.mas_equalTo(50);
    }];
    
    rewardLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
    rewardLabel.alpha = 0;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
        rewardLabel.transform = CGAffineTransformIdentity;
        rewardLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1.5 options:0 animations:^{
            rewardLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [rewardLabel removeFromSuperview];
        }];
    }];
}

- (void)stopCountdownTimer {
    if (self.countdownTimer) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
    }
    [self.coverImageView.layer removeAllAnimations];
    self.coverImageView.alpha = 1;
}

#pragma mark - Actions

- (void)handleActionClick {
    if ([self.delegate respondsToSelector:@selector(rewardedVideoAdDidClick:)]) {
        [self.delegate rewardedVideoAdDidClick:self];
    }
    
    if (self.hasRewarded) {
        // 发放奖励
        if (self.rewardCompletionBlock) {
            self.rewardCompletionBlock();
        }
        
        // 显示领取成功提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"领取成功"
                                                                       message:@"恭喜您获得奖励！"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self closeAd];
        }]];
        [self.presentingViewController presentViewController:alert animated:YES completion:nil];
    } else {
        // 提示继续观看
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:[NSString stringWithFormat:@"请完整观看视频后领取奖励\n还剩 %ld 秒", (long)self.remainingSeconds]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续观看" style:UIAlertActionStyleDefault handler:nil]];
        [self.presentingViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)handleClose {
    if (self.hasRewarded) {
        // 已获得奖励，直接关闭
        [self closeAd];
    } else {
        // 未获得奖励，提示确认
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"关闭视频将无法获得奖励，确定要关闭吗？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续观看" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定关闭" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self closeAd];
        }]];
        [self.presentingViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Private Methods

- (void)generateRandomAdContent {
    NSArray *titles = @[
        @"🎬 观看视频领100金币",
        @"🎁 双倍奖励限时活动",
        @"💎 稀有道具免费送",
        @"✨ 观看得VIP体验卡",
        @"⭐️ 限定皮肤等你拿"
    ];
    
    NSArray *descriptions = @[
        @"完整观看视频即可获得100金币奖励",
        @"活动期间观看视频可获得双倍奖励",
        @"观看视频随机获得稀有游戏道具",
        @"累计观看可得VIP体验卡",
        @"观看视频有机会获得限定皮肤"
    ];
    
    NSInteger index = arc4random_uniform(titles.count);
    
    NSDictionary *data = @{
        @"title": titles[index],
        @"description": descriptions[index],
        @"reward": @(100 + arc4random_uniform(900)),
        @"duration": @15
    };
    
    [self updateUIWithAdData:data];
}

- (void)updateUIWithAdData:(NSDictionary *)data {
    self.titleLabel.text = data[@"title"];
    self.descriptionLabel.text = data[@"description"];
    
    // 设置封面图片颜色
    NSArray *colors = @[
        [UIColor colorWithRed:0.2 green:0.3 blue:0.5 alpha:1],
        [UIColor colorWithRed:0.5 green:0.2 blue:0.3 alpha:1],
        [UIColor colorWithRed:0.2 green:0.5 blue:0.3 alpha:1],
        [UIColor colorWithRed:0.5 green:0.4 blue:0.2 alpha:1],
        [UIColor colorWithRed:0.4 green:0.2 blue:0.5 alpha:1]
    ];
    NSInteger index = arc4random_uniform(colors.count);
    self.coverImageView.backgroundColor = colors[index];
    
    // 添加封面文字
    for (UIView *subview in self.coverImageView.subviews) {
        [subview removeFromSuperview];
    }
    
    UILabel *coverText = [[UILabel alloc] init];
    coverText.text = @"🎬";
    coverText.font = [UIFont systemFontOfSize:60];
    coverText.textAlignment = NSTextAlignmentCenter;
    coverText.textColor = [UIColor whiteColor];
    [self.coverImageView addSubview:coverText];
    
    [coverText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverImageView);
    }];
}

@end
