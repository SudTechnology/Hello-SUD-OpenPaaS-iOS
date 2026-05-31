//
//  SUDDemoInterstitialAdView.m
//  HelloSud-iOS
//
//  Created by kaniel on 4/27/26.
//

#import "SUDDemoInterstitialAdView.h"

#import <Masonry/Masonry.h>

@interface SUDDemoInterstitialAdView ()

@property (nonatomic, strong) UIView *adContainerView;
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UILabel *adTitleLabel;
@property (nonatomic, strong) UILabel *adContentLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, assign) BOOL isAdLoaded;
@property (nonatomic, assign) BOOL isShowing;

@end

@implementation SUDDemoInterstitialAdView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI Setup

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 12;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"插屏广告演示";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:titleLabel];
    
    // 状态标签
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"点击「加载广告」开始演示";
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.textColor = [UIColor grayColor];
    self.statusLabel.numberOfLines = 0;
    [self addSubview:self.statusLabel];
    
    // 加载指示器
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.loadingIndicator.hidesWhenStopped = YES;
    self.loadingIndicator.color = [UIColor systemBlueColor];
    [self addSubview:self.loadingIndicator];
    
    // 加载按钮
    UIButton *loadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loadButton setTitle:@"加载广告" forState:UIControlStateNormal];
    loadButton.backgroundColor = [UIColor systemBlueColor];
    loadButton.tintColor = [UIColor whiteColor];
    loadButton.layer.cornerRadius = 8;
    loadButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [loadButton addTarget:self action:@selector(loadAd) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loadButton];
    
    // 显示按钮
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [showButton setTitle:@"显示广告" forState:UIControlStateNormal];
    showButton.backgroundColor = [UIColor systemGreenColor];
    showButton.tintColor = [UIColor whiteColor];
    showButton.layer.cornerRadius = 8;
    showButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [showButton addTarget:self action:@selector(showAdIfReady) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:showButton];
    
    // 使用Masonry布局
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.right.equalTo(self).inset(16);
        make.height.mas_equalTo(24);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(12);
        make.left.right.equalTo(self).inset(16);
    }];
    
    [self.loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [loadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadingIndicator.mas_bottom).offset(16);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self.mas_centerX).offset(-8);
        make.height.mas_equalTo(44);
    }];
    
    [showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadingIndicator.mas_bottom).offset(16);
        make.left.equalTo(self.mas_centerX).offset(8);
        make.right.equalTo(self).offset(-16);
        make.height.mas_equalTo(44);
    }];
    
    // 设置视图自身高度
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200);
    }];
    
    // 初始化广告容器（初始隐藏）
    [self setupAdContainer];
}

