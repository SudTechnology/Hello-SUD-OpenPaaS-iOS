//
//  SudBaseRespModel.h
//  SudMGP
//
//  Created by kaniel on 2024/5/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUDDemoBaseRespModel : NSObject
@property(nonatomic, assign)NSInteger ret_code;
@property(nonatomic, strong)NSString *ret_msg;
@property(nonatomic, strong)NSDictionary * srcData;
/// 解码消息
/// @param srcData 根JSON
+ (instancetype)decodeModel:(id)srcData;

@end

NS_ASSUME_NONNULL_END
