//
//  SUDDemoBoxAdView.m
//  HelloSud-iOS
//
//  Created by kaniel on 4/28/26.
//

#import "SUDDemoBoxAdView.h"
#import <Masonry/Masonry.h>

@interface SUDDemoBoxAdView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) SUDOPBoxAdType adType;
@property (nonatomic, copy) NSString *adUnitId;
@property (nonatomic, assign) BOOL isAdLoaded;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) NSArray<NSDictionary *> *adItems;
@property (nonatomic, assign) CGPoint showOrigin;

// 横幅广告专用
@property (nonatomic, strong) UIScrollView *bannerScrollView;
@property (nonatomic, strong) UIStackView *bannerStackView;

// 九宫格广告专用
@property (nonatomic, strong) UICollectionView *gridCollectionView;
@property (nonatomic, strong) UIView *gridContainer;

// 抽屉广告专用
@property (nonatomic, assign) BOOL isDrawerOpen;
@property (nonatomic, strong) UIView *drawerHandleView;
@property (nonatomic, strong) UIImageView *drawerIconView;
@property (nonatomic, strong) UIView *drawerContentContainer;
@property (nonatomic, strong) UICollectionView *drawerCollectionView;
@property (nonatomic, strong) MASConstraint *drawerHeightConstraint;

@end

@implementation SUDDemoBoxAdView

#pragma mark - Initialization

- (instancetype)initWithAdUnitId:(NSString *)adUnitId adType:(SUDOPBoxAdType)adType {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _adUnitId = [adUnitId copy];
        _adType = adType;
        _isAdLoaded = NO;
        _isDrawerOpen = NO;
        _showCloseButton = YES;
        _titleText = @"互推盒子";
        _subtitleText = @"更多精彩推荐";
        _adItems = @[];
        
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

#pragma mark - UI Setup

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    // 主容器
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 12;
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.shadowOpacity = 0.1;
    self.containerView.layer.shadowRadius = 4;
    [self addSubview:self.containerView];
    
    // 内容视图
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:self.contentView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.titleText;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    // 副标题（仅横幅广告需要）
    if (self.adType == SUDOPBoxAdTypeBanner) {
        self.subtitleLabel = [[UILabel alloc] init];
        self.subtitleLabel.text = self.subtitleText;
        self.subtitleLabel.font = [UIFont systemFontOfSize:12];
        self.subtitleLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.subtitleLabel];
    }
    
    // 关闭按钮
    if (self.showCloseButton) {
        self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.closeButton setTitle:@"✕" forState:UIControlStateNormal];
        self.closeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.closeButton.tintColor = [UIColor grayColor];
        [self.closeButton addTarget:self action:@selector(handleClose) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.closeButton];
    }
    
    // 根据类型创建不同的广告视图
    switch (self.adType) {
        case SUDOPBoxAdTypeBanner:
            [self setupBannerView];
            break;
        case SUDOPBoxAdTypeGrid9:
            [self setupGridView];
            break;
        case SUDOPBoxAdTypeDrawer:
            [self setupDrawerView];
            break;
    }
    
    // 加载指示器
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.loadingIndicator.hidesWhenStopped = YES;
    self.loadingIndicator.color = [UIColor systemBlueColor];
    [self.contentView addSubview:self.loadingIndicator];
}

#pragma mark - 横幅广告 UI

- (void)setupBannerView {
    self.bannerScrollView = [[UIScrollView alloc] init];
    self.bannerScrollView.showsHorizontalScrollIndicator = NO;
    self.bannerScrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.bannerScrollView];
    
    self.bannerStackView = [[UIStackView alloc] init];
    self.bannerStackView.axis = UILayoutConstraintAxisHorizontal;
    self.bannerStackView.spacing = 12;
    self.bannerStackView.distribution = UIStackViewDistributionFillEqually;
    [self.bannerScrollView addSubview:self.bannerStackView];
}

#pragma mark - 九宫格广告 UI

