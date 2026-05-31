//
//  SUDDemoBannerAdView.m
//  HelloSud-iOS
//
//  Created by kaniel on 4/13/26.
//

#import "SUDDemoBannerAdView.h"
#import <Masonry/Masonry.h>

@interface SUDDemoBannerAdView ()

@property (nonatomic, copy) NSString *adUnitId;
@property (nonatomic, assign) BOOL isAdLoaded;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *adTagLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) NSDictionary *adData;

@end

@implementation SUDDemoBannerAdView

#pragma mark - Initialization

- (instancetype)initWithAdUnitId:(NSString *)adUnitId {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _adUnitId = [adUnitId copy];
        _isAdLoaded = NO;
        _showCloseButton = YES;
        _adBackgroundColor = [UIColor whiteColor];
        _titleText = @"限时特惠";
        _descriptionText = @"全场5折起，立即抢购！";
        _buttonText = @"查看详情";
        
        [self setupUI];
        [self setupLayout];
        [self setupGestures];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithAdUnitId:@"default_banner_ad"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _adUnitId = @"default_banner_ad";
        _isAdLoaded = NO;
        _showCloseButton = YES;
        _adBackgroundColor = [UIColor whiteColor];
        
        [self setupUI];
        [self setupLayout];
        [self setupGestures];
    }
    return self;
}

#pragma mark - UI Setup

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 4;
    
    // 广告容器
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = self.adBackgroundColor;
    self.containerView.layer.cornerRadius = 8;
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.borderWidth = 0.5;
    self.containerView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    [self addSubview:self.containerView];
    
    // 广告标签
    self.adTagLabel = [[UILabel alloc] init];
    self.adTagLabel.text = @"广告";
    self.adTagLabel.font = [UIFont systemFontOfSize:9];
    self.adTagLabel.textColor = [UIColor whiteColor];
    self.adTagLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.adTagLabel.textAlignment = NSTextAlignmentCenter;
    self.adTagLabel.layer.cornerRadius = 2;
    self.adTagLabel.clipsToBounds = YES;
    [self.containerView addSubview:self.adTagLabel];
    
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.layer.cornerRadius = 8;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.9 alpha:1];
    [self.containerView addSubview:self.iconImageView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.titleText;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 1;
    [self.containerView addSubview:self.titleLabel];
    
    // 描述
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.text = self.descriptionText;
    self.descriptionLabel.font = [UIFont systemFontOfSize:11];
    self.descriptionLabel.textColor = [UIColor grayColor];
    self.descriptionLabel.numberOfLines = 1;
    [self.containerView addSubview:self.descriptionLabel];
    
    // 操作按钮
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.actionButton setTitle:self.buttonText forState:UIControlStateNormal];
    self.actionButton.backgroundColor = [UIColor systemBlueColor];
    self.actionButton.tintColor = [UIColor whiteColor];
    self.actionButton.layer.cornerRadius = 4;
    self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.actionButton addTarget:self action:@selector(handleAdClick) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.actionButton];
    
    // 关闭按钮
    if (self.showCloseButton) {
        self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.closeButton setTitle:@"✕" forState:UIControlStateNormal];
        self.closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.closeButton.tintColor = [UIColor grayColor];
        self.closeButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        self.closeButton.layer.cornerRadius = 10;
        self.closeButton.clipsToBounds = YES;
        [self.closeButton addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.closeButton];
    }
    
    // 加载指示器
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.loadingIndicator.hidesWhenStopped = YES;
    self.loadingIndicator.color = [UIColor systemBlueColor];
    [self.containerView addSubview:self.loadingIndicator];
}

- (void)setupLayout {
    // 容器约束
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(70);
    }];
    
    // 广告标签
    [self.adTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.containerView).offset(4);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(12);
    }];
    
    // 关闭按钮
    if (self.closeButton) {
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView).offset(4);
            make.right.equalTo(self.containerView).offset(-4);
            make.width.height.mas_equalTo(20);
        }];
    }
    
    // 图标
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(12);
        make.centerY.equalTo(self.containerView);
        make.width.height.mas_equalTo(50);
    }];
    
    // 操作按钮
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView).offset(-12);
        make.centerY.equalTo(self.containerView);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(32);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(4);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self.actionButton.mas_left).offset(-10);
    }];
    
    // 描述
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel);
    }];
    
    // 加载指示器
    [self.loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.containerView);
    }];
}

- (void)setupGestures {
    // 点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAdClick)];
    [self.containerView addGestureRecognizer:tap];
}

#pragma mark - Public Methods

- (void)loadAd {
    if (self.isAdLoaded) {
        return;
    }
    
    [self.loadingIndicator startAnimating];
    self.containerView.alpha = 0.6;
    
    // 模拟广告加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingIndicator stopAnimating];
        
        // 随机生成广告内容
        [self generateRandomAdContent];
        self.isAdLoaded = YES;
        self.containerView.alpha = 1;
        
        // 添加图标文字
        [self addIconText];
        
        if ([self.delegate respondsToSelector:@selector(bannerAdViewDidLoad:)]) {
            [self.delegate bannerAdViewDidLoad:self];
        }
    });
}

- (void)showInView:(UIView *)parentView {
    [self showInView:parentView atPosition:CGPointMake(0, 0) size:CGSizeMake(0, 0)];
}

