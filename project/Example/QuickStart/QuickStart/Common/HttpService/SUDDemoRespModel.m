//
//  SudBaseRespModel.m
//  SudMGP
//
//  Created by kaniel on 2024/5/31.
//

#import "SUDDemoRespModel.h"

@implementation SUDDemoBaseRespModel

/// 解码消息
/// @param srcData 根JSON
+ (instancetype)decodeModel:(id)srcData {
    SUDDemoBaseRespModel *m = nil;
    NSDictionary *data = [srcData isKindOfClass:NSDictionary.class] ? srcData[@"data"] : srcData;
    if (data && [data isKindOfClass:[NSArray class]]) {
        m = [[self class] mj_objectWithKeyValues:srcData];
    } else if (data && ![data isKindOfClass:[NSNull class]]) {
        m = [[self class] mj_objectWithKeyValues:data];
    } else {
        m = [[self class] mj_objectWithKeyValues:srcData];
    }
    if (!m) {
        m = [self class].new;
    }
    if ([srcData isKindOfClass:NSDictionary.class]) {
        m.ret_msg = srcData[@"ret_msg"];
        m.ret_code = [srcData[@"ret_code"] integerValue];
    }
    m.data = data;
    m.srcData = srcData;
    return m;
}


@end

