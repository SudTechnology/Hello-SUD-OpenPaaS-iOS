//
//  SUDOPDemoGameInfoSheetView.m
//  HelloSud-iOS
//
//  Created by kaniel on 5/30/26.
//

#import "SUDOPDemoGameInfoSheetView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>


@interface SUDOPDemoGameInfoSheetView ()

@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIView *sheetView;

@property (nonatomic, strong) UIView *gameInfoBarView;
@property (nonatomic, strong) UIView *actionContainerView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *gameNameLabel;
@property (nonatomic, strong) UILabel *companyNameLabel;
@property (nonatomic, strong) UIImageView *rightMoreImageView;

@property (nonatomic, strong) UIButton *reenterButton;
@property (nonatomic, strong) UIButton *gameInfoButton;
@property (nonatomic, strong) UILabel *reenterLabel;
@property (nonatomic, strong) UILabel *gameInfoLabel;



@property (nonatomic, strong) MASConstraint *sheetBottomConstraint;

@end

@implementation SUDOPDemoGameInfoSheetView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    _overlayView = [[UIView alloc] init];
    _overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    [self addSubview:_overlayView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOverlayTap)];
    [_overlayView addGestureRecognizer:tap];
    
    _sheetView = [[UIView alloc] init];
    _sheetView.backgroundColor = [self colorWithHexString:@"#F5F6FB"];
    _sheetView.layer.cornerRadius = 12.0;
    _sheetView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    _sheetView.clipsToBounds = YES;
    [self addSubview:_sheetView];
    
    _gameInfoBarView = [[UIView alloc] init];
    _gameInfoBarView.backgroundColor = [UIColor whiteColor];
    [_sheetView addSubview:_gameInfoBarView];
    
    _actionContainerView = [[UIView alloc] init];
    _actionContainerView.backgroundColor = [self colorWithHexString:@"#F5F6FB"];
    [_sheetView addSubview:_actionContainerView];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 6.0;
    [_gameInfoBarView addSubview:_iconImageView];
    
    _gameNameLabel = [[UILabel alloc] init];
    _gameNameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _gameNameLabel.textColor = [self colorWithHexString:@"#303133"];
    _gameNameLabel.numberOfLines = 1;
    [_gameInfoBarView addSubview:_gameNameLabel];
    
    _gameNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGameInfo)];
    [_gameNameLabel addGestureRecognizer:nameTap];
    
    _rightMoreImageView = [[UIImageView alloc] init];
    _rightMoreImageView.image = [UIImage imageNamed:@"right_more"];
    [_gameInfoBarView addSubview:_rightMoreImageView];
    
    
    _companyNameLabel = [[UILabel alloc] init];
    _companyNameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    _companyNameLabel.textColor = [self colorWithHexString:@"#909399"];
    _companyNameLabel.numberOfLines = 1;
    [_gameInfoBarView addSubview:_companyNameLabel];
    
    _reenterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reenterButton.backgroundColor = [UIColor whiteColor];
    _reenterButton.layer.cornerRadius = 12.0;
    [_reenterButton addTarget:self action:@selector(handleReenter) forControlEvents:UIControlEventTouchUpInside];
    [_actionContainerView addSubview:_reenterButton];
    
    _gameInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _gameInfoButton.backgroundColor = [UIColor whiteColor];
    _gameInfoButton.layer.cornerRadius = 12.0;
    [_gameInfoButton addTarget:self action:@selector(handleGameInfo) forControlEvents:UIControlEventTouchUpInside];
    [_actionContainerView addSubview:_gameInfoButton];
    
    _reenterLabel = [[UILabel alloc] init];
    _reenterLabel.text = @"重新进入";
    _reenterLabel.textAlignment = NSTextAlignmentCenter;
    _reenterLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    _reenterLabel.textColor = [self colorWithHexString:@"#303133"];
    [_actionContainerView addSubview:_reenterLabel];
    
    _gameInfoLabel = [[UILabel alloc] init];
    _gameInfoLabel.text = @"游戏信息";
    _gameInfoLabel.textAlignment = NSTextAlignmentCenter;
    _gameInfoLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    _gameInfoLabel.textColor = [self colorWithHexString:@"#303133"];
    [_actionContainerView addSubview:_gameInfoLabel];
    
    [self setupDefaultButtonIcons];
    
    [_overlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_sheetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(230);
        self.sheetBottomConstraint = make.bottom.equalTo(self).offset(230);
    }];
    
    [_gameInfoBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.sheetView);
        make.height.mas_equalTo(72);
    }];
    
    [_actionContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameInfoBarView.mas_bottom);
        make.left.right.bottom.equalTo(self.sheetView);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gameInfoBarView).offset(16);
        make.centerY.equalTo(self.gameInfoBarView);
        make.width.height.mas_equalTo(36);
    }];
    
    [_gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(1);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.width.greaterThanOrEqualTo(@0);
    }];
    
    [_rightMoreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_gameNameLabel.mas_right).offset(1);
        make.width.height.mas_equalTo(8);
        make.centerY.equalTo(_gameNameLabel);
    }];
    
    [_companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.gameNameLabel);
        make.bottom.equalTo(self.iconImageView).offset(-1);
    }];
    
    [_reenterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionContainerView).offset(24);
        make.left.equalTo(self.actionContainerView).offset(16);
        make.width.height.mas_equalTo(56);
    }];
    
    [_gameInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reenterButton);
        make.left.equalTo(self.reenterButton.mas_right).offset(12);
        make.width.height.mas_equalTo(56);
    }];
    
    [_reenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reenterButton.mas_bottom).offset(8);
        make.centerX.equalTo(self.reenterButton);
    }];
    
    [_gameInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameInfoButton.mas_bottom).offset(8);
        make.centerX.equalTo(self.gameInfoButton);
    }];
}