- (void)setupAdContainer {
    // 创建广告容器视图（全屏样式）
    self.adContainerView = [[UIView alloc] init];
    self.adContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.95];
    self.adContainerView.hidden = YES;
    self.adContainerView.alpha = 0;
    
    // 广告内容卡片
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    cardView.layer.cornerRadius = 16;
    cardView.layer.masksToBounds = YES;
    [self.adContainerView addSubview:cardView];
    
    // 广告图片
    self.adImageView = [[UIImageView alloc] init];
    self.adImageView.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.9 alpha:1];
    self.adImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.adImageView.clipsToBounds = YES;
    self.adImageView.layer.cornerRadius = 8;
    [cardView addSubview:self.adImageView];
    
    // 广告标题
    self.adTitleLabel = [[UILabel alloc] init];
    self.adTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.adTitleLabel.textColor = [UIColor blackColor];
    self.adTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.adTitleLabel.numberOfLines = 0;
    [cardView addSubview:self.adTitleLabel];
    
    // 广告内容
    self.adContentLabel = [[UILabel alloc] init];
    self.adContentLabel.font = [UIFont systemFontOfSize:14];
    self.adContentLabel.textColor = [UIColor grayColor];
    self.adContentLabel.textAlignment = NSTextAlignmentCenter;
    self.adContentLabel.numberOfLines = 0;
    [cardView addSubview:self.adContentLabel];
    
    // 操作按钮
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.backgroundColor = [UIColor systemBlueColor];
    self.actionButton.tintColor = [UIColor whiteColor];
    self.actionButton.layer.cornerRadius = 8;
    self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.actionButton addTarget:self action:@selector(handleAdClick) forControlEvents:UIControlEventTouchUpInside];
    [cardView addSubview:self.actionButton];
    
    // 关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.closeButton setTitle:@"✕" forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    self.closeButton.tintColor = [UIColor whiteColor];
    self.closeButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.closeButton.layer.cornerRadius = 20;
    self.closeButton.clipsToBounds = YES;
    [self.closeButton addTarget:self action:@selector(dismissAd) forControlEvents:UIControlEventTouchUpInside];
    [self.adContainerView addSubview:self.closeButton];
    
    // 广告容器布局
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.adContainerView);
        make.left.right.equalTo(self.adContainerView).inset(24);
    }];
    
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardView).offset(20);
        make.left.right.equalTo(cardView).inset(20);
        make.height.mas_equalTo(120);
    }];
    
    [self.adTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adImageView.mas_bottom).offset(16);
        make.left.right.equalTo(cardView).inset(20);
    }];
    
    [self.adContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adTitleLabel.mas_bottom).offset(8);
        make.left.right.equalTo(cardView).inset(20);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adContentLabel.mas_bottom).offset(20);
        make.left.right.equalTo(cardView).inset(20);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(cardView).offset(-20);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adContainerView).offset(50);
        make.right.equalTo(self.adContainerView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

#pragma mark - Public Methods

- (void)loadAd {
    if (self.isAdLoaded) {
        self.statusLabel.text = @"广告已加载，可以显示";
        [self showSuccessState];
        return;
    }
    
    [self.loadingIndicator startAnimating];
    self.statusLabel.text = @"正在加载广告...";
    self.backgroundColor = [UIColor whiteColor];
    
    // 模拟网络请求延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingIndicator stopAnimating];
        
        // 随机模拟加载成功或失败
        BOOL success = arc4random_uniform(100) < 85; // 85%成功率
        
        if (success) {
            self.isAdLoaded = YES;
            self.statusLabel.text = @"广告加载成功！点击「显示广告」查看效果";
            [self showSuccessState];
            
            // 随机生成广告内容
            [self generateRandomAdContent];
            
            if ([self.delegate respondsToSelector:@selector(interstitialAdDidLoad:)]) {
                [self.delegate interstitialAdDidLoad:self];
            }
        } else {
            self.isAdLoaded = NO;
            self.statusLabel.text = @"广告加载失败，请重试";
            self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
            
            NSError *error = [NSError errorWithDomain:@"AdDemo" code:1001 userInfo:@{NSLocalizedDescriptionKey: @"网络错误，加载失败"}];
            if ([self.delegate respondsToSelector:@selector(interstitialAdDidFailToLoad:error:)]) {
                [self.delegate interstitialAdDidFailToLoad:self error:error];
            }
        }
    });
}

- (void)showAdFromViewController:(UIViewController *)viewController {
    [self showAdFromViewController:viewController withCompletion:nil];
}

- (void)showAdFromViewController:(UIViewController *)viewController withCompletion:(void(^)(BOOL success))completion {
    if (!self.isAdLoaded || self.isShowing) {
        self.statusLabel.text = @"广告未准备就绪，请先加载";
        if (completion) {
            completion(NO);
        }
        return;
    }
    
    self.isShowing = YES;
    
    // 将广告容器添加到视图控制器的视图上
    self.adContainerView.frame = viewController.view.bounds;
    [viewController.view addSubview:self.adContainerView];
    
    // 动画显示
    self.adContainerView.hidden = NO;
    self.adContainerView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.adContainerView.alpha = 1;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(interstitialAdDidPresent:)]) {
            [self.delegate interstitialAdDidPresent:self];
        }
        if (completion) {
            completion(YES);
        }
    }];
}

