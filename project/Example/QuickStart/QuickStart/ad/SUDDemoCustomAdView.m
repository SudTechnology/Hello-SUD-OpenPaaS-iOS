
#import "SUDDemoCustomAdView.h"
#import <Masonry/Masonry.h>

@interface SUDDemoCustomAdView ()

@property (nonatomic, copy) NSString *adUnitId;
@property (nonatomic, assign) BOOL isAdLoaded;
@property (nonatomic, strong) UIView *adContainer;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *adImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *adTagLabel;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, strong) NSDictionary *adData;

@end

@implementation SUDDemoCustomAdView

#pragma mark - Initialization

- (instancetype)initWithAdUnitId:(NSString *)adUnitId {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _adUnitId = [adUnitId copy];
        _isAdLoaded = NO;
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithAdUnitId:@"default_ad_unit"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _adUnitId = @"default_ad_unit";
        _isAdLoaded = NO;
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
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    self.bottomView.hidden = YES;
    self.bottomView.alpha = 0;
    self.bottomView.userInteractionEnabled = YES;
    [self addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 广告容器
    self.adContainer = [[UIView alloc] init];
    self.adContainer.backgroundColor = [UIColor whiteColor];
    self.adContainer.layer.cornerRadius = 12;
    self.adContainer.clipsToBounds = YES;
    self.adContainer.userInteractionEnabled = YES;
    [self.bottomView addSubview:self.adContainer];
    
    // 广告图片区域（先添加，因为其他视图需要参照它）
    self.adImageView = [[UIImageView alloc] init];
    self.adImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.adImageView.clipsToBounds = YES;
    self.adImageView.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.9 alpha:1];
    self.adImageView.userInteractionEnabled = YES;
    [self.adContainer addSubview:self.adImageView];
    
    // 广告标签
    self.adTagLabel = [[UILabel alloc] init];
    self.adTagLabel.text = @"广告";
    self.adTagLabel.font = [UIFont systemFontOfSize:10];
    self.adTagLabel.textColor = [UIColor whiteColor];
    self.adTagLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.adTagLabel.textAlignment = NSTextAlignmentCenter;
    self.adTagLabel.layer.cornerRadius = 4;
    self.adTagLabel.clipsToBounds = YES;
    [self.adContainer addSubview:self.adTagLabel];
    
    // 关闭按钮
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.closeButton setTitle:@"✕" forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.closeButton.tintColor = [UIColor whiteColor];
    self.closeButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.closeButton.layer.cornerRadius = 20;
    self.closeButton.clipsToBounds = YES;
    self.closeButton.userInteractionEnabled = YES;
    [self.closeButton addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
    [self.adContainer addSubview:self.closeButton];
    
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.layer.cornerRadius = 8;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.9 alpha:1];
    self.iconImageView.userInteractionEnabled = YES;
    [self.adContainer addSubview:self.iconImageView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 2;
    [self.adContainer addSubview:self.titleLabel];
    
    // 描述
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.font = [UIFont systemFontOfSize:13];
    self.descriptionLabel.textColor = [UIColor grayColor];
    self.descriptionLabel.numberOfLines = 2;
    [self.adContainer addSubview:self.descriptionLabel];
    
    // 操作按钮
    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.actionButton.backgroundColor = [UIColor systemBlueColor];
    self.actionButton.tintColor = [UIColor whiteColor];
    self.actionButton.layer.cornerRadius = 8;
    self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.actionButton addTarget:self action:@selector(handleAdClick) forControlEvents:UIControlEventTouchUpInside];
    [self.adContainer addSubview:self.actionButton];
    
    // 加载指示器
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.loadingIndicator.hidesWhenStopped = YES;
    self.loadingIndicator.color = [UIColor systemBlueColor];
    [self.adContainer addSubview:self.loadingIndicator];
}

- (void)setupLayout {
    // 广告容器 - 初始约束
    [self.adContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomView);
        make.left.right.equalTo(self.bottomView).inset(24);
    }];
    
    // 广告图片
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.adContainer);
        make.height.mas_equalTo(160);
    }];
    
    // 广告标签
    [self.adTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.adImageView).offset(8);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(16);
    }];
    
    // 关闭按钮 - 参照 adImageView
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adImageView).offset(8);
        make.right.equalTo(self.adImageView).offset(-8);
        make.width.height.mas_equalTo(40);
    }];
    
    // 图标
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adImageView.mas_bottom).offset(12);
        make.left.equalTo(self.adContainer).offset(12);
        make.width.height.mas_equalTo(40);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adImageView.mas_bottom).offset(12);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self.adContainer).offset(-12);
    }];
    
    // 描述
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel);
    }];
    
    // 操作按钮
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).offset(16);
        make.left.right.equalTo(self.adContainer).inset(12);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.adContainer).offset(-16);
    }];
    
    // 加载指示器
    [self.loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.adContainer);
    }];
    
    // 确保关闭按钮在最上层
    [self.adContainer bringSubviewToFront:self.closeButton];
}

#pragma mark - Public Methods