#pragma mark - Public

- (void)setGameIcon:(UIImage *)image {
    self.iconImageView.image = image;
}

- (void)setGameIconURLString:(NSString *)iconURLString placeholderImage:(UIImage *)placeholderImage {
    NSURL *url = [NSURL URLWithString:iconURLString ?: @""];
    [self.iconImageView sd_setImageWithURL:url placeholderImage:placeholderImage];
}

- (void)setGameName:(NSString *)gameName {
    self.gameNameLabel.text = gameName ?: @"";
}

- (void)setCompanyName:(NSString *)companyName {
    self.companyNameLabel.text = companyName ?: @"";
}

- (void)setReenterButtonImage:(UIImage *)image {
    [self.reenterButton setImage:image forState:UIControlStateNormal];
}

- (void)setGameInfoButtonImage:(UIImage *)image {
    [self.gameInfoButton setImage:image forState:UIControlStateNormal];
}

- (void)showInView:(UIView *)superView {
    if (!superView) {
        return;
    }
    
    [superView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    
    [self layoutIfNeeded];
    
    self.overlayView.alpha = 0;
    [self.sheetBottomConstraint uninstall];
    [self.sheetView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.sheetBottomConstraint = make.bottom.equalTo(self).offset(0);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.overlayView.alpha = 1;
        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    [self.sheetBottomConstraint uninstall];
    [self.sheetView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.sheetBottomConstraint = make.bottom.equalTo(self).offset(190);
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.overlayView.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
}

#pragma mark - Actions

- (void)handleOverlayTap {
    [self dismiss];
}

- (void)handleReenter {
    if (self.reenterBlock) {
        self.reenterBlock();
    }
    [self dismiss];
}

- (void)handleGameInfo {
    if (self.gameInfoBlock) {
        self.gameInfoBlock();
    }
    [self dismiss];
}

#pragma mark - Helper

- (void)setupDefaultButtonIcons {
    [self.reenterButton setImage:[self defaultRefreshImage] forState:UIControlStateNormal];
    [self.gameInfoButton setImage:[self defaultInfoImage] forState:UIControlStateNormal];
}

- (UIImage *)defaultRefreshImage {
    CGSize size = CGSizeMake(22, 22);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context) {
        CGContextSetStrokeColorWithColor(context, [self colorWithHexString:@"#303133"].CGColor);
        CGContextSetLineWidth(context, 2.0);
        CGContextSetLineCap(context, kCGLineCapRound);
        
        CGContextAddArc(context, 11, 11, 6, M_PI * 0.2, M_PI * 1.6, 0);
        CGContextStrokePath(context);
        
        CGContextMoveToPoint(context, 15.5, 4.5);
        CGContextAddLineToPoint(context, 18.0, 5.0);
        CGContextAddLineToPoint(context, 17.2, 7.5);
        CGContextStrokePath(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)defaultInfoImage {
    CGSize size = CGSizeMake(22, 22);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context) {
        CGContextSetStrokeColorWithColor(context, [self colorWithHexString:@"#303133"].CGColor);
        CGContextSetLineWidth(context, 1.8);
        
        CGContextStrokeEllipseInRect(context, CGRectMake(3, 3, 16, 16));
        
        CGContextSetFillColorWithColor(context, [self colorWithHexString:@"#303133"].CGColor);
        CGContextFillEllipseInRect(context, CGRectMake(10, 6, 2, 2));
        CGContextFillRect(context, CGRectMake(10.2, 10, 1.6, 5));
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIColor *)colorWithHexString:(NSString *)hexString {
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

@end