- (void)setupGridView {
    // 九宫格容器
    self.gridContainer = [[UIView alloc] init];
    self.gridContainer.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.gridContainer];
    
    // 创建九宫格布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    
    self.gridCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.gridCollectionView.backgroundColor = [UIColor whiteColor];
    self.gridCollectionView.delegate = self;
    self.gridCollectionView.dataSource = self;
    self.gridCollectionView.scrollEnabled = NO;
    [self.gridCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GridCell"];
    [self.gridContainer addSubview:self.gridCollectionView];
}

#pragma mark - 抽屉广告 UI

- (void)setupDrawerView {
    // 抽屉把手
    self.drawerHandleView = [[UIView alloc] init];
    self.drawerHandleView.backgroundColor = [UIColor whiteColor];
    self.drawerHandleView.layer.cornerRadius = 8;
    self.drawerHandleView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.drawerHandleView.layer.shadowOffset = CGSizeMake(0, -2);
    self.drawerHandleView.layer.shadowOpacity = 0.1;
    self.drawerHandleView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.drawerHandleView];
    
    // 把手图标
    self.drawerIconView = [[UIImageView alloc] init];
    self.drawerIconView.image = [UIImage systemImageNamed:@"chevron.up"];
    self.drawerIconView.tintColor = [UIColor grayColor];
    self.drawerIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.drawerHandleView addSubview:self.drawerIconView];
    
    // 抽屉标题
    UILabel *drawerTitleLabel = [[UILabel alloc] init];
    drawerTitleLabel.text = self.titleText;
    drawerTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    drawerTitleLabel.textColor = [UIColor darkGrayColor];
    [self.drawerHandleView addSubview:drawerTitleLabel];
    
    // 抽屉内容容器
    self.drawerContentContainer = [[UIView alloc] init];
    self.drawerContentContainer.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.drawerContentContainer.clipsToBounds = YES;
    [self.contentView addSubview:self.drawerContentContainer];
    
    // 抽屉内的九宫格
    UICollectionViewFlowLayout *drawerLayout = [[UICollectionViewFlowLayout alloc] init];
    drawerLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    drawerLayout.minimumLineSpacing = 8;
    drawerLayout.minimumInteritemSpacing = 8;
    
    self.drawerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:drawerLayout];
    self.drawerCollectionView.backgroundColor = [UIColor clearColor];
    self.drawerCollectionView.delegate = self;
    self.drawerCollectionView.dataSource = self;
    self.drawerCollectionView.scrollEnabled = NO;
    [self.drawerCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"DrawerCell"];
    [self.drawerContentContainer addSubview:self.drawerCollectionView];
    
    // 点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDrawer)];
    [self.drawerHandleView addGestureRecognizer:tap];
    
    // 布局约束
    [drawerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.drawerHandleView);
    }];
    
    [self.drawerIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.drawerHandleView).offset(-12);
        make.centerY.equalTo(self.drawerHandleView);
        make.width.height.mas_equalTo(20);
    }];
}

- (void)setupLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView).insets(UIEdgeInsetsMake(12, 12, 12, 12));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView);
        make.height.mas_equalTo(24);
    }];
    
    if (self.subtitleLabel) {
        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(8);
            make.centerY.equalTo(self.titleLabel);
            make.height.mas_equalTo(18);
        }];
    }
    
    if (self.closeButton) {
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.contentView);
            make.width.height.mas_equalTo(30);
        }];
    }
    
    // 根据类型布局不同内容
    switch (self.adType) {
        case SUDOPBoxAdTypeBanner:
            [self setupBannerLayout];
            break;
        case SUDOPBoxAdTypeGrid9:
            [self setupGridLayout];
            break;
        case SUDOPBoxAdTypeDrawer:
            [self setupDrawerLayout];
            break;
    }
    
    [self.loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

- (void)setupBannerLayout {
    [self.bannerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(80);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.bannerStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bannerScrollView);
        make.height.equalTo(self.bannerScrollView);
    }];
}

- (void)setupGridLayout {
    [self.gridContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(280);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    [self.gridCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.gridContainer);
    }];
}

