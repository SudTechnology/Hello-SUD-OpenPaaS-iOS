//
//  SUDOPMenuButtonBoundingClientRect.h
//  SUDGI
//
//  Created by kaniel on 6/22/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents the bounding client rectangle of the menu button.
@interface SUDOPMenuButtonBoundingClientRect : NSObject

/// The width of the menu button.
@property (nonatomic, assign) NSInteger width;

/// The height of the menu button.
@property (nonatomic, assign) NSInteger height;

/// The distance from the top edge of the viewport to the top edge of the menu button.
@property (nonatomic, assign) NSInteger top;

/// The distance from the left edge of the viewport to the right edge of the menu button.
@property (nonatomic, assign) NSInteger right;

/// The distance from the top edge of the viewport to the bottom edge of the menu button.
@property (nonatomic, assign) NSInteger bottom;

/// The distance from the left edge of the viewport to the left edge of the menu button.
@property (nonatomic, assign) NSInteger left;

@end

NS_ASSUME_NONNULL_END
