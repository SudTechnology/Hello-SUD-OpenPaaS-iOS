//
//  SUDMHttpService.h
//  SUDM
//
//  Created by kaniel on 7/23/26.
//

#import <Foundation/Foundation.h>
#import "SUDCoreKit.h"
#import "SUDMHttpReqModels.h"
#import "SUDMHttpRespModels.h"
NS_ASSUME_NONNULL_BEGIN

@interface SUDMHttpService : NSObject
+(instancetype)shared;
- (void)updateSdkState;
/// 请求广告配置，返回取消句柄（调用后终止本次请求）。
- (dispatch_block_t)requestAdConfig:(SUDMAdConfigReqModel *)reqModel
                            success:(void(^_Nullable)(SUDMAdConfigRespModel * _Nonnull resp))success
                            failure:(void(^_Nullable)(NSError * _Nullable error))failure;

/// 非公开调试开关：广告配置请求（requestAdConfig）是否明文（不加密）传输。默认 NO（加密）。
/// 必须在 SDK 初始化前设置；初始化后冻结，后续设置无效。Release 同样可用，不依赖 DEBUG。
/// 只影响广告配置初始化与刷新，不影响广告事件上报。
- (void)setAdConfigPlaintextEnabled:(BOOL)enabled;
/// 读取当前生效的广告配置明文开关（初始化后为冻结快照）
- (BOOL)isAdConfigPlaintextEnabled;
/// SDK 初始化时冻结开关快照（此后 setter 不再生效）
- (void)freezeAdConfigPlaintext;
/// SDK 反初始化时重置开关与冻结状态，允许下次初始化前重新设置
- (void)resetAdConfigPlaintext;

/// 获取一个请求id（32位小写MD5）
- (NSString *)randRequestId;

/// 为指定的请求对象注册统一的body加解密处理，供独立http实例（如埋点上报）复用
- (void)registerBodyPrehandleForRequest:(SUDHttpRequest *)httpRequest;

/// 生成一次请求的完整请求头（基础头 + 签名头）
/// - Parameters:
///   - requestId: 本次请求id，需与实际请求携带的requestId一致，否则加解密key不匹配
///   - bodyContent: 请求body序列化后的json字符串，用于计算签名
- (NSDictionary *)signedHeadersWithRequestId:(NSString *)requestId bodyContent:(nullable NSString *)bodyContent;

/// 按请求头中的 requestId/appId 加密数据，用于只加密协议 data 字段的场景
- (nullable NSString *)encryptedPayloadString:(NSString *)payload headers:(NSDictionary *)headers;

/// 为指定请求对象注册响应解密处理，不改写请求 body
- (void)registerResponsePrehandleForRequest:(SUDHttpRequest *)httpRequest;

/// 统一的加密信封 POST：签名 + data 字段加密 + 响应 data 字段解密，返回可取消句柄。
/// 公共部分（requestId、签名头、加解密）统一由本方法处理。
/// - Parameters:
///   - url: 完整请求地址
///   - innerJson: 内层 body 明文 JSON（用于签名与加密）
///   - success: 成功回调，rootDict 为外层响应，data 字段已按请求头解密为明文字符串
///   - failure: 失败回调
/// - Returns: 取消 block，调用后终止本次请求
- (dispatch_block_t)postEncryptedEnvelopeWithURL:(NSString *)url
                                       innerJson:(NSString *)innerJson
                                        success:(void (^_Nullable)(NSDictionary * _Nullable rootDict))success
                                        failure:(void (^_Nullable)(id _Nullable error))failure;
@end

NS_ASSUME_NONNULL_END
