//
//  SUDDemoGameContainerView.m
//  HelloSud-iOS
//
//  Created by kaniel on 5/28/26.
//

#import "SUDDemoGameContainerView.h"
#import "SUDDemoCapsuleView.h"
#import <Masonry/Masonry.h>
#import "SUDOPDemoGameInfoSheetView.h"

@interface SUDDemoGameContainerView ()

@property (nonatomic, strong, readwrite) SUDDemoCapsuleView *capsuleView;
@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong, readwrite) UIView *gameView;
@property (nonatomic, strong) UIView *gameContentView;


@end

@implementation SUDDemoGameContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _gameView = [[UIView alloc] init];
    [self addSubview:_gameView];
    
    _capsuleView = [[SUDDemoCapsuleView alloc] init];
    [self addSubview:_capsuleView];
    [_capsuleView setLeftImage:[UIImage imageNamed:@"game_more"]];
    [_capsuleView setRightImage:[UIImage imageNamed:@"game_exit"]];
    __weak typeof(self) weakSelf = self;
    _capsuleView.leftActionBlock = ^{
        // 这里你可以按需要做返回逻辑，当前默认留空
        if (weakSelf.leftActionBlock) {
            weakSelf.leftActionBlock();
        }
    };
    
    _capsuleView.rightActionBlock = ^{
        [weakSelf dismissAnimated:YES];
        if (weakSelf.rightActionBlock) {
            weakSelf.rightActionBlock();
        }
    };
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_capsuleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(8);
        make.right.equalTo(self).offset(-12);
        make.width.mas_equalTo(86);
        make.height.mas_equalTo(32);
    }];
}

#pragma mark - Public

- (void)setGameContentView:(UIView *)gameContentView {
    if (_gameContentView == gameContentView) {
        return;
    }
    
    [_gameContentView removeFromSuperview];
    _gameContentView = gameContentView;
    
    if (!gameContentView) {
        return;
    }
    
    [self.contentView addSubview:gameContentView];
    
    [gameContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self bringSubviewToFront:self.capsuleView];
}


- (void)showInView:(UIView *)superView animated:(BOOL)animated {
    if (!superView) {
        return;
    }
    
    if (self.superview != superView) {
        [superView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superView);
        }];
        [superView layoutIfNeeded];
    }
    
    CGRect finalFrame = self.frame;
    CGRect startFrame = finalFrame;
    startFrame.origin.y = CGRectGetHeight(superView.bounds);
    self.frame = startFrame;
    
    if (animated) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self.frame = finalFrame;
        } completion:nil];
    } else {
        self.frame = finalFrame;
    }
}

- (void)dismissAnimated:(BOOL)animated {
    if (!self.superview) {
        return;
    }
    
    CGRect targetFrame = self.frame;
    targetFrame.origin.y = CGRectGetHeight(self.superview.bounds);
    
    void (^completionBlock)(void) = ^{
        [self removeFromSuperview];
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            self.frame = targetFrame;
        } completion:^(__unused BOOL finished) {
            completionBlock();
        }];
    } else {
        completionBlock();
    }
}

@end
