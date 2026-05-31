#import "SheetViewController.h"
#import <Masonry/Masonry.h>

#pragma mark - SheetAction

@implementation SheetAction

+ (instancetype)actionWithTitle:(NSString *)title {
    SheetAction *action = [[SheetAction alloc] init];
    action.title = title;
    action.titleColor = [UIColor blackColor];
    action.font = [UIFont systemFontOfSize:17];
    action.isDestructive = NO;
    return action;
}

@end

#pragma mark - SheetCell

@interface SheetCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
- (void)configureWithAction:(SheetAction *)action;
@end

@implementation SheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        [self.contentView addSubview:_titleLabel];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(24);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView).offset(8);
            make.bottom.equalTo(self.contentView).offset(-8);
        }];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.iconImageView.image = nil;
    self.iconImageView.hidden = YES;
    self.titleLabel.text = nil;
}

- (void)configureWithAction:(SheetAction *)action {
    self.titleLabel.text = action.title;
    self.titleLabel.textColor = action.isDestructive ? [UIColor systemRedColor] : action.titleColor;
    self.titleLabel.font = action.font;
    
    if (action.icon) {
        self.iconImageView.image = action.icon;
        self.iconImageView.hidden = NO;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(12);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView).offset(8);
            make.bottom.equalTo(self.contentView).offset(-8);
        }];
    } else {
        self.iconImageView.hidden = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView).offset(8);
            make.bottom.equalTo(self.contentView).offset(-8);
        }];
    }
}

@end

#pragma mark - SheetViewController

@interface SheetViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSArray<SheetAction *> *actions;
@property (nonatomic, copy) void(^completionBlock)(SheetAction * _Nullable action);

@property (nonatomic, strong) MASConstraint *tableViewHeightConstraint;
@property (nonatomic, strong) MASConstraint *contentHeightConstraint;

@end

@implementation SheetViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDefaultValues];
    [self setupUI];
    [self setupGestures];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showAnimation];
}

#pragma mark - Setup

- (void)setupDefaultValues {
    if (!_cancelButtonTitle.length) {
        _cancelButtonTitle = @"取消";
    }
    _dismissOnTapBackground = YES;
    _cornerRadius = 20;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _backgroundView.alpha = 0;
    [self.view addSubview:_backgroundView];
    
    _contentContainerView = [[UIView alloc] init];
    _contentContainerView.backgroundColor = [UIColor whiteColor];
    _contentContainerView.layer.cornerRadius = _cornerRadius;
    _contentContainerView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    _contentContainerView.clipsToBounds = YES;
    [self.view addSubview:_contentContainerView];
    
    [self setupHeaderView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 50;
    _tableView.estimatedRowHeight = 50;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.scrollEnabled = NO;
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
    [_tableView registerClass:[SheetCell class] forCellReuseIdentifier:@"SheetCell"];
    [_contentContainerView addSubview:_tableView];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelButton.backgroundColor = [UIColor whiteColor];
    [_cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    [_cancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_contentContainerView addSubview:_cancelButton];
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_contentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        self.contentHeightConstraint = make.height.mas_equalTo(0);
    }];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_contentContainerView);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom);
        make.left.right.equalTo(_contentContainerView);
        self.tableViewHeightConstraint = make.height.mas_equalTo(0);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom);
        make.left.right.equalTo(_contentContainerView);
        make.height.mas_equalTo(50);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(_contentContainerView.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(_contentContainerView);
        }
    }];
}