- (void)dismissAd {
    [UIView animateWithDuration:0.3 animations:^{
        self.adContainerView.alpha = 0;
    } completion:^(BOOL finished) {
        self.adContainerView.hidden = YES;
        [self.adContainerView removeFromSuperview];
        self.isShowing = NO;
        self.isAdLoaded = NO;
        self.statusLabel.text = @"广告已关闭，可重新加载";
        self.backgroundColor = [UIColor whiteColor];
        
        if ([self.delegate respondsToSelector:@selector(interstitialAdDidDismiss:)]) {
            [self.delegate interstitialAdDidDismiss:self];
        }
    }];
}

- (void)handleAdClick {
    // 模拟广告点击
    self.statusLabel.text = @"点击了广告";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"广告点击"
                                                                   message:@"您点击了广告，这通常会打开外部链接或下载应用"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    
    UIViewController *rootVC = [self getRootViewController];
    [rootVC presentViewController:alert animated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(interstitialAdDidClick:)]) {
        [self.delegate interstitialAdDidClick:self];
    }
    
    // 点击后自动关闭广告（模拟真实广告行为）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissAd];
    });
}

- (void)showAdIfReady {
    UIViewController *rootVC = [self getRootViewController];
    if (rootVC) {
        [self showAdFromViewController:rootVC];
    } else {
        self.statusLabel.text = @"无法获取根视图控制器";
    }
}

#pragma mark - Private Methods

- (void)generateRandomAdContent {
    NSArray *adTitles = @[@"限时特惠", @"热门推荐", @"新品上市", @"精选好物", @"福利来袭"];
    NSArray *adContents = @[
        @"全场商品5折起，立即抢购！",
        @"下载APP即送100元红包",
        @"新品首发，买二送一",
        @"会员专享，双倍积分",
        @"邀请好友，各得50元优惠券"
    ];
    NSArray *actionTexts = @[@"立即抢购", @"查看详情", @"马上领取", @"了解详情", @"去参与"];
    
    NSInteger index = arc4random_uniform(adTitles.count);
    self.adTitleLabel.text = adTitles[index];
    self.adContentLabel.text = adContents[index];
    [self.actionButton setTitle:actionTexts[index] forState:UIControlStateNormal];
    
    // 随机生成渐变色背景
    NSArray *colors = @[
        [UIColor colorWithRed:0.2 green:0.6 blue:0.9 alpha:1],
        [UIColor colorWithRed:0.9 green:0.3 blue:0.5 alpha:1],
        [UIColor colorWithRed:0.3 green:0.8 blue:0.5 alpha:1],
        [UIColor colorWithRed:0.9 green:0.7 blue:0.2 alpha:1],
        [UIColor colorWithRed:0.6 green:0.3 blue:0.8 alpha:1]
    ];
    self.adImageView.backgroundColor = colors[index];
    
    // 添加简单图标文字
    UILabel *iconLabel = [[UILabel alloc] init];
    iconLabel.text = @"AD";
    iconLabel.font = [UIFont boldSystemFontOfSize:24];
    iconLabel.textColor = [UIColor whiteColor];
    iconLabel.textAlignment = NSTextAlignmentCenter;
    [self.adImageView addSubview:iconLabel];
    [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.adImageView);
    }];
}

- (void)showSuccessState {
    self.backgroundColor = [UIColor colorWithRed:0.9 green:1 blue:0.9 alpha:1];
    self.layer.borderColor = [UIColor systemGreenColor].CGColor;
}

- (UIViewController *)getRootViewController {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    
    UIViewController *rootVC = window.rootViewController;
    
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    
    return rootVC;
}

@end
