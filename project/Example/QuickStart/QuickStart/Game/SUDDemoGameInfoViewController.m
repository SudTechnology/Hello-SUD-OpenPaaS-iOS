//
//  SUDDemoGameInfoViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 5/30/26.
//



#import "SUDDemoGameInfoViewController.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import <SafariServices/SafariServices.h>

@interface SUDDemoGameInfoViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UILabel *navigationTitleLabel;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *gameNameLabel;
@property (nonatomic, strong) UILabel *companyNameLabel;
@property (nonatomic, strong) UILabel *gameDescriptionLabel;

@property (nonatomic, strong) UILabel *baseInfoTitleLabel;
@property (nonatomic, strong) UIView *baseInfoContentView;

@property (nonatomic, strong) UILabel *privacyTitleLabel;
@property (nonatomic, strong) UITextView *privacyTextView;

@property (nonatomic, strong) UILabel *serviceTitleLabel;
@property (nonatomic, strong) UILabel *serviceContentLabel;

@end

@implementation SUDDemoGameInfoViewController

+ (void)presentFromViewController:(UIViewController *)viewController
                  gameInformation:(SUDOPGameInformation *)gameInformation {
    UIViewController *targetVC = viewController ?: [self sud_topViewController];
    if (!targetVC) {
        return;
    }
    
    SUDDemoGameInfoViewController *vc = [[SUDDemoGameInfoViewController alloc] init];
    vc.gameInformation = gameInformation;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [targetVC presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self refreshUI];
}

#pragma mark - UI

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBarView = [[UIView alloc] init];
    _navigationBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_navigationBarView];
    
    _navigationTitleLabel = [[UILabel alloc] init];
    _navigationTitleLabel.text = @"游戏信息";
    _navigationTitleLabel.textAlignment = NSTextAlignmentCenter;
    _navigationTitleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    _navigationTitleLabel.textColor = [self colorWithHex:@"#303133"];
    [_navigationBarView addSubview:_navigationTitleLabel];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
//    [_closeButton setTitleColor:[self colorWithHex:@"#303133"] forState:UIControlStateNormal];
//    _closeButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    [_closeButton setImage:[UIImage imageNamed:@"navi_back_black"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView addSubview:_closeButton];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:_scrollView];
    
    _containerView = [[UIView alloc] init];
    [_scrollView addSubview:_containerView];
    
    [_navigationBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.height.mas_equalTo(44 + UIApplication.sharedApplication.keyWindow.safeAreaInsets.top);
        } else {
            make.height.mas_equalTo(64);
        }
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationBarView).offset(0);
        make.bottom.equalTo(self.navigationBarView).offset(-10);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(24);
    }];
    
    [_navigationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationBarView);
        make.centerY.equalTo(self.closeButton);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBarView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self setupGameHeaderSection];
    [self setupBaseInfoSection];
    [self setupPrivacySection];
    [self setupServiceSection];
}

