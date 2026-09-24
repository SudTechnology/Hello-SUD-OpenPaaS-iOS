//
//  SUDOPDefaultWrappedClient.m
//  SUDOPWrappedClientKit
//
//  Created by kaniel on 5/13/26.
//

#import "SUDOPWCKDefaultWrappedClient.h"

#import "SUDOPWCKPhotoHelper.h"
#import "SUDOPWCKImagePickerHelper.h"
#import "SUDOPWCKImageFileHelper.h"
#import "SUDOPWCKChooseImageResult.h"
#import "SUDOPWCKToast.h"
#import "SUDOPWCKPermissionHelper.h"
#import "SUDOPWCKActionSheet.h"
#import "SUDOPWCKActionSheetResult.h"
#import "SUDOPWCKModalView.h"
#import "SUDOPWCKPreviewImageViewController.h"
#import "SUDOPWCKShowModalResult.h"
#import "SUDOPWCKVideoPlayerView.h"
#import "SUDOPWCKLanguageHelper.h"
#import <Masonry/Masonry.h>

@interface SUDOPWCKDefaultWrappedClient()
@property(nonatomic, weak)SUDOPWCKToast *toast;
@property(nonatomic, strong)SUDOPWCKVideoPlayerView *videoPlayerView;

@end

@implementation SUDOPWCKDefaultWrappedClient

- (void)setPreferredLanguage:(NSString *)preferredLanguage {
    [SUDOPWCKLanguageHelper setPreferredLanguage:preferredLanguage];
}

- (NSString *)preferredLanguage {
    return [SUDOPWCKLanguageHelper currentLanguage];
}

- (NSDictionary *)getAppBaseInfo {
    return @{@"language" : [SUDOPWCKLanguageHelper currentLanguage]};
}

- (void)saveImageToPhotosAlbum:(id<SUDOPStateHandle>)stateHandle options:(SUDOPSaveImageToPhotosAlbumOptions *)options {
    if (options.filePath.length == 0) {
        NSString *message = [SUDOPWCKLanguageHelper localizedStringForKey:@"sudop_wck.error.file_path_empty"
                                                                    table:@"SUDOPWrappedClientKitErrors"
                                                             defaultValue:@"The file path is empty."];
        [stateHandle failure:[SUDOPWCKCommon errorWithCode:-1 msg:message]];
        return;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:options.filePath];
    [SUDOPWCKPhotoHelper saveImageToPhotosAlbum:image completion:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            [stateHandle failure:error];
            return;
        }
        [stateHandle success:@""];
    }];
}

- (void)chooseImage:(id<SUDOPStateHandle>)stateHandle options:(SUDOPChooseImageOptions *)options {
    [SUDOPWCKImagePickerHelper chooseImagesFromViewController:self.viewController
                                                  sourceTypes:options.sourceType
                                                     maxCount:options.count
                                                allowsEditing:NO
                                                   completion:^(NSArray<UIImage *> * _Nullable images, NSError * _Nullable error) {
        
        if (error) {
            [stateHandle failure:error];
            return;
        }
        BOOL bCompressed = NO;
        for (NSString *item in options.sizeType) {
            if ([item isEqualToString:kSUDOPImageSizeTypeCompressed]) {
                bCompressed = YES;
                break;
            }
        }
        NSMutableArray *tempFilePaths = [[NSMutableArray alloc]init];
        for (UIImage *image in images) {
            
            NSError *error = nil;
            
            NSString *filePath = [SUDOPWCKImageFileHelper saveJPEGImageToTemporaryDirectory:image
                                                                         compressionQuality:bCompressed ? 0.8 : 1.0
                                                                                      error:&error];
            if (filePath) {
                NSLog(@"save successfully: %@", filePath);
                [tempFilePaths addObject:filePath];
            } else {
                NSLog(@"save failed: %@", error.localizedDescription);
            }
        }
        SUDOPWCKChooseImageResult *result = [[SUDOPWCKChooseImageResult alloc]init];
        result.tempFilePaths = tempFilePaths;
        [stateHandle success:result.mj_JSONString];
        

    }];

}

- (void)previewImage:(id<SUDOPStateHandle>)stateHandle options:(SUDOPPreviewImageOptions *)options {
    [SUDOPWCKPreviewImageViewController showFromViewController:self.viewController
                                                       current:options.current
                                                          urls:options.urls];
    [stateHandle success:@""];
}

