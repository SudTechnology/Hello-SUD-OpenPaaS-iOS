//
//  SudParamModels.h
//  SudMGP
//
//  Created by kaniel on 2024/5/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDMBaseReqModel : NSObject
/// 解码JSON
+ (instancetype)decodeFromJSON:(id)dic;
- (NSDictionary *)toJSON;
- (NSString *)toJSONStr;
@end

@interface SUDMAdConfigReqBasicInfo : NSObject
@property(nonatomic, strong)NSString *etag;
@property(nonatomic, strong)NSString *device_id;
@property(nonatomic, assign)NSInteger os_type;
@property(nonatomic, assign)NSInteger timestamp;
@end

@interface SUDMAdConfigReqModel : SUDMBaseReqModel
@property(nonatomic, strong)NSString *app_id;
@property(nonatomic, strong)NSString *bundle_key;
@property(nonatomic, strong)SUDMAdConfigReqBasicInfo *basic_info;
@end
NS_ASSUME_NONNULL_END