- (void)setupGameHeaderSection {
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 8;
    [_containerView addSubview:_iconImageView];
    
    _gameNameLabel = [[UILabel alloc] init];
    _gameNameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    _gameNameLabel.textColor = [self colorWithHex:@"#303133"];
    _gameNameLabel.textAlignment = NSTextAlignmentLeft;
    _gameNameLabel.numberOfLines = 1;
    [_containerView addSubview:_gameNameLabel];
    
    _companyNameLabel = [[UILabel alloc] init];
    _companyNameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    _companyNameLabel.textColor = [self colorWithHex:@"#606266"];
    _companyNameLabel.textAlignment = NSTextAlignmentLeft;
    _companyNameLabel.numberOfLines = 1;
    [_containerView addSubview:_companyNameLabel];
    
    _gameDescriptionLabel = [[UILabel alloc] init];
    _gameDescriptionLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    _gameDescriptionLabel.textColor = [self colorWithHex:@"#303133"];
    _gameDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    _gameDescriptionLabel.numberOfLines = 0;
    [_containerView addSubview:_gameDescriptionLabel];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(16);
        make.top.equalTo(self.containerView).offset(16);
        make.width.height.mas_equalTo(56);
    }];
    
    [_gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
        make.top.equalTo(self.iconImageView).offset(2);
        make.right.equalTo(self.containerView).offset(-16);
    }];
    
    [_companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.gameNameLabel);
        make.bottom.equalTo(self.iconImageView).offset(-2);
    }];
    
    [_gameDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView);
        make.right.equalTo(self.containerView).offset(-16);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(16);
    }];
    
    UIView *line = [self separatorLine];
    [_containerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameDescriptionLabel.mas_bottom).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setupBaseInfoSection {
    _baseInfoTitleLabel = [self sectionTitleLabelWithText:@"基础信息"];
    [_containerView addSubview:_baseInfoTitleLabel];
    
    _baseInfoContentView = [[UIView alloc] init];
    [_containerView addSubview:_baseInfoContentView];
    
    [_baseInfoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameDescriptionLabel.mas_bottom).offset(32);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
    }];
    
    [_baseInfoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseInfoTitleLabel.mas_bottom).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
    }];
    
    NSArray *titles = @[@"认证主体", @"认证类型", @"Game ID", @"游戏分类", @"更新时间", @"客服电话", @"客服邮箱"];
    UIView *lastView = nil;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        leftLabel.textColor = [self colorWithHex:@"#606266"];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.text = titles[i];
        [_baseInfoContentView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        rightLabel.textColor = [self colorWithHex:@"#303133"];
        rightLabel.textAlignment = NSTextAlignmentLeft;
        rightLabel.numberOfLines = 1;
        rightLabel.tag = 1000 + i;
        [_baseInfoContentView addSubview:rightLabel];
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.baseInfoContentView);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(14);
            } else {
                make.top.equalTo(self.baseInfoContentView);
            }
            make.width.mas_equalTo(72);
        }];
        
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.mas_right).offset(16);
            make.right.equalTo(self.baseInfoContentView);
            make.centerY.equalTo(leftLabel);
        }];
        
        lastView = leftLabel;
    }
    
    [self.baseInfoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView);
    }];
    
    UIView *line = [self separatorLine];
    [_containerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseInfoContentView.mas_bottom).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setupPrivacySection {
    _privacyTitleLabel = [self sectionTitleLabelWithText:@"服务隐私"];
    [_containerView addSubview:_privacyTitleLabel];
    
    _privacyTextView = [[UITextView alloc] init];
    _privacyTextView.backgroundColor = [UIColor clearColor];
    _privacyTextView.editable = NO;
    _privacyTextView.scrollEnabled = NO;
    _privacyTextView.delegate = self;
    _privacyTextView.textContainerInset = UIEdgeInsetsZero;
    _privacyTextView.textContainer.lineFragmentPadding = 0;
    [_containerView addSubview:_privacyTextView];
    
    [_privacyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseInfoContentView.mas_bottom).offset(32);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
    }];
    
    [_privacyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.privacyTitleLabel.mas_bottom).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
    }];
    
    UIView *line = [self separatorLine];
    [_containerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.privacyTextView.mas_bottom).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setupServiceSection {
    _serviceTitleLabel = [self sectionTitleLabelWithText:@"服务声明"];
    [_containerView addSubview:_serviceTitleLabel];
    
    _serviceContentLabel = [[UILabel alloc] init];
    _serviceContentLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    _serviceContentLabel.textColor = [self colorWithHex:@"#303133"];
    _serviceContentLabel.textAlignment = NSTextAlignmentLeft;
    _serviceContentLabel.numberOfLines = 0;
    [_containerView addSubview:_serviceContentLabel];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 20;
    style.maximumLineHeight = 20;
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"本服务由开发者向用户提供，开发者对服务信息内容、数据资料及其运营行为等的真实性、合法性及有效性承担全部责任。OpenPaaS向开发者提供技术支持服务。"
                                                               attributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
        NSForegroundColorAttributeName : [self colorWithHex:@"#303133"],
        NSParagraphStyleAttributeName : style
    }];
    _serviceContentLabel.attributedText = attr;
    
    [_serviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.privacyTextView.mas_bottom).offset(32);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
    }];
    
    [_serviceContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serviceTitleLabel.mas_bottom).offset(16);
        make.left.equalTo(self.containerView).offset(16);
        make.right.equalTo(self.containerView).offset(-16);
        make.bottom.equalTo(self.containerView).offset(-24);
    }];
}

#pragma mark - Data

- (void)refreshUI {
    NSString *gameName = [self localizedTextFromMap:self.gameInformation.gameName];
    NSString *gameDescription = [self localizedTextFromMap:self.gameInformation.gameDescription];
    
    self.gameNameLabel.text = gameName;
    self.companyNameLabel.text = self.gameInformation.subjectName ?: @"";
    self.gameDescriptionLabel.text = gameDescription;
    
    if (self.gameInformation.gameIcon.length > 0) {
        NSURL *url = [NSURL URLWithString:self.gameInformation.gameIcon];
        [self.iconImageView sd_setImageWithURL:url placeholderImage:nil];
    }
    
    NSArray *values = @[
        self.gameInformation.subjectName ?: @"",
        [self subjectTypeText:self.gameInformation.subjectType],
        self.gameInformation.gameID ?: @"",
        [self categoryText:self.gameInformation.category],
        [self updateTimeText:self.gameInformation.updateTime],
        self.gameInformation.servicePhone ?: @"",
        self.gameInformation.serviceEmail ?: @""
    ];
    
    for (NSInteger i = 0; i < values.count; i++) {
        UILabel *label = [self.baseInfoContentView viewWithTag:1000 + i];
        if ([label isKindOfClass:[UILabel class]]) {
            label.text = values[i];
        }
    }
    
    [self updatePrivacyText];
}

