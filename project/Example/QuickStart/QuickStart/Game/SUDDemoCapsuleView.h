//
//  SUDDemoCapsuleView.h
//  HelloSud-iOS
//
//  Created by kaniel on 5/28/26.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDDemoCapsuleView : UIView

@property (nonatomic, copy, nullable) void(^leftActionBlock)(void);
@property (nonatomic, copy, nullable) void(^rightActionBlock)(void);

/// 设置左侧图标
- (void)setLeftImage:(nullable UIImage *)image;

/// 设置右侧图标
- (void)setRightImage:(nullable UIImage *)image;

@end

NS_ASSUME_NONNULL_END

