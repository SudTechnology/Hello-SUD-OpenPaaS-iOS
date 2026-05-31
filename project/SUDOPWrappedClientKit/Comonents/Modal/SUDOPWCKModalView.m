//
//  SUDOPWCKModalView.m
//  AFNetworking
//
//  Created by kaniel on 5/25/26.
//

#import "SUDOPWCKModalView.h"
#import <Masonry/Masonry.h>

@interface SUDOPWCKModalView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *modalOverlayView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) SUDOPWCKModalOptions *options;
@property (nonatomic, copy) void(^cancelBlock)(void);
@property (nonatomic, copy) void(^confirmBlock)(NSString * _Nullable inputText);

@property (nonatomic, strong) MASConstraint *scrollViewHeightConstraint;

@end

@implementation SUDOPWCKModalView

+ (instancetype)showInViewController:(UIViewController *)viewController
                             options:(SUDOPWCKModalOptions *)options
                              cancel:(void (^)(void))cancelBlock
                             confirm:(void (^)(NSString * _Nullable))confirmBlock {
    UIViewController *targetVC = viewController ?: [self sud_topViewController];
    if (!targetVC || !targetVC.view) {
        return nil;
    }
    
    SUDOPWCKModalView *modalView = [[SUDOPWCKModalView alloc] initWithOptions:options];
    modalView.cancelBlock = cancelBlock;
    modalView.confirmBlock = confirmBlock;
    
    [targetVC.view addSubview:modalView];
    [modalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(targetVC.view);
    }];
    
    modalView.alpha = 0;
    modalView.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.25 animations:^{
        modalView.alpha = 1;
        modalView.contentView.transform = CGAffineTransformIdentity;
    }];
    
    return modalView;
}

- (instancetype)initWithOptions:(SUDOPWCKModalOptions *)options {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _options = options ?: [[SUDOPWCKModalOptions alloc] init];
        [self setupUI];
        [self refreshUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    _modalOverlayView = [[UIView alloc] init];
    _modalOverlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:_modalOverlayView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOverlayTap)];
    [_modalOverlayView addGestureRecognizer:tap];
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 16.0;
    _contentView.clipsToBounds = YES;
    [self addSubview:_contentView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    _titleLabel.textColor = [self colorFromHexString:@"#303133" defaultColor:[UIColor blackColor]];
    _titleLabel.numberOfLines = 0;
    [_contentView addSubview:_titleLabel];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.scrollEnabled = NO;
    [_contentView addSubview:_scrollView];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.font = [UIFont systemFontOfSize:16];
    _contentLabel.textColor = [self colorFromHexString:@"#606266" defaultColor:[UIColor colorWithWhite:0.2 alpha:1]];
    _contentLabel.numberOfLines = 0;
    [_scrollView addSubview:_contentLabel];
    
    _textField = [[UITextField alloc] init];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.delegate = self;
    [_contentView addSubview:_textField];
    
    _horizontalLine = [[UIView alloc] init];
    _horizontalLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [_contentView addSubview:_horizontalLine];
    
    _verticalLine = [[UIView alloc] init];
    _verticalLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [_contentView addSubview:_verticalLine];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [_cancelButton addTarget:self action:@selector(handleCancel) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_cancelButton];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [_confirmButton addTarget:self action:@selector(handleConfirm) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_confirmButton];
    
    [_modalOverlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self).offset(32);
        make.right.equalTo(self).offset(-32);
        make.height.mas_lessThanOrEqualTo(460);
    }];
}

- (void)refreshUI {
    NSString *title = self.options.title ?: @"";
    NSString *content = self.options.content ?: @"";
    BOOL showCancel = self.options.showCancel;
    BOOL editable = self.options.editable;
    
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    self.textField.placeholder = self.options.placeholderText ?: @"";
    self.textField.hidden = !editable;
    
    NSString *cancelText = [self safeButtonText:self.options.cancelText defaultText:@"取消"];
    NSString *confirmText = [self safeButtonText:self.options.confirmText defaultText:@"确认"];
    
    [self.cancelButton setTitle:cancelText forState:UIControlStateNormal];
    [self.confirmButton setTitle:confirmText forState:UIControlStateNormal];
    
    UIColor *cancelColor = [self colorFromHexString:self.options.cancelColor defaultColor:[UIColor blackColor]];
    UIColor *confirmColor = [self colorFromHexString:self.options.confirmColor defaultColor:[UIColor systemBlueColor]];
    
    [self.cancelButton setTitleColor:cancelColor forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:confirmColor forState:UIControlStateNormal];
    
    self.cancelButton.hidden = !showCancel;
    self.verticalLine.hidden = !showCancel;
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(32);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        self.scrollViewHeightConstraint = make.height.mas_equalTo(0);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    CGFloat maxContentHeight = 180.0;
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width - 32 * 2 - 20 * 2;
    CGSize fitSize = [self.contentLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    CGFloat finalContentHeight = MIN(ceil(fitSize.height), maxContentHeight);
    
    self.scrollView.scrollEnabled = fitSize.height > maxContentHeight;
    [self.scrollViewHeightConstraint uninstall];
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.scrollViewHeightConstraint = make.height.mas_equalTo(finalContentHeight);
    }];
    
    if (editable) {
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_bottom).offset(16);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.height.mas_equalTo(36);
        }];
        
        [self.horizontalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textField.mas_bottom).offset(32);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    } else {
        [self.horizontalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_bottom).offset(32);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    if (showCancel) {
        [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.horizontalLine.mas_bottom);
            make.left.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(50);
        }];
        
        [self.verticalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.horizontalLine.mas_bottom);
            make.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(0.5);
            make.left.equalTo(self.cancelButton.mas_right);
        }];
        
        [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.horizontalLine.mas_bottom);
            make.left.equalTo(self.verticalLine.mas_right);
            make.right.bottom.equalTo(self.contentView);
            make.width.equalTo(self.cancelButton);
            make.height.mas_equalTo(50);
        }];
    } else {
        [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.horizontalLine.mas_bottom);
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(50);
        }];
    }
}

#pragma mark - Actions

- (void)handleOverlayTap {
    if (self.options.maskClosable) {
        [self hide];
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
}

- (void)handleCancel {
    [self hide];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)handleConfirm {
    NSString *text = self.options.editable ? self.textField.text : nil;
    [self hide];
    if (self.confirmBlock) {
        self.confirmBlock(text);
    }
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Helper

- (NSString *)safeButtonText:(NSString *)text defaultText:(NSString *)defaultText {
    NSString *result = text.length > 0 ? text : defaultText;
    if (result.length > 4) {
        result = [result substringToIndex:4];
    }
    return result;
}

- (UIColor *)colorFromHexString:(NSString *)hexString defaultColor:(UIColor *)defaultColor {
    if (![hexString isKindOfClass:[NSString class]] || hexString.length == 0) {
        return defaultColor;
    }
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    if (colorString.length != 6) {
        return defaultColor;
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



