//
//  SUDOPPreviewImageOptions.h
//  SUDGI
//
//  Created by kaniel on 5/26/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Options for configuring image preview behavior.
 */
@interface SUDOPPreviewImageOptions : NSObject

/**
 The URL link of the currently displayed image.
 This image will be shown first when the preview opens.
 */
@property(nonatomic, strong) NSString *current;

/**
 The list of image URL links to be previewed.
 Users can swipe left/right to browse through all images in this list.
 */
@property(nonatomic, strong) NSArray<NSString *> *urls;

@end

NS_ASSUME_NONNULL_END
