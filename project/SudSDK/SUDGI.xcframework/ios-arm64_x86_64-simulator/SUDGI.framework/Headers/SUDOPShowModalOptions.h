//
//  SUDOPShowModalOptions.h
//  SUDGI
//
//  Created by kaniel on 5/25/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Options for configuring modal dialog box display behavior.
 */
@interface SUDOPShowModalOptions : NSObject

/**
 The title text of the modal dialog.
 */
@property(nonatomic, strong) NSString *title;

/**
 The content message text of the modal dialog.
 */
@property(nonatomic, strong) NSString *content;

/**
 Whether to show the cancel button.
 When set to YES, a cancel button will be displayed alongside the confirm button.
 */
@property(nonatomic, assign) BOOL showCancel;

/**
 The text of the cancel button.
 Maximum length is 4 characters.
 */
@property(nonatomic, strong) NSString *cancelText;

/**
 The text color of the cancel button.
 Must be a hex format color string (e.g., "#FF0000").
 */
@property(nonatomic, strong) NSString *cancelColor;

/**
 The text of the confirm button.
 Maximum length is 4 characters.
 */
@property(nonatomic, strong) NSString *confirmText;

/**
 The text color of the confirm button.
 Must be a hex format color string (e.g., "#00FF00").
 */
@property(nonatomic, strong) NSString *confirmColor;

/**
 Whether to show an input field (editable text box) in the modal dialog.
 When set to YES, users can input text.
 */
@property(nonatomic, assign) BOOL editable;

/**
 The placeholder text to display when the input field is empty.
 Only applicable when editable is set to YES.
 */
@property(nonatomic, strong) NSString *placeholderText;

@end

NS_ASSUME_NONNULL_END