- (void)showLoading:(id<SUDOPStateHandle>)stateHandle options:(SUDOPShowLoadingOptions *)options {
    self.toast = [SUDOPWCKToast showLoadingInView:self.viewController.view text:options.title mask:options.mask];
    [stateHandle success:@""];
}

- (void)hideLoading:(id<SUDOPStateHandle>)stateHandle options:(SUDOPHideLoadingOptions *)options {
    if (self.toast) {
        [self.toast hide];
        self.toast = nil;
    }
    [stateHandle success:@""];
}

- (void)showToast:(id<SUDOPStateHandle>)stateHandle options:(SUDOPShowToastOptions *)options {
    UIImage *image = nil;
    // options image higher than icon
    if (options.image) {
        image = [UIImage imageWithContentsOfFile:options.image];
    } else {
        if ([options.icon isEqualToString:kSUDOPShowToastOptionsIconTypeSuccess]) {
            image = [SUDOPWCKCommon imageWithName:@"success@3x.png"];
        } else if ([options.icon isEqualToString:kSUDOPShowToastOptionsIconTypeFail]) {
            image = [SUDOPWCKCommon imageWithName:@"error@3x.png"];
        }else if ([options.icon isEqualToString:kSUDOPShowToastOptionsIconTypeLoading]) {
            image = [SUDOPWCKCommon imageWithName:@"loading@3x.png"];
        }
    }
     
    self.toast = [SUDOPWCKToast showSuccessInView:self.viewController.view
                                             text:options.title
                                            image:image
                                             mask:options.mask];
    CGFloat duration = 1500;
    if (options.duration > 0) {
        duration = options.duration;
    }
    [self.toast hideAfterDelay:duration/1000.0];
    [stateHandle success:@""];
}

- (void)hideToast:(id<SUDOPStateHandle>)stateHandle options:(SUDOPHideToastOptions *)options {
    if (self.toast) {
        [self.toast hide];
        self.toast = nil;
    }
    [stateHandle success:@""];
}

- (void)onQueryPermission:(id<SUDRTGameQueryPermissionHandle>)handle permission:(NSString *)permission appId:(NSString *)appId authStatus:(SUDRTPermissionAuthStatus)authStatus {
    if ([permission isEqualToString:SUDRT_KEY_PERMISSION_SAVE_TO_ALBUM]) {
        [SUDOPWCKPermissionHelper requestPhotoAddPermission:^(BOOL granted) {
            [handle completeQueryPermission:permission authStatus:granted ? SUD_RT_PERMISSION_AUTH_STATUS_GRANTED : SUD_RT_PERMISSION_AUTH_STATUS_DENIED];
        }];
    } else if ([permission isEqualToString:SUDRT_KEY_PERMISSION_LOCATION]) {
        [SUDOPWCKPermissionHelper requestLocationPermission:^(BOOL granted) {
            [handle completeQueryPermission:permission authStatus:granted ? SUD_RT_PERMISSION_AUTH_STATUS_GRANTED : SUD_RT_PERMISSION_AUTH_STATUS_DENIED];
        }];
    } else if ([permission isEqualToString:SUDRT_KEY_PERMISSION_CAMERA]) {
        [SUDOPWCKPermissionHelper requestCameraPermission:^(BOOL granted) {
            [handle completeQueryPermission:permission authStatus:granted ? SUD_RT_PERMISSION_AUTH_STATUS_GRANTED : SUD_RT_PERMISSION_AUTH_STATUS_DENIED];
        }];
    } else if ([permission isEqualToString:SUDRT_KEY_PERMISSION_RECORD]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SUDOPWCKPermissionHelper requestMicrophonePermission:^(BOOL granted) {
                [handle completeQueryPermission:permission authStatus:granted ? SUD_RT_PERMISSION_AUTH_STATUS_GRANTED : SUD_RT_PERMISSION_AUTH_STATUS_DENIED];
            }];
        });
    } else {
        [handle completeQueryPermission:permission authStatus:SUD_RT_PERMISSION_AUTH_STATUS_UNDETERMINED];
    }
}

- (void)beforeQuerySystemPermission:(id<SUDRTGameQuerySystemPermissionHandle>)handle fromJSMethod:(NSString *)methodName permission:(NSString *)permission appId:(NSString *)appId authStatus:(SUDRTSystemPermissionAuthStatus)authStatus serviceStatus:(BOOL)enabled {
    [handle continueQuerySystemPermission:permission];
}

