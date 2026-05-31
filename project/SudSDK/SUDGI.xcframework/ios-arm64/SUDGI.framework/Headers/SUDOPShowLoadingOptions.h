//
//  SUDOPShowLoadingOptions.h
//  SUDGI
//
//  Created by kaniel on 5/21/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Options for configuring loading indicator (progress HUD) display behavior.
 */
@interface SUDOPShowLoadingOptions : NSObject

/**
 Whether to show a transparent mask layer to prevent touch-through events.
 When set to YES, user interactions behind the loading indicator are blocked.
 */
@property(nonatomic, assign) BOOL mask;

/**
 The text title to be displayed alongside the loading indicator.
 (e.g., "Loading...", "Please wait...")
 */
@property(nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
