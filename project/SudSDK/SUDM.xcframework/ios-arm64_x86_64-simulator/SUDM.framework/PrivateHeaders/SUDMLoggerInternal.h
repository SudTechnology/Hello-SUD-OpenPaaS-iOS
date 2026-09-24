//
//  SUDMLoggerInternal.h
//  SUDM
//

#import <SUDCoreKit/SUDLogger.h>

NS_ASSUME_NONNULL_BEGIN

static SUDLoggerIdentifier const SUDLoggerIdentifierSUDM = @"SUDM";

#define SUDMLogE(tag, frmt, ...) \
    SudLoggerLogWithIdentifier(SUDLoggerIdentifierSUDM, SudLoggerLogFlagError, (tag), __PRETTY_FUNCTION__, (frmt), ##__VA_ARGS__)

#define SUDMLogW(tag, frmt, ...) \
    SudLoggerLogWithIdentifier(SUDLoggerIdentifierSUDM, SudLoggerLogFlagWarning, (tag), __PRETTY_FUNCTION__, (frmt), ##__VA_ARGS__)

#define SUDMLogI(tag, frmt, ...) \
    SudLoggerLogWithIdentifier(SUDLoggerIdentifierSUDM, SudLoggerLogFlagInfo, (tag), __PRETTY_FUNCTION__, (frmt), ##__VA_ARGS__)

#define SUDMLogD(tag, frmt, ...) \
    SudLoggerLogWithIdentifier(SUDLoggerIdentifierSUDM, SudLoggerLogFlagDebug, (tag), __PRETTY_FUNCTION__, (frmt), ##__VA_ARGS__)

#define SUDMLogV(tag, frmt, ...) \
    SudLoggerLogWithIdentifier(SUDLoggerIdentifierSUDM, SudLoggerLogFlagVerbose, (tag), __PRETTY_FUNCTION__, (frmt), ##__VA_ARGS__)

#define SUDMLogF(tag, frmt, ...) SUDMLogV((tag), (frmt), ##__VA_ARGS__)

NS_ASSUME_NONNULL_END