- (void)showActionSheet:(id<SUDOPStateHandle>)stateHandle options:(SUDOPShowActionSheetOptions *)options {
    [SUDOPWCKActionSheet showInViewController:self.viewController
                                    alertText:options.alertText
                                     itemList:options.itemList
                                    itemColor:options.itemColor
                                   completion:^(NSInteger index) {
        SUDOPWCKActionSheetResult *result = [[SUDOPWCKActionSheetResult alloc]init];
        result.tapIndex = index;
        [stateHandle success:result.mj_JSONString];
    }];
}

- (void)showModal:(id<SUDOPStateHandle>)stateHandle options:(SUDOPShowModalOptions *)options {
    SUDOPWCKModalOptions *tempOptions = [SUDOPWCKModalOptions mj_objectWithKeyValues:options.mj_JSONObject];
    [SUDOPWCKModalView showInViewController:self.viewController options:tempOptions cancel:^{
        SUDOPWCKShowModalResult *result = [[SUDOPWCKShowModalResult alloc]init];
        result.cancel = YES;
        [stateHandle success:result.mj_JSONString];
    } confirm:^(NSString * _Nullable inputText) {
        SUDOPWCKShowModalResult *result = [[SUDOPWCKShowModalResult alloc]init];
        result.content = inputText;
        result.confirm = YES;
        [stateHandle success:result.mj_JSONString];
    }];
}

- (void)createVideo:(SUDOPVideo *)video {
    if (!video) {
        return;
    }

    UIView *hostView = [self sudop_videoHostView];

    if (!hostView) {
        return;
    }

    /*
     当前实现只有一个 videoPlayerView 属性，所以这里默认单视频。
     如果以后支持多个视频，需要改成数组或字典管理。
     */
    if (self.videoPlayerView) {
        [self.videoPlayerView invalidate];
        self.videoPlayerView = nil;
    }

    SUDOPWCKVideoPlayerView *playerView = [[SUDOPWCKVideoPlayerView alloc] initWithVideo:video];

    playerView.closeImage = [SUDOPWCKCommon imageWithName:@"sud_video_close@3x.png"];
    playerView.playImage = [SUDOPWCKCommon imageWithName:@"sud_video_play_small@3x.png"];
    playerView.pauseImage = [SUDOPWCKCommon imageWithName:@"sud_video_pause_small@3x.png"];
    playerView.fullScreenImage = [SUDOPWCKCommon imageWithName:@"sud_video_fullscreen@3x.png"];
    playerView.exitFullScreenImage = [SUDOPWCKCommon imageWithName:@"sud_video_exit_fullscreen@3x.png"];
    playerView.centerPlayImage = [SUDOPWCKCommon imageWithName:@"sud_video_play_big@3x.png"];
    playerView.centerPauseImage = [SUDOPWCKCommon imageWithName:@"sud_video_pause_big@3x.png"];

    self.videoPlayerView = playerView;

    __weak typeof(self) weakSelf = self;

    playerView.layerUpdateHandler = ^(SUDOPWCKVideoPlayerView *callbackPlayerView,
                                      SUDOPVideo *callbackVideo) {
        __strong typeof(weakSelf) self = weakSelf;

        if (!self) {
            return;
        }

        /*
         避免旧的 playerView 回调影响新的 playerView。
         */
        if (self.videoPlayerView != callbackPlayerView) {
            return;
        }

        [self sudop_applyVideoPlayerLayerWithPlayerView:callbackPlayerView
                                                  video:callbackVideo];
    };

    /*
     首次添加时，根据 underGameView 精准插入到 gameView 上方或下方。
     */
    if (self.gameView && self.gameView.superview == hostView) {
        if (video.underGameView) {
            [hostView insertSubview:playerView belowSubview:self.gameView];
        } else {
            [hostView insertSubview:playerView aboveSubview:self.gameView];
        }
    } else {
        [hostView addSubview:playerView];
    }

    CGRect frame = video.frameInPoint;

    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hostView).offset(frame.origin.x);
        make.top.equalTo(hostView).offset(frame.origin.y);
        make.width.mas_equalTo(frame.size.width);
        make.height.mas_equalTo(frame.size.height);
    }];

    [hostView layoutIfNeeded];

    /*
     兜底修正一次层级。
     */
    [self sudop_applyVideoPlayerLayerWithPlayerView:playerView
                                              video:video];
}

#pragma mark - Video Layer

- (UIView *)sudop_videoHostView {
    UIView *hostView = self.gameView.superview;

    if (!hostView) {
        hostView = self.viewController.view;
    }

    return hostView;
}

