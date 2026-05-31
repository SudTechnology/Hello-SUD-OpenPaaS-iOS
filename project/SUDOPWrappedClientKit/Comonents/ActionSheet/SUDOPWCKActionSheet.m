//
//  SUDOPWCKActionSheet.m
//  SUDGI
//
//  Created by kaniel on 5/24/26.
//

#import "SUDOPWCKActionSheet.h"

@implementation SUDOPWCKActionSheet

+ (void)showInViewController:(UIViewController *)viewController
                   alertText:(NSString *)alertText
                    itemList:(NSArray<NSString *> *)itemList
                   itemColor:(NSString *)itemColor
                  completion:(void(^)(NSInteger index))completion {
    if (!viewController || itemList.count == 0) {
        if (completion) {
            completion(-1);
        }
        return;
    }
    
    UIColor *finalItemColor = [self colorWithHexString:itemColor ?: @"#000000"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:alertText
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [itemList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(__unused UIAlertAction * _Nonnull action) {
            if (completion) {
                completion(idx);
            }
        }];
        
        [action setValue:finalItemColor forKey:@"titleTextColor"];
        [alertController addAction:action];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(__unused UIAlertAction * _Nonnull action) {
        if (completion) {
            completion(-1);
        }
    }];
    [alertController addAction:cancelAction];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = viewController.view;
        popover.sourceRect = CGRectMake(CGRectGetMidX(viewController.view.bounds),
                                        CGRectGetMaxY(viewController.view.bounds) - 1,
                                        1,
                                        1);
        popover.permittedArrowDirections = 0;
    }
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    if (colorString.length != 6) {
        return [UIColor blackColor];
    }
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:[colorString substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r];
    [[NSScanner scannerWithString:[colorString substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g];
    [[NSScanner scannerWithString:[colorString substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b];
    
    return [UIColor colorWithRed:r / 255.0
                           green:g / 255.0
                            blue:b / 255.0
                           alpha:1.0];
}

@end

