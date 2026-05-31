//
//  SUDDemoCapsuleView.m
//  HelloSud-iOS
//
//  Created by kaniel on 5/28/26.
//

#import "SUDDemoCapsuleView.h"
#import <Masonry/Masonry.h>

@interface SUDDemoCapsuleView ()

@property (nonatomic, strong) UIView *backgroundContainerView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *separatorLine;

@end

@implementation SUDDemoCapsuleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    _backgroundContainerView = [[UIView alloc] init];
    _backgroundContainerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85];
    _backgroundContainerView.layer.cornerRadius = 16.0;
    _backgroundContainerView.layer.borderWidth = 0.5;
    _backgroundContainerView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.08].CGColor;
    _backgroundContainerView.clipsToBounds = YES;
    [self addSubview:_backgroundContainerView];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton addTarget:self action:@selector(handleLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainerView addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton addTarget:self action:@selector(handleRightAction) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundContainerView addSubview:_rightButton];
    
    _separatorLine = [[UIView alloc] init];
    _separatorLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.08];
    [_backgroundContainerView addSubview:_separatorLine];
    
    [_backgroundContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.backgroundContainerView);
        make.width.mas_equalTo(24);
        make.right.equalTo(_separatorLine.mas_left).offset(-9);
    }];
    
    [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundContainerView);
        make.centerY.equalTo(self.backgroundContainerView);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(16);
    }];
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.backgroundContainerView);
        make.left.equalTo(_separatorLine.mas_right).offset(9);
        make.width.mas_equalTo(24);
    }];
    
    [self setLeftImage:[self defaultBackImage]];
    [self setRightImage:[self defaultMoreImage]];
}

#pragma mark - Public

- (void)setLeftImage:(UIImage *)image {
    [self.leftButton setImage:image forState:UIControlStateNormal];
}

- (void)setRightImage:(UIImage *)image {
    [self.rightButton setImage:image forState:UIControlStateNormal];
}

#pragma mark - Actions

- (void)handleLeftAction {
    if (self.leftActionBlock) {
        self.leftActionBlock();
    }
}

- (void)handleRightAction {
    if (self.rightActionBlock) {
        self.rightActionBlock();
    }
}

#pragma mark - Default Image

- (UIImage *)defaultBackImage {
    CGSize size = CGSizeMake(12, 12);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context) {
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextSetLineWidth(context, 2.0);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        
        CGContextMoveToPoint(context, 8, 2);
        CGContextAddLineToPoint(context, 3, 6);
        CGContextAddLineToPoint(context, 8, 10);
        CGContextStrokePath(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)defaultMoreImage {
    CGSize size = CGSizeMake(14, 4);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context) {
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        
        CGFloat radius = 1.5;
        NSArray<NSValue *> *points = @[
            [NSValue valueWithCGPoint:CGPointMake(2, 2)],
            [NSValue valueWithCGPoint:CGPointMake(7, 2)],
            [NSValue valueWithCGPoint:CGPointMake(12, 2)]
        ];
        
        for (NSValue *value in points) {
            CGPoint p = value.CGPointValue;
            CGRect rect = CGRectMake(p.x - radius, p.y - radius, radius * 2, radius * 2);
            CGContextFillEllipseInRect(context, rect);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

