//
//  SUDOPShowToastOptions.h
//  SUDGI
//
//  Created by kaniel on 5/21/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kSUDOPShowToastOptionsIconTypeSuccess = @"success";
static NSString * const kSUDOPShowToastOptionsIconTypeFail = @"fail";
static NSString * const kSUDOPShowToastOptionsIconTypeLoading = @"loading";

/**
 Options for configuring toast message display behavior.
 */
@interface SUDOPShowToastOptions : NSObject

/**
 The text content of the toast message.
 */
@property(nonatomic, strong) NSString *title;

/**
 The icon type or identifier to be displayed alongside the toast message.
 */
@property(nonatomic, strong) NSString *icon;

/**
 The local file path of a custom icon.
 The priority of `image` is higher than `icon`.
 @availability 1.1.0 and above
 */
@property(nonatomic, strong) NSString *image;

/**
 The duration (in milliseconds) for which the toast should be displayed.
 @default 1500
 */
@property(nonatomic, assign) NSInteger duration;

/**
 Whether to show a transparent mask layer to prevent touch-through events.
 When set to YES, user interactions behind the toast are blocked.
 */
@property(nonatomic, assign) BOOL mask;

@end

NS_ASSUME_NONNULL_END