- (void)sudop_applyVideoPlayerLayerWithPlayerView:(SUDOPWCKVideoPlayerView *)playerView
                                            video:(SUDOPVideo *)video {
    if (!playerView || !video) {
        return;
    }

    /*
     全屏状态：
     playerView 已经被移动到 fullScreenContainerView 里面。
     此时需要调整的是 fullScreenContainerView 和 gameView 所在层级的关系，
     而不是调整 playerView 本身。
     */
    if (video.isFullScreen) {
        [self sudop_applyFullScreenVideoLayerWithPlayerView:playerView
                                                      video:video];
        return;
    }

    UIView *hostView = [self sudop_videoHostView];

    if (!hostView) {
        return;
    }

    /*
     如果播放器当前不在 hostView 上，说明它可能处于全屏容器中，
     或者还没有完成恢复。这里不强行移动，避免破坏播放器内部流程。
     */
    if (playerView.superview != hostView) {
        return;
    }

    /*
     非全屏状态下，直接根据 underGameView 控制 playerView
     在 gameView 上方或下方。
     */
    if (self.gameView && self.gameView.superview == hostView) {
        if (video.underGameView) {
            [hostView insertSubview:playerView belowSubview:self.gameView];
        } else {
            [hostView insertSubview:playerView aboveSubview:self.gameView];
        }
    } else {
        /*
         没有 gameView 时：
         - underGameView = YES：尽量放到底层
         - underGameView = NO：放到最上层
         */
        if (video.underGameView) {
            [hostView sendSubviewToBack:playerView];
        } else {
            [hostView bringSubviewToFront:playerView];
        }
    }
}

- (void)sudop_applyFullScreenVideoLayerWithPlayerView:(SUDOPWCKVideoPlayerView *)playerView
                                                video:(SUDOPVideo *)video {
    if (!playerView || !video) {
        return;
    }

    /*
     全屏时：
     playerView.superview 就是 SUDOPWCKVideoPlayerView 内部创建的 fullScreenContainerView。
     */
    UIView *fullScreenContainerView = playerView.superview;

    if (!fullScreenContainerView) {
        return;
    }

    UIView *containerSuperview = fullScreenContainerView.superview;

    if (!containerSuperview) {
        return;
    }

    /*
     找到 gameView 在 containerSuperview 下对应的那一级视图。
     
     举例：
     window
       └── viewController.view
             └── hostView
                   └── gameView
     
     fullScreenContainerView 是 window 的直接子视图。
     那么不能直接和 gameView 做 insertSubview:belowSubview:，
     因为它们不是同一个父视图。
     
     这里要找到 viewController.view 作为参照视图。
     */
    UIView *referenceView = [self sudop_referenceViewForGameViewInSuperview:containerSuperview];

    if (referenceView && referenceView != fullScreenContainerView) {
        if (video.underGameView) {
            [containerSuperview insertSubview:fullScreenContainerView belowSubview:referenceView];
        } else {
            [containerSuperview insertSubview:fullScreenContainerView aboveSubview:referenceView];
        }
    } else {
        /*
         找不到 gameView 对应的同级参照视图时，做兜底处理。
         */
        if (video.underGameView) {
            [containerSuperview sendSubviewToBack:fullScreenContainerView];
        } else {
            [containerSuperview bringSubviewToFront:fullScreenContainerView];
        }
    }
}

- (UIView *)sudop_referenceViewForGameViewInSuperview:(UIView *)targetSuperview {
    if (!targetSuperview) {
        return nil;
    }

    /*
     优先使用 gameView。
     */
    UIView *referenceView = [self sudop_directChildViewForView:self.gameView
                                                   inSuperview:targetSuperview];

    if (referenceView) {
        return referenceView;
    }

    /*
     如果 gameView 找不到，退化使用 viewController.view。
     */
    referenceView = [self sudop_directChildViewForView:self.viewController.view
                                           inSuperview:targetSuperview];

    if (referenceView) {
        return referenceView;
    }

    return nil;
}

- (UIView *)sudop_directChildViewForView:(UIView *)view
                             inSuperview:(UIView *)targetSuperview {
    if (!view || !targetSuperview) {
        return nil;
    }

    UIView *currentView = view;

    while (currentView && currentView.superview) {
        if (currentView.superview == targetSuperview) {
            return currentView;
        }

        currentView = currentView.superview;
    }

    return nil;
}
@end
