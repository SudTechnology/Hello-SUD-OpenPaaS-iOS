//
//  InputAlertView.m
//  HelloSudTest-iOS
//
//  Created by kaniel on 4/23/26.
//

#import "InputAlertView.h"
#import <Masonry/Masonry.h>

// 屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface InputAlertView () <UITextFieldDelegate>

// UI 组件
@property (nonatomic, strong) UIView *backgroundView;      // 半透明背景
@property (nonatomic, strong) UIView *alertContainer;      // 弹窗容器
@property (nonatomic, strong) UILabel *titleLabel;         // 标题
@property (nonatomic, strong) UITextField *inputTextField; // 输入框
@property (nonatomic, strong) UIButton *cancelButton;      // 取消按钮
@property (nonatomic, strong) UIButton *confirmButton;     // 确认按钮
@property (nonatomic, strong) UIView *separatorLine;       // 分割线
@property (nonatomic, strong) UIView *buttonSeparator;     // 按钮间分割线

// 回调
@property (nonatomic, copy) void(^confirmHandler)(NSString *inputText);
@property (nonatomic, copy) void(^cancelHandler)(void);

@end

@implementation InputAlertView

#pragma mark - Public Methods

+ (void)showWithTitle:(NSString *)title
          placeholder:(NSString *)placeholder
       confirmHandler:(void(^)(NSString *inputText))confirmHandler {
    [self showWithTitle:title
            placeholder:placeholder
         confirmHandler:confirmHandler
          cancelHandler:nil];
}

+ (void)showWithTitle:(NSString *)title
          placeholder:(NSString *)placeholder
       confirmHandler:(void(^)(NSString *inputText))confirmHandler
        cancelHandler:(void(^)(void))cancelHandler {
    
    InputAlertView *alertView = [[InputAlertView alloc] initWithTitle:title
                                                              placeholder:placeholder
                                                           confirmHandler:confirmHandler
                                                            cancelHandler:cancelHandler];
    
    // 显示弹窗
    [alertView show];
}

#pragma mark - Initialization

- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
               confirmHandler:(void(^)(NSString *inputText))confirmHandler
                cancelHandler:(void(^)(void))cancelHandler {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.confirmHandler = confirmHandler;
        self.cancelHandler = cancelHandler;
        [self setupUI];
        [self setupConstraints];
        
        // 设置标题和占位文字
        self.titleLabel.text = title ?: @"请输入";
        self.inputTextField.placeholder = placeholder ?: @"请输入内容";
        
        // 监听键盘
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI Setup

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 半透明背景
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self addSubview:self.backgroundView];
    
    // 添加点击背景关闭手势（可选，如需点击背景关闭可取消注释）
    // UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundTap:)];
    // [self.backgroundView addGestureRecognizer:tap];
    
    // 弹窗容器
    self.alertContainer = [[UIView alloc] init];
    self.alertContainer.backgroundColor = [UIColor whiteColor];
    self.alertContainer.layer.cornerRadius = 12.0;
    self.alertContainer.layer.masksToBounds = YES;
    [self addSubview:self.alertContainer];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.alertContainer addSubview:self.titleLabel];
    
    // 输入框
    self.inputTextField = [[UITextField alloc] init];
    self.inputTextField.font = [UIFont systemFontOfSize:16];
    self.inputTextField.textColor = [UIColor darkTextColor];
    self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputTextField.returnKeyType = UIReturnKeyDone;
    self.inputTextField.delegate = self;
    [self.alertContainer addSubview:self.inputTextField];
    
    // 分割线（标题与按钮区域之间）
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [self.alertContainer addSubview:self.separatorLine];
    
    // 取消按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:self.cancelButton];
    
    // 确认按钮
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.confirmButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.alertContainer addSubview:self.confirmButton];
    
    // 按钮间分割线
    self.buttonSeparator = [[UIView alloc] init];
    self.buttonSeparator.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [self.alertContainer addSubview:self.buttonSeparator];
}

- (void)setupConstraints {
    // 背景铺满全屏
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 弹窗容器居中，宽度为屏幕宽度的 0.75，最大宽度 300
    [self.alertContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.75);
        make.width.lessThanOrEqualTo(@300);
    }];
    
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertContainer).offset(20);
        make.left.equalTo(self.alertContainer).offset(16);
        make.right.equalTo(self.alertContainer).offset(-16);
    }];
    
    // 输入框
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        make.left.equalTo(self.alertContainer).offset(16);
        make.right.equalTo(self.alertContainer).offset(-16);
        make.height.equalTo(@44);
    }];
    
    // 分割线
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom).offset(20);
        make.left.right.equalTo(self.alertContainer);
        make.height.equalTo(@0.5);
    }];
    
    // 取消按钮
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separatorLine.mas_bottom);
        make.left.bottom.equalTo(self.alertContainer);
        make.height.equalTo(@48);
    }];
    
    // 确认按钮
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separatorLine.mas_bottom);
        make.right.bottom.equalTo(self.alertContainer);
        make.width.equalTo(self.cancelButton);
        make.left.equalTo(self.cancelButton.mas_right);
    }];
    
    // 按钮间分割线
    [self.buttonSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertContainer);
        make.top.equalTo(self.separatorLine.mas_bottom);
        make.bottom.equalTo(self.alertContainer);
        make.width.equalTo(@0.5);
    }];
}

#pragma mark - Actions

- (void)confirmButtonTapped {
    NSString *inputText = self.inputTextField.text ?: @"";
    
    if (self.confirmHandler) {
        self.confirmHandler(inputText);
    }
    
    [self dismiss];
}

- (void)cancelButtonTapped {
    if (self.cancelHandler) {
        self.cancelHandler();
    }
    
    [self dismiss];
}

- (void)handleBackgroundTap:(UITapGestureRecognizer *)gesture {
    [self dismiss];
}

#pragma mark - Show & Dismiss

- (void)show {
    // 获取当前最顶层的视图控制器
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
    }
    [keyWindow addSubview:self];
    
    // 初始动画状态
    self.alertContainer.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.backgroundView.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 1;
        self.alertContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        // 自动弹出键盘
        [self.inputTextField becomeFirstResponder];
    }];
}

- (void)dismiss {
    [self.inputTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.alpha = 0;
        self.alertContainer.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Keyboard Handling

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 计算弹窗底部与键盘顶部的距离
    CGFloat alertBottom = CGRectGetMaxY(self.alertContainer.frame);
    CGFloat keyboardTop = SCREEN_HEIGHT - keyboardFrame.size.height;
    
    if (alertBottom > keyboardTop) {
        CGFloat offset = alertBottom - keyboardTop + 20;
        
        [UIView animateWithDuration:duration animations:^{
            self.alertContainer.transform = CGAffineTransformMakeTranslation(0, -offset);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.alertContainer.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self confirmButtonTapped];
    return YES;
}

@end
