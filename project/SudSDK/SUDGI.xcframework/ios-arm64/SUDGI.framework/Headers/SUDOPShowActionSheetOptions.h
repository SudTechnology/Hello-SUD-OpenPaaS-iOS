//
//  SUDOPShowActionSheetOptions.h
//  SUDGI
//
//  Created by kaniel on 5/24/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Options for configuring action sheet display behavior.
 */
@interface SUDOPShowActionSheetOptions : NSObject

/**
 The warning or alert text displayed at the top of the action sheet.
 (e.g., "Are you sure?", "This action cannot be undone.")
 */
@property(nonatomic, strong) NSString *alertText;

/**
 The list of button titles to be displayed in the action sheet.
 The maximum length of the array is 6.
 */
@property(nonatomic, strong) NSArray<NSString *> *itemList;

/**
 The text color of the buttons (e.g., "#FF0000").
 */
@property(nonatomic, strong) NSString *itemColor;

@end

NS_ASSUME_NONNULL_END
