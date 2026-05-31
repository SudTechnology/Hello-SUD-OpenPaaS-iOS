//
//  SUDOPDefaultToast.m
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/13/26.
//

#import "SUDOPWCKToast.h"
#import <Masonry/Masonry.h>

@interface SUDOPWCKToast ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) BOOL maskEnabled;

@end

@implementation SUDOPWCKToast

#pragma mark - Public

+ (instancetype)showLoadingInView:(UIView *)view
                             text:(NSString *)text
                             mask:(BOOL)mask {
    [self hideToastInView:view];
    
    SUDOPWCKToast *toast = [[SUDOPWCKToast alloc] initWithMask:mask];
    [view addSubview:toast];
    
    [toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [toast setupLoadingWithText:text];
    return toast;
}

+ (instancetype)showSuccessInView:(UIView *)view
                             text:(NSString *)text
                             mask:(BOOL)mask {
    return [self showSuccessInView:view text:text image:nil mask:mask];
}

+ (instancetype)showSuccessInView:(UIView *)view
                             text:(NSString *)text
                            image:(UIImage *)image
                             mask:(BOOL)mask {
    [self hideToastInView:view];
    
    SUDOPWCKToast *toast = [[SUDOPWCKToast alloc] initWithMask:mask];
    [view addSubview:toast];
    
    [toast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [toast setupSuccessWithText:text image:image];
    [toast hideAfterDelay:1.5];
    return toast;
}

- (void)hide {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)hideAfterDelay:(NSTimeInterval)delay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

#pragma mark - Init

- (instancetype)initWithMask:(BOOL)mask {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _maskEnabled = mask;
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = self.maskEnabled;
    
    if (!self.maskEnabled) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _contentView.layer.cornerRadius = 12.0;
    _contentView.clipsToBounds = YES;
    _contentView.userInteractionEnabled = YES;
    [self addSubview:_contentView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatorView.hidesWhenStopped = YES;
    [_contentView addSubview:_indicatorView];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.hidden = YES;
    [_contentView addSubview:_iconImageView];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 2;
    [_contentView addSubview:_textLabel];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(131);
        make.height.mas_equalTo(129);
    }];
}

- (void)setupLoadingWithText:(NSString *)text {
    self.textLabel.text = text ?: @"加载中...";
    self.iconImageView.hidden = YES;
    [self.indicatorView startAnimating];
    
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(30);
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(36);
    }];
    
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView).offset(-22);
    }];
}

- (void)setupSuccessWithText:(NSString *)text image:(UIImage *)image {
    [self.indicatorView stopAnimating];
    self.textLabel.text = text ?: @"成功";
    self.iconImageView.hidden = NO;
    self.iconImageView.image = image ?: [self defaultSuccessImage];
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(30);
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(36);
    }];
    
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView).offset(-22);
    }];
}

#pragma mark - Private

+ (void)hideToastInView:(UIView *)view {
    NSMutableArray<UIView *> *targetViews = [NSMutableArray array];
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[SUDOPWCKToast class]]) {
            [targetViews addObject:subView];
        }
    }
    for (UIView *toast in targetViews) {
        [toast removeFromSuperview];
    }
}

- (UIImage *)defaultSuccessImage {
    CGSize size = CGSizeMake(36, 36);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context) {
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 3.0);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        
        CGContextMoveToPoint(context, 8, 19);
        CGContextAddLineToPoint(context, 15, 26);
        CGContextAddLineToPoint(context, 28, 11);
        CGContextStrokePath(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


