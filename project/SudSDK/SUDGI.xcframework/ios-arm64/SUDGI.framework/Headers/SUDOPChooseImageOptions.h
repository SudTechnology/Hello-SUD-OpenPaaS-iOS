//
//  SUDOPChooseImageOptions.h
//  SUDGI
//
//  Created by kaniel on 5/14/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kSUDOPImageSourceTypeAlbum = @"album";
static NSString * const kSUDOPImageSourceTypeCamera = @"camera";

static NSString * const kSUDOPImageSizeTypeOriginal = @"original";
static NSString * const kSUDOPImageSizeTypeCompressed = @"compressed";

/**
 Options for configuring image selection behavior.
 */
@interface SUDOPChooseImageOptions : NSObject

/**
 The maximum number of images that can be selected.
 @default 9
 */
@property(nonatomic, assign) NSInteger count;

/**
 The size types of images to be selected.
 Possible values: 'original' (original size), 'compressed' (compressed size)
 */
@property(nonatomic, strong) NSArray<NSString *> *sizeType;

/**
 The sources for selecting images.
 Possible values: 'album' (photo library), 'camera' (camera)
 */
@property(nonatomic, strong) NSArray<NSString *> *sourceType;

@end

NS_ASSUME_NONNULL_END
