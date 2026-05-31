//
//  SUDOPWCKPreviewImageViewController.m
//  AFNetworking
//
//  Created by kaniel on 5/26/26.
//

#import "SUDOPWCKPreviewImageViewController.h"
#import <Masonry/Masonry.h>

#pragma mark - Cell

@interface SUDOPWCKPreviewImageCell : UICollectionViewCell <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, copy) void(^singleTapBlock)(void);

- (void)setImageSource:(NSString *)source;

@end

@implementation SUDOPWCKPreviewImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:_imageView];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.hidesWhenStopped = YES;
        [self.contentView addSubview:_indicatorView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
        }];
        
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        [self.contentView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.contentView addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.scrollView.zoomScale = 1.0;
    self.imageView.image = nil;
    [self.indicatorView stopAnimating];
}

- (void)setImageSource:(NSString *)source {
    self.scrollView.zoomScale = 1.0;
    self.imageView.image = nil;
    
    if (source.length == 0) {
        return;
    }
    
    UIImage *localImage = [self localImageFromSource:source];
    if (localImage) {
        self.imageView.image = localImage;
        return;
    }
    
    NSURL *url = [NSURL URLWithString:source];
    if (!url) {
        return;
    }
    
    [self.indicatorView startAnimating];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) self = weakSelf;
            [self.indicatorView stopAnimating];
            if (!data || error) {
                return;
            }
            UIImage *image = [UIImage imageWithData:data];
            if (!image) {
                return;
            }
            self.imageView.image = image;
        });
    }];
    [task resume];
}

- (UIImage *)localImageFromSource:(NSString *)source {
    if ([source hasPrefix:@"/"]) {
        return [UIImage imageWithContentsOfFile:source];
    }
    
    if ([source hasPrefix:@"file://"]) {
        NSURL *url = [NSURL URLWithString:source];
        return [UIImage imageWithContentsOfFile:url.path];
    }
    
    UIImage *bundleImage = [UIImage imageNamed:source];
    return bundleImage;
}

#pragma mark - Gesture

- (void)handleSingleTap {
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint point = [gesture locationInView:self.imageView];
        CGFloat zoomScale = 2.5;
        CGFloat width = self.bounds.size.width / zoomScale;
        CGFloat height = self.bounds.size.height / zoomScale;
        CGRect rect = CGRectMake(point.x - width / 2.0,
                                 point.y - height / 2.0,
                                 width,
                                 height);
        [self.scrollView zoomToRect:rect animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end

#pragma mark - VC

@interface SUDOPWCKPreviewImageViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<NSString *> *urls;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *indexLabel;

@end

@implementation SUDOPWCKPreviewImageViewController

+ (void)showFromViewController:(UIViewController *)viewController
                       current:(NSString *)current
                          urls:(NSArray<NSString *> *)urls {
    if (urls.count == 0) {
        return;
    }
    
    UIViewController *targetVC = viewController ?: [self sud_topViewController];
    if (!targetVC) {
        return;
    }
    
    SUDOPWCKPreviewImageViewController *vc = [[SUDOPWCKPreviewImageViewController alloc] init];
    vc.urls = urls;
    
    NSInteger currentIndex = 0;
    if (current.length > 0) {
        NSInteger idx = [urls indexOfObject:current];
        if (idx != NSNotFound) {
            currentIndex = idx;
        }
    }
    vc.currentIndex = currentIndex;
    
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [targetVC presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = UIScreen.mainScreen.bounds.size;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[SUDOPWCKPreviewImageCell class] forCellWithReuseIdentifier:@"SUDOPWCKPreviewImageCell"];
    [self.view addSubview:_collectionView];
    
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_indexLabel];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(12);
    }];
    
    [self updateIndexText];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.currentIndex < self.urls.count) {
        CGPoint offset = CGPointMake(self.currentIndex * self.collectionView.bounds.size.width, 0);
        [self.collectionView setContentOffset:offset animated:NO];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.urls.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SUDOPWCKPreviewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SUDOPWCKPreviewImageCell" forIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    cell.singleTapBlock = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    [cell setImageSource:self.urls[indexPath.item]];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.bounds.size.width;
    if (width <= 0) {
        return;
    }
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / width);
    self.currentIndex = index;
    [self updateIndexText];
}

#pragma mark - Private

- (void)updateIndexText {
    self.indexLabel.text = [NSString stringWithFormat:@"%ld / %ld", (long)(self.currentIndex + 1), (long)self.urls.count];
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

