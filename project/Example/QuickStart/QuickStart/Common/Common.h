//
//  Common.h
//  QuickStart
//
//  Created by kaniel on 12/4/25.
//

#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MJExtension/MJExtension.h"
#import <SUDGI/SUDGI-umbrella.h>
#import "SUDDemoRespModel.h"
#import "SUDDemoHttpService.h"
#define SUDGI_APP_ID   @"2049108146763776002"
#define SUDGI_APP_KEY  @"LMKp0m44C4jYzbAAjUChSmodNnQq2N9Q"


/// weakself宏
#define WeakSelf __weak typeof(self) weakSelf = self;

NS_ASSUME_NONNULL_BEGIN

@interface Common : NSObject
@property(nonatomic, strong)NSString *selectedGameAppId;
@property(nonatomic, strong)NSString *selectedGameAppKey;
@property(nonatomic, strong)NSString *customUserId;// 自定义用户id

/// 获取用户名
+ (NSString *)getUserName;

- (NSString *)currentUserId;

+(instancetype)shared;
/// 打开一个链接
- (void)openLink:(NSString *)link;
@end

NS_ASSUME_NONNULL_END