- (void)setupDrawerLayout {
    [self.drawerHandleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(44);
    }];
    
    [self.drawerContentContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.drawerHandleView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.drawerCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.drawerContentContainer).insets(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
}

#pragma mark - Public Methods

- (void)loadAd {
    if (self.isAdLoaded) {
        return;
    }
    
    [self.loadingIndicator startAnimating];
    
    // 模拟广告加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingIndicator stopAnimating];
        
        // 生成模拟数据
        [self generateMockAdItems];
        self.isAdLoaded = YES;
        
        if ([self.delegate respondsToSelector:@selector(boxAdViewDidLoad:)]) {
            [self.delegate boxAdViewDidLoad:self];
        }
    });
}

- (void)showInView:(UIView *)parentView {
    [self showInView:parentView atOrigin:CGPointMake(20, 100)];
}

- (void)showInView:(UIView *)parentView atOrigin:(CGPoint)origin {
    self.showOrigin = origin;
    [parentView addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parentView).offset(origin.x);
        make.top.equalTo(parentView).offset(origin.y);
        make.right.equalTo(parentView).offset(-origin.x);
    }];
    
    if (!self.isAdLoaded) {
        [self loadAd];
    }
    
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)closeAd {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if ([self.delegate respondsToSelector:@selector(boxAdViewDidClose:)]) {
            [self.delegate boxAdViewDidClose:self];
        }
    }];
}

- (void)setAdItems:(NSArray<NSDictionary *> *)items {
    _adItems = items;
    [self reloadAdData];
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

#pragma mark - 抽屉广告方法

- (void)openDrawer {
    if (self.isDrawerOpen) return;
    
    self.isDrawerOpen = YES;
    
    // 更新图标
    self.drawerIconView.image = [UIImage systemImageNamed:@"chevron.down"];
    
    // 计算内容高度
    NSInteger rows = (self.adItems.count + 2) / 3;
    CGFloat height = rows * 100 + 16;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.drawerContentContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        [self.superview layoutIfNeeded];
    }];
    
    if ([self.delegate respondsToSelector:@selector(boxAdView:didChangeDrawerState:)]) {
        [self.delegate boxAdView:self didChangeDrawerState:YES];
    }
}

- (void)closeDrawer {
    if (!self.isDrawerOpen) return;
    
    self.isDrawerOpen = NO;
    
    // 更新图标
    self.drawerIconView.image = [UIImage systemImageNamed:@"chevron.up"];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.drawerContentContainer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.superview layoutIfNeeded];
    }];
    
    if ([self.delegate respondsToSelector:@selector(boxAdView:didChangeDrawerState:)]) {
        [self.delegate boxAdView:self didChangeDrawerState:NO];
    }
}

- (void)toggleDrawer {
    if (self.isDrawerOpen) {
        [self closeDrawer];
    } else {
        [self openDrawer];
    }
}

#pragma mark - 数据加载

- (void)generateMockAdItems {
    NSMutableArray *items = [NSMutableArray array];
    
    NSArray *titles = @[@"热门游戏", @"精品推荐", @"限时特惠", @"新游上线", @"福利专区", @"排行榜", @"社区动态", @"攻略大全", @"礼包中心"];
    NSArray *icons = @[@"🎮", @"⭐️", @"🔥", @"🆕", @"🎁", @"📊", @"💬", @"📖", @"🎫"];
    
    NSInteger count = (self.adType == SUDOPBoxAdTypeBanner) ? 6 : 9;
    
    for (int i = 0; i < count; i++) {
        NSDictionary *item = @{
            @"title": titles[i % titles.count],
            @"icon": icons[i % icons.count],
            @"desc": [NSString stringWithFormat:@"精彩内容等你来发现"],
            @"index": @(i)
        };
        [items addObject:item];
    }
    
    self.adItems = items;
}

- (void)reloadAdData {
    switch (self.adType) {
        case SUDOPBoxAdTypeBanner:
            [self reloadBannerData];
            break;
        case SUDOPBoxAdTypeGrid9:
            [self reloadGridData];
            break;
        case SUDOPBoxAdTypeDrawer:
            [self reloadDrawerData];
            break;
    }
}

