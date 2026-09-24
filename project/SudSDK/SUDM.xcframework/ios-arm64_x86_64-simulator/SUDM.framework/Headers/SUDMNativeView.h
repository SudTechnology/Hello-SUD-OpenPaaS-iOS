

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDMNativeView : UIView

@property (nonatomic,weak)IBOutlet UIView *adView;
@property (nonatomic,weak)IBOutlet UIImageView *mainImageView;
@property (nonatomic,weak)IBOutlet UIImageView *iconImageView;
@property (nonatomic,weak)IBOutlet UIImageView *adChoiceImageView;
@property (nonatomic,weak)IBOutlet UILabel *titleLabel;
@property (nonatomic,weak)IBOutlet UILabel *textLabel;
@property (nonatomic,weak)IBOutlet UILabel *ctaLabel;
@property (nonatomic,weak)IBOutlet UIButton *ctaButton;
@property (nonatomic,strong)NSArray *clickArray;

- (void)upadateClickArray;

@end

NS_ASSUME_NONNULL_END
