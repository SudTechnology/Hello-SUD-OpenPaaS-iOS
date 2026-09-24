//
//  ISudAsrClient.h
//  Pods
//
//  Created by kaniel on 5/9/25.
//

#ifndef ISudAsrClient_h
#define ISudAsrClient_h

typedef NS_ENUM(NSInteger, SudAsrLogLevelType) {
    SudAsrLogLevelTypeVerbose = 0,
    SudAsrLogLevelTypeDebug = 1,
    SudAsrLogLevelTypeInfo = 2,
    SudAsrLogLevelTypeWarning = 3,
    SudAsrLogLevelTypeError = 4,
};

typedef void(^SudAsrRecognizedEventHandler)(NSString *_Nullable text);
typedef void(^SudAsrErrorEventHandler)(NSInteger code, NSString *_Nullable text);
typedef void(^SudAsrLogEventHandler)(SudAsrLogLevelType level, NSString *_Nullable tag, NSString *_Nullable text);


/// Asr识别模块
@protocol ISudAsrClient <NSObject>

- (void)setLogLevel:(SudAsrLogLevelType)logLevel;

/// 设置识别结果回调
/// @param recognizedEventHandler recognizedEventHandler description
- (void)setRecognizedTextHandler:(SudAsrRecognizedEventHandler _Nullable )recognizedEventHandler;

/// 设置识别错误回调
/// @param errorEventHandler errorEventHandler description
- (void)setRecognizedErrorHandler:(SudAsrErrorEventHandler _Nullable)errorEventHandler;

/// 设置日志监听
- (void)setLogEventHandler:(SudAsrLogEventHandler _Nullable)logEventHandler;

/// 启动asr
/// @param dicConfig 配置信息
- (void)startASR:(NSDictionary *_Nonnull)dicConfig;

/// 停止asr
- (void)stopASR;

/// 识别语言数据
/// @param audioData pcm数据
- (void)pushAudio:(NSData *_Nonnull)audioData;

@end

#endif /* ISudAsrClient_h */