- (void)setupHeaderView {
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    [_contentContainerView addSubview:_headerView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [_headerView addSubview:_titleLabel];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = [UIFont systemFontOfSize:13];
    _messageLabel.textColor = [UIColor grayColor];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.numberOfLines = 0;
    [_headerView addSubview:_messageLabel];
    
    CGFloat topPadding = 16;
    CGFloat bottomPadding = 12;
    
    if (_sheetTitle.length > 0 && _message.length > 0) {
        _titleLabel.hidden = NO;
        _messageLabel.hidden = NO;
        _titleLabel.text = _sheetTitle;
        _messageLabel.text = _message;
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView).offset(topPadding);
            make.left.equalTo(_headerView).offset(20);
            make.right.equalTo(_headerView).offset(-20);
        }];
        
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
            make.left.equalTo(_headerView).offset(20);
            make.right.equalTo(_headerView).offset(-20);
            make.bottom.equalTo(_headerView).offset(-bottomPadding);
        }];
        
        _headerView.hidden = NO;
    } else if (_sheetTitle.length > 0) {
        _titleLabel.hidden = NO;
        _messageLabel.hidden = YES;
        _titleLabel.text = _sheetTitle;
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView).offset(topPadding);
            make.left.equalTo(_headerView).offset(20);
            make.right.equalTo(_headerView).offset(-20);
            make.bottom.equalTo(_headerView).offset(-bottomPadding);
        }];
        
        _headerView.hidden = NO;
    } else if (_message.length > 0) {
        _titleLabel.hidden = YES;
        _messageLabel.hidden = NO;
        _messageLabel.text = _message;
        
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView).offset(topPadding);
            make.left.equalTo(_headerView).offset(20);
            make.right.equalTo(_headerView).offset(-20);
            make.bottom.equalTo(_headerView).offset(-bottomPadding);
        }];
        
        _headerView.hidden = NO;
    } else {
        _headerView.hidden = YES;
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}

- (void)setupGestures {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    tap.delegate = self;
    [_backgroundView addGestureRecognizer:tap];
}

#pragma mark - Animation

- (void)showAnimation {
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    [self.headerView layoutIfNeeded];
    [self.view layoutIfNeeded];
    
    CGFloat rowHeight = 50.0;
    CGFloat tableHeight = self.actions.count * rowHeight;
    
    CGFloat maxTableHeight = self.view.bounds.size.height * 0.5;
    if (tableHeight > maxTableHeight) {
        tableHeight = maxTableHeight;
        self.tableView.scrollEnabled = YES;
    } else {
        self.tableView.scrollEnabled = NO;
    }
    
    CGFloat headerHeight = 0;
    if (!self.headerView.hidden) {
        CGSize headerSize = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        headerHeight = headerSize.height;
    }
    
    CGFloat cancelButtonHeight = 50.0;
    CGFloat bottomSafeArea = 0;
    if (@available(iOS 11.0, *)) {
        bottomSafeArea = self.view.safeAreaInsets.bottom;
    }
    
    CGFloat contentHeight = headerHeight + tableHeight + cancelButtonHeight + bottomSafeArea;
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.tableViewHeightConstraint = make.height.mas_equalTo(tableHeight);
    }];
    
    [self.contentContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.contentHeightConstraint = make.height.mas_equalTo(contentHeight);
    }];
    
    [self.view layoutIfNeeded];
    
    CGRect frame = self.contentContainerView.frame;
    frame.origin.y = self.view.bounds.size.height;
    self.contentContainerView.frame = frame;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.backgroundView.alpha = 1.0;
        CGRect newFrame = self.contentContainerView.frame;
        newFrame.origin.y = self.view.bounds.size.height - contentHeight;
        self.contentContainerView.frame = newFrame;
    } completion:nil];
}

- (void)dismissWithAction:(SheetAction *)action {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
        CGRect frame = self.contentContainerView.frame;
        frame.origin.y = self.view.bounds.size.height;
        self.contentContainerView.frame = frame;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.completionBlock) {
                self.completionBlock(action);
            }
        }];
    }];
}

#pragma mark - Actions

- (void)cancelButtonTapped {
    [self dismissWithAction:nil];
}

- (void)backgroundTapped {
    if (self.dismissOnTapBackground) {
        [self dismissWithAction:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SheetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SheetCell" forIndexPath:indexPath];
    SheetAction *action = self.actions[indexPath.row];
    [cell configureWithAction:action];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SheetAction *action = self.actions[indexPath.row];
    [self dismissWithAction:action];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentContainerView]) {
        return NO;
    }
    return YES;
}

#pragma mark - Public Methods

+ (void)showInViewController:(UIViewController *)viewController
                     actions:(NSArray<SheetAction *> *)actions
                  completion:(void(^)(SheetAction * _Nullable action))completion {
    [self showInViewController:viewController title:nil message:nil actions:actions completion:completion];
}

+ (void)showInViewController:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                     actions:(NSArray<SheetAction *> *)actions
                  completion:(void(^)(SheetAction * _Nullable action))completion {
    SheetViewController *sheetVC = [[SheetViewController alloc] init];
    sheetVC.sheetTitle = title;
    sheetVC.message = message;
    sheetVC.actions = actions;
    sheetVC.completionBlock = completion;
    sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [viewController presentViewController:sheetVC animated:NO completion:nil];
}

@end