- (void)showInView:(UIView *)parentView atPosition:(CGPoint)position size:(CGSize)size {
    [parentView addSubview:self];
    CGFloat width = size.width;
    CGFloat height = size.height;
    if (width == 0) {
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(parentView).offset(position.x);
            make.top.equalTo(parentView).offset(position.y);
            make.right.equalTo(parentView).offset(-position.x);
            make.height.equalTo(@(height));
        }];
    } else {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(parentView).offset(position.x);
            make.top.equalTo(parentView).offset(position.y);
            make.width.equalTo(@(width));
            make.height.equalTo(@(height));
        }];
    }
    
    if (!self.isAdLoaded) {
        [self loadAd];
    }
    
    // 添加动画效果
    self.transform = CGAffineTransformMakeTranslation(0, -30);
    self.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(bannerAdViewDidShow:)]) {
            [self.delegate bannerAdViewDidShow:self];
        }
    }];
}

- (void)closeAd {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeTranslation(0, -20);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if ([self.delegate respondsToSelector:@selector(bannerAdViewDidClose:)]) {
            [self.delegate bannerAdViewDidClose:self];
        }
    }];
}

- (void)setAdData:(NSDictionary *)data {
    self.adData = data;
    [self updateUIWithAdData:data];
    self.isAdLoaded = YES;
}

- (void)setAdBackgroundColor:(UIColor *)adBackgroundColor {
    _adBackgroundColor = adBackgroundColor;
    self.containerView.backgroundColor = adBackgroundColor;
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (void)setDescriptionText:(NSString *)descriptionText {
    _descriptionText = descriptionText;
    self.descriptionLabel.text = descriptionText;
}

- (void)setButtonText:(NSString *)buttonText {
    _buttonText = buttonText;
    [self.actionButton setTitle:buttonText forState:UIControlStateNormal];
}

- (void)setIconImage:(id)iconImage {
    _iconImage = iconImage;
    
    if ([iconImage isKindOfClass:[UIImage class]]) {
        self.iconImageView.image = iconImage;
    } else if ([iconImage isKindOfClass:[NSString class]]) {
        // 如果是URL字符串，可以在这里进行网络图片加载
        // 示例中使用本地图片占位
        self.iconImageView.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.9 alpha:1];
    }
}

#pragma mark - Private Methods

- (void)generateRandomAdContent {
    NSArray *titles = @[
        @"🔥 限时特惠",
        @"📱 热门推荐",
        @"🎁 新人福利",
        @"💰 现金红包",
        @"⭐️ 精选好物"
    ];
    
    NSArray *descriptions = @[
        @"全场商品5折起，立即抢购！",
        @"下载APP即送100元红包",
        @"注册即送50元优惠券",
        @"邀请好友得20元现金",
        @"会员专享8折优惠"
    ];
    
    NSArray *buttonTexts = @[@"立即抢购", @"免费下载", @"立即领取", @"邀请好友", @"开通会员"];
    NSArray *colors = @[
        [UIColor colorWithRed:0.2 green:0.6 blue:0.9 alpha:1],
        [UIColor colorWithRed:0.9 green:0.3 blue:0.5 alpha:1],
        [UIColor colorWithRed:0.3 green:0.8 blue:0.5 alpha:1],
        [UIColor colorWithRed:0.9 green:0.7 blue:0.2 alpha:1],
        [UIColor colorWithRed:0.6 green:0.3 blue:0.8 alpha:1]
    ];
    
    NSInteger index = arc4random_uniform(titles.count);
    
    NSDictionary *data = @{
        @"title": titles[index],
        @"description": descriptions[index],
        @"buttonText": buttonTexts[index],
        @"color": colors[index]
    };
    
    [self updateUIWithAdData:data];
}

- (void)updateUIWithAdData:(NSDictionary *)data {
    self.titleLabel.text = data[@"title"];
    self.descriptionLabel.text = data[@"description"];
    [self.actionButton setTitle:data[@"buttonText"] forState:UIControlStateNormal];
    
    UIColor *color = data[@"color"];
    if (color) {
        self.iconImageView.backgroundColor = color;
        self.actionButton.backgroundColor = color;
    }
}

- (void)addIconText {
    // 给图标添加文字
    for (UIView *subview in self.iconImageView.subviews) {
        [subview removeFromSuperview];
    }
    
    UILabel *iconText = [[UILabel alloc] init];
    iconText.text = @"广\n告";
    iconText.numberOfLines = 2;
    iconText.font = [UIFont boldSystemFontOfSize:12];
    iconText.textColor = [UIColor whiteColor];
    iconText.textAlignment = NSTextAlignmentCenter;
    [self.iconImageView addSubview:iconText];
    
    [iconText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.iconImageView);
    }];
}

- (void)handleAdClick {
    if ([self.delegate respondsToSelector:@selector(bannerAdViewDidClick:)]) {
        [self.delegate bannerAdViewDidClick:self];
    }
    
    // 模拟点击跳转
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"广告点击"
                                                                   message:[NSString stringWithFormat:@"您点击了「%@」广告", self.titleLabel.text]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    
    UIViewController *rootVC = [self getRootViewController];
    [rootVC presentViewController:alert animated:YES completion:nil];
}

- (void)handleClose {
    [self closeAd];
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