- (void)reloadBannerData {
    // 清空原有视图
    for (UIView *view in self.bannerStackView.arrangedSubviews) {
        [self.bannerStackView removeArrangedSubview:view];
        [view removeFromSuperview];
    }
    
    // 添加横幅项
    for (int i = 0; i < self.adItems.count; i++) {
        NSDictionary *item = self.adItems[i];
        UIView *itemView = [self createBannerItemView:item index:i];
        [self.bannerStackView addArrangedSubview:itemView];
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120);
        }];
    }
    
    // 更新滚动视图内容大小
    CGFloat width = self.adItems.count * 132;
    self.bannerScrollView.contentSize = CGSizeMake(width, 80);
}

- (void)reloadGridData {
    [self.gridCollectionView reloadData];
    
    // 计算九宫格高度
    NSInteger rows = (self.adItems.count + 2) / 3;
    CGFloat height = rows * 90 + (rows - 1) * 8;
    
    [self.gridContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (void)reloadDrawerData {
    [self.drawerCollectionView reloadData];
}

#pragma mark - 创建横幅项

- (UIView *)createBannerItemView:(NSDictionary *)item index:(NSInteger)index {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    view.layer.cornerRadius = 8;
    view.tag = index;
    
    // 点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleItemTap:)];
    [view addGestureRecognizer:tap];
    
    // 图标
    UILabel *iconLabel = [[UILabel alloc] init];
    iconLabel.text = item[@"icon"];
    iconLabel.font = [UIFont systemFontOfSize:32];
    iconLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:iconLabel];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = item[@"title"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
    [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(12);
        make.width.height.mas_equalTo(40);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(iconLabel.mas_bottom).offset(4);
        make.left.right.equalTo(view).inset(4);
    }];
    
    return view;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.gridCollectionView || collectionView == self.drawerCollectionView) {
        return self.adItems.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = (collectionView == self.gridCollectionView) ? @"GridCell" : @"DrawerCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    // 清除旧视图
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    NSDictionary *item = self.adItems[indexPath.item];
    
    // 创建九宫格项视图
    UIView *itemView = [self createGridItemView:item index:indexPath.item];
    [cell.contentView addSubview:itemView];
    
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.bounds.size.width - 16) / 3;
    return CGSizeMake(width, 90);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(boxAdView:didSelectItemAtIndex:)]) {
        [self.delegate boxAdView:self didSelectItemAtIndex:indexPath.item];
    }
}

#pragma mark - 创建九宫格项

- (UIView *)createGridItemView:(NSDictionary *)item index:(NSInteger)index {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    view.layer.cornerRadius = 8;
    view.tag = index;
    
    // 点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleItemTap:)];
    [view addGestureRecognizer:tap];
    
    // 图标
    UILabel *iconLabel = [[UILabel alloc] init];
    iconLabel.text = item[@"icon"];
    iconLabel.font = [UIFont systemFontOfSize:36];
    iconLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:iconLabel];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = item[@"title"];
    titleLabel.font = [UIFont boldSystemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
    // 描述
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = item[@"desc"];
    descLabel.font = [UIFont systemFontOfSize:10];
    descLabel.textColor = [UIColor grayColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:descLabel];
    
    [iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(15);
        make.width.height.mas_equalTo(40);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(iconLabel.mas_bottom).offset(6);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(titleLabel.mas_bottom).offset(2);
    }];
    
    return view;
}

#pragma mark - Actions

- (void)handleItemTap:(UITapGestureRecognizer *)gesture {
    NSInteger index = gesture.view.tag;
    
    if ([self.delegate respondsToSelector:@selector(boxAdView:didSelectItemAtIndex:)]) {
        [self.delegate boxAdView:self didSelectItemAtIndex:index];
    }
    
    // 模拟点击跳转
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"点击广告"
                                                                   message:[NSString stringWithFormat:@"您点击了「%@」", self.adItems[index][@"title"]]
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
