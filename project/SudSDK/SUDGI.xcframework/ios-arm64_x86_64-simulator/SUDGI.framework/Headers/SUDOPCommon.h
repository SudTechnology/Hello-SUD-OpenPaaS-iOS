//
//  SUDOPCommon.h
//  SUDGI
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SUDRTGameHandle;
@protocol SUDOPGameHandleProvider;
#pragma mark - Common Types

typedef NS_ENUM(NSInteger, SUDOPFIDType) {
    /// MD5
    SUDOPFIDTypeMD5 = 0,
    /// CRC32
    SUDOPFIDTypeCRC32 = 1,
    /// SHA1
    SUDOPFIDTypeSHA1 = 2,
    /// SHA256
    SUDOPFIDTypeSHA256 = 3,
};

/**
 * Completion block for general asynchronous operations.
 * @param error An error object if the operation failed, or nil if it succeeded.
 */
typedef void(^SUDOPCompletion)(NSError *_Nullable error);

typedef void(^SUDOPDidGameHandleCreated)(id<SUDRTGameHandle>gameHandle);

/**
 * Completion block for game-related operations (download, load, start).
 * @param gameHandleProvider Provides the game handle upon success.
 * @param error An error object if the operation failed, or nil if it succeeded.
 */
typedef void(^SUDOPGameOperationCompletion)(id<SUDOPGameHandleProvider> _Nullable gameHandleProvider, NSError *_Nullable error);

#pragma mark - Protocols

/**
 * Protocol providing access to the game handle.
 */
@protocol SUDOPGameHandleProvider <NSObject>

/**
 * Returns the game handle associated with the current operation.
 * @return An instance of SUDRTGameHandle.
 */
- (id<SUDRTGameHandle>)gameHandle;

@end

/**
 * SUDOPStateHandle
 * A protocol used by the host app to acknowledge the completion of an asynchronous request
 * initiated by the SDK.
 */
@protocol SUDOPStateHandle <NSObject>

/**
 * Notifies the SDK that the operation succeeded.
 * * @param dataJson A JSON-formatted string containing the requested data or business result.
 * If no payload is required, pass an empty JSON object "{}" instead of nil.
 */
- (void)success:(nonnull NSString *)dataJson;

/**
 * Notifies the SDK that the operation failed.
 * * @param error error details.
 */
- (void)failure:(nonnull NSError *)error;

@end

#pragma mark - Models


/// Initialization parameters
@interface SUDOPSDKConfiguration : NSObject

/// App ID
@property(nonatomic, strong) NSString *appId;
/// App Key
@property(nonatomic, strong) NSString *appKey;

@end

/// Base options describing a game package.
///
/// This object contains metadata used to identify and verify a game package.
/// It is typically used together with path or URL based game loading APIs.
@interface SUDOPGamePackageOptions : NSObject

/// Version of the game package.
@property (nonatomic, copy) NSString *version;

/// File identifier used to verify the package integrity.
@property (nonatomic, copy) NSString *fid;

/// Hash algorithm used for the file identifier.
@property (nonatomic, assign) SUDOPFIDType fidType;

/// Game identifier provided by the application.
@property (nonatomic, copy) NSString *appGameID;

/// Content provider identifier.
@property (nonatomic, copy) NSString *appCPID;

/// Group identifier used to categorize games.
@property (nonatomic, copy) NSString *appGroupID;

@end



NS_ASSUME_NONNULL_END
