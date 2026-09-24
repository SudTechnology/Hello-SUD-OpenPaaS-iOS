//
//  SUDMLoadedSource.h
//  SUDM
//
//  加载成功的广告源数据（对应 Android SUDMAuctionLoader.LoadedSource）
//

#import <Foundation/Foundation.h>

@class SUDMBaseAdapter;
@class SUDMAdPrice;

NS_ASSUME_NONNULL_BEGIN

@interface SUDMLoadedSource : NSObject

@property (nonatomic, strong) SUDMBaseAdapter *adapter;
@property (nonatomic, strong, nullable) SUDMAdPrice *price;

+ (instancetype)sourceWithAdapter:(SUDMBaseAdapter *)adapter price:(nullable SUDMAdPrice *)price;

@end

NS_ASSUME_NONNULL_END
