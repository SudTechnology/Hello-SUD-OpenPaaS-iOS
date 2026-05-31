//
//  ViewController.m
//  QuickStart
//
//  Created by kaniel on 10/27/25.
//

#import "ViewController.h"
#import "Common.h"
#import "QuickStartViewController.h"

@interface ViewController()
@property(nonatomic, strong)UIButton *runtime1Btn;
@property(nonatomic, strong)UIButton *runtime2Btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

//    [self.view addSubview:self.runtime1Btn];
    [self.view addSubview:self.runtime2Btn];

//    [self.runtime1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.runtime2Btn);
//        make.height.equalTo(self.runtime2Btn);
//        make.centerX.equalTo(self.view);
//        make.bottom.equalTo(self.runtime2Btn.mas_top).offset(-30);
//    }];
    
    [self.runtime2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.width.equalTo(@120);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(@-90);
    }];

}




- (void)runtime2BtnClick:(id)sender {
    QuickStartViewController *vc = [[QuickStartViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIButton *)runtime2Btn {
    if (!_runtime2Btn) {
        _runtime2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_runtime2Btn setBackgroundImage:[self imageWithColor:UIColor.orangeColor] forState:UIControlStateNormal];
        [_runtime2Btn setTitle:@"OpenPaaS" forState:UIControlStateNormal];
        _runtime2Btn.layer.cornerRadius = 15;
        _runtime2Btn.clipsToBounds = YES;
        [_runtime2Btn addTarget:self action:@selector(runtime2BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _runtime2Btn;
}
@end

