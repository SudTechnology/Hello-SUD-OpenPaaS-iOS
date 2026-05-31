//
//  Prefix.h
//  HelloSud-iOS
//
//  Created by mihuasama on 2021/12/16.
//

#ifndef Prefix_h
#define Prefix_h

@class UIColor;


#import "MJExtension/MJExtension.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <SUDGI/SUDGI-umbrella.h>
#define kPlaceHoldColor [UIColor colorWithRed:233/255. green:233/255. blue:233/255. alpha:1]

/// weakself宏
#define WeakSelf __weak typeof(self) weakSelf = self;

#endif /* Prefix_h */
