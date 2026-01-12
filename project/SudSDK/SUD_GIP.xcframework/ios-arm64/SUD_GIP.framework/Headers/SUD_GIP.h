#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ISUDListener.h"
#import "ISUDCfg.h"
#import "ISUDLogger.h"
#import "SUDInitSDKParamModel.h"
#import "SUDLoadMGParamModel.h"
#import "SUDNetworkCheckParamModel.h"
#import "ISUDListener.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ISUDFSTAPP;
@protocol ISUDFSMMG;
@protocol ISUDListenerPrepareGame;

@interface SUD_GIP : NSObject

/**
 * 获取SDK版本
 * @return 示例:"1.1.35.286"
 */
+ (NSString*_Nonnull)getVersion;

/**
 * 获取SDK版本别名
 * @return 示例:"v1.1.35.286-et"
 */
+ (NSString*_Nonnull)getVersionAlias;

+ (id<ISUDCfg>_Nonnull)getCfg;

/**
 * 初始化SDK
 * @param model SUDInitSDKParamModel
 * @param listener ISUDListenerInitSDK
 * 最低版本：v1.1.54.xx
 */
+ (void)initSDK:(SUDInitSDKParamModel*)model
       listener:(ISUDListenerInitSDK _Nullable )listener;

/**
 * 反初始化SDK
 * @param listener ISUDListenerUninitSDK
 */
+ (void)uninitSDK:(ISUDListenerUninitSDK _Nullable )listener;

/**
 * 获取游戏列表
 * @param listener ISUDListenerGetMGList
 */
+ (void)getMGList:(ISUDListenerGetMGList _Nullable )listener;

/**
 * 加载游戏
 * @param model SUDLoadMGParamModel
 * @param fsmMG ISUDFSMMG
 * @return ISUDFSTAPP
 * 最低版本：v1.1.54.xx
 */
+ (id<ISUDFSTAPP>_Nonnull)loadMG:(SUDLoadMGParamModel*_Nonnull)model
                           fsmMG:(id<ISUDFSMMG>_Nonnull)fsmMG;

/**
 * 销毁游戏
 * @param fstAPP 加载游戏返回的对象ISUDFSTAPP
 * @return boolean
 */
+ (bool)destroyMG:(id<ISUDFSTAPP>_Nonnull) fstAPP;

/**
 * 预加载游戏包列表
 * @param mgIdList 游戏ID列表
 */
+ (void) prepareGameList:(NSArray<NSNumber *> *) mgIdList listener:(id<ISUDListenerPrepareGame>) listener;

/**
 * 取消预加载游戏包
 * @param mgIdList 游戏ID列表
 */
+ (void) cancelPrepareGameList:(NSArray<NSNumber *> *) mgIdList;

/**
 * 设置统计上报回调
 * @param listener 回调
 * @return 返回值
 */
+ (bool)setReportStatsEventListener:(ISUDListenerReportStatsEvent)listener;

/**
 * 设置日志等级
 * @param logLevel 输出log的等级,SudLogVERBOSE,SudLogDEBUG,SudLogINFO 见ISUDLogger.h
 */
+ (void)setLogLevel:(SudLogType)logLevel;

/// 获取SDK本地日志存储路径
+ (NSString *_Nonnull)getLogDirPath;

/// 开启网络检测，检测当前网络环境下，SDK连通性
/// @param paramModel 检测参数
/// @param listener 检测结果回调
+ (void)startNetworkDetection:(SudNetworkDetectionParamModel *)paramModel listener:(INetworkDetectionListener)listener;


@end

NS_ASSUME_NONNULL_END