- (void)updatePrivacyText {
    
    NSString *gameName = [self localizedTextFromMap:self.gameInformation.gameName];
    NSString *linkText = [NSString stringWithFormat:@"《%@的隐私保护指引》", gameName];
    NSString *fullText = [NSString stringWithFormat:@"开发者严格按照%@处理你的个人信息。", linkText];
    NSRange linkRange = [fullText rangeOfString:linkText];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fullText attributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
        NSForegroundColorAttributeName : [self colorWithHex:@"#303133"]
    }];
    
    if (linkRange.location != NSNotFound) {
        [attr addAttributes:@{
            NSLinkAttributeName : self.gameInformation.privacyPolicyUrl ?: @"",
            NSForegroundColorAttributeName : [self colorWithHex:@"#007AFF"]
        } range:linkRange];
    }
    
    self.privacyTextView.linkTextAttributes = @{
        NSForegroundColorAttributeName : [self colorWithHex:@"#007AFF"]
    };
    self.privacyTextView.attributedText = attr;
}

#pragma mark - Action

- (void)handleClose {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView
shouldInteractWithURL:(NSURL *)URL
         inRange:(NSRange)characterRange
     interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)) {
    if (!URL.absoluteString.length) {
        return NO;
    }
    
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:URL];
    [self presentViewController:safariVC animated:YES completion:nil];
    return NO;
}

#pragma mark - Helper

- (UILabel *)sectionTitleLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    label.textColor = [self colorWithHex:@"#303133"];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UIView *)separatorLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [self colorWithHex:@"#E6E7EF"];
    return line;
}

- (UIColor *)colorWithHex:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    if (colorString.length != 6) {
        return [UIColor blackColor];
    }
    
    unsigned int r = 0, g = 0, b = 0;
    [[NSScanner scannerWithString:[colorString substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r];
    [[NSScanner scannerWithString:[colorString substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g];
    [[NSScanner scannerWithString:[colorString substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b];
    
    return [UIColor colorWithRed:r / 255.0
                           green:g / 255.0
                            blue:b / 255.0
                           alpha:1.0];
}

- (NSString *)localizedTextFromMap:(NSDictionary<NSString *, NSString *> *)map {
    if (![map isKindOfClass:[NSDictionary class]] || map.count == 0) {
        return @"";
    }
    
    NSString *language = NSLocale.preferredLanguages.firstObject ?: @"";
    NSString *exact = map[language];
    if (exact.length > 0) {
        return exact;
    }
    
    NSString *prefix = [[language componentsSeparatedByString:@"-"] firstObject];
    if (prefix.length > 0) {
        NSString *prefixValue = map[prefix];
        if (prefixValue.length > 0) {
            return prefixValue;
        }
        
        for (NSString *key in map.allKeys) {
            NSString *keyPrefix = [[key componentsSeparatedByString:@"-"] firstObject];
            if ([keyPrefix isEqualToString:prefix]) {
                NSString *value = map[key];
                if (value.length > 0) {
                    return value;
                }
            }
        }
    }
    
    NSString *defaultValue = map[@"default"];
    if (defaultValue.length > 0) {
        return defaultValue;
    }
    
    return map.allValues.firstObject ?: @"";
}

- (NSString *)subjectTypeText:(NSInteger)subjectType {
    switch (subjectType) {
        case 1:
            return @"个人";
        case 2:
            return @"企业";
        default:
            return @"-";
    }
}

- (NSString *)categoryText:(NSInteger)category {
    NSString *key = [NSString stringWithFormat:@"%ld", (long)category];
    NSDictionary *dicCategory = @{
        @"1":@"角色扮演",
        @"2":@"经营策略",
        @"3":@"休闲益智",
        @"4":@"动作冒险",
        @"5":@"射击游戏",
        @"6":@"体育竞速",
        @"7":@"棋牌游戏",
        @"8":@"音乐舞蹈",
        
    };
    return dicCategory[key] ?: @"-";

}

- (NSString *)updateTimeText:(long long)timestamp {
    if (timestamp <= 0) {
        return @"-";
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:date];
}

+ (UIViewController *)sud_topViewController {
    UIWindow *keyWindow = nil;
    
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) {
                continue;
            }
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            if (windowScene.activationState != UISceneActivationStateForegroundActive) {
                continue;
            }
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    keyWindow = window;
                    break;
                }
            }
            if (keyWindow) {
                break;
            }
        }
    } else {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
    }
    
    return [self sud_topViewControllerFrom:keyWindow.rootViewController];
}

+ (UIViewController *)sud_topViewControllerFrom:(UIViewController *)viewController {
    if (!viewController) {
        return nil;
    }
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self sud_topViewControllerFrom:((UINavigationController *)viewController).topViewController];
    }
    
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self sud_topViewControllerFrom:((UITabBarController *)viewController).selectedViewController];
    }
    
    if (viewController.presentedViewController) {
        return [self sud_topViewControllerFrom:viewController.presentedViewController];
    }
    
    return viewController;
}

@end