- (void)loadAd {
    if (self.isAdLoaded) {
        return;
    }
    
    [self.loadingIndicator startAnimating];
    self.actionButton.enabled = NO;
    
    // 模拟广告加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingIndicator stopAnimating];
        
        // 随机生成广告内容
        [self generateRandomAdContent];
        self.isAdLoaded = YES;
        self.actionButton.enabled = YES;
        
        if ([self.delegate respondsToSelector:@selector(customAdViewDidLoad:)]) {
            [self.delegate customAdViewDidLoad:self];
        }
    });
}

- (void)showAdFromViewController:(UIViewController *)viewController {
    [self showAdWithFullScreenMode:viewController];
}

- (void)showAdFromViewController:(UIViewController *)viewController atOrigin:(CGPoint)origin {
    [self showAdWithOrigin:viewController origin:origin];
}

- (void)showAdFromViewController:(UIViewController *)viewController withFrame:(CGRect)frame {
    [self showAdWithCustomFrame:viewController frame:frame];
}

#pragma mark - Private Show Methods

// 全屏模式
- (void)showAdWithFullScreenMode:(UIViewController *)viewController {
    if (!self.isAdLoaded) {
        [self loadAd];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf showAdWithFullScreenMode:viewController];
            }
        });
        return;
    }
    
    self.presentingViewController = viewController;
    self.frame = viewController.view.bounds;
    [viewController.view addSubview:self];
    
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.hidden = NO;
    
    [self.adContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomView);
        make.left.right.equalTo(self.bottomView).inset(24);
    }];
    [self layoutIfNeeded];
    
    self.bottomView.alpha = 0;
    self.adContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.alpha = 1;
        self.adContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(customAdViewDidShow:)]) {
            [self.delegate customAdViewDidShow:self];
        }
    }];
}

// 指定位置模式
- (void)showAdWithOrigin:(UIViewController *)viewController origin:(CGPoint)origin {
    if (!self.isAdLoaded) {
        [self loadAd];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf showAdWithOrigin:viewController origin:origin];
            }
        });
        return;
    }
    
    self.presentingViewController = viewController;
    
    // 计算广告容器宽度
    CGFloat containerWidth = viewController.view.bounds.size.width - origin.x - 20;
    CGFloat estimatedHeight = [self calculateAdContainerHeight];
    
    self.frame = CGRectMake(origin.x, origin.y, containerWidth, estimatedHeight);
    [viewController.view addSubview:self];
    
    // 设置bottomView透明，但保持交互
    self.bottomView.backgroundColor = [UIColor clearColor];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.hidden = NO;
    self.bottomView.alpha = 1;
    
    // 重置adContainer约束
    [self.adContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomView);
    }];
    [self layoutIfNeeded];
    
    // 添加阴影效果
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 4;
    
    self.adContainer.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.adContainer.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(customAdViewDidShow:)]) {
            [self.delegate customAdViewDidShow:self];
        }
    }];
}

// 自定义Frame模式
- (void)showAdWithCustomFrame:(UIViewController *)viewController frame:(CGRect)frame {
    if (!self.isAdLoaded) {
        [self loadAd];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf showAdWithCustomFrame:viewController frame:frame];
            }
        });
        return;
    }
    
    self.presentingViewController = viewController;
    self.frame = frame;
    [viewController.view addSubview:self];
    
    self.bottomView.backgroundColor = [UIColor clearColor];
    self.bottomView.userInteractionEnabled = YES;
    self.bottomView.hidden = NO;
    self.bottomView.alpha = 1;
    
    [self.adContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomView);
    }];
    [self layoutIfNeeded];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 4;
    
    self.adContainer.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.adContainer.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(customAdViewDidShow:)]) {
            [self.delegate customAdViewDidShow:self];
        }
    }];
}

- (CGFloat)calculateAdContainerHeight {
    CGFloat imageHeight = 160;
    
    CGFloat titleHeight = [self.titleLabel.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, CGFLOAT_MAX)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName: self.titleLabel.font}
                                                             context:nil].size.height;
    
    CGFloat descHeight = [self.descriptionLabel.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, CGFLOAT_MAX)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName: self.descriptionLabel.font}
                                                                  context:nil].size.height;
    
    CGFloat totalHeight = imageHeight + 12 + 40 + 12 + titleHeight + 4 + descHeight + 16 + 44 + 16;
    return totalHeight;
}

- (void)closeAd {
    [UIView animateWithDuration:0.25 animations:^{
        if (self.bottomView.backgroundColor == [UIColor colorWithWhite:0 alpha:0.85]) {
            self.bottomView.alpha = 0;
        }
        self.adContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        self.bottomView.userInteractionEnabled = YES;
        self.alpha = 1;
        
        if ([self.delegate respondsToSelector:@selector(customAdViewDidClose:)]) {
            [self.delegate customAdViewDidClose:self];
        }
    }];
}

- (void)setAdData:(NSDictionary *)data {
    self.adData = data;
    [self updateUIWithAdData:data];
    self.isAdLoaded = YES;
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
        self.adImageView.backgroundColor = color;
        self.iconImageView.backgroundColor = color;
        self.actionButton.backgroundColor = color;
    }
    
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
    if ([self.delegate respondsToSelector:@selector(customAdViewDidClick:)]) {
        [self.delegate customAdViewDidClick:self];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"您点击了广告，将跳转到详情页"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self closeAd];
    }]];
    
    [self.presentingViewController presentViewController:alert animated:YES completion:nil];
}

- (void)handleClose {
    [self closeAd];
}

@end
