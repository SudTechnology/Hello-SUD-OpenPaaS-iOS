//
//  SUDOPPrivacyConfig.h
//  SUDGI
//
//  A privacy configuration snapshot that the host may set before initializing
//  OP. Every status defaults to an unset state; unset statuses are not applied
//  to the ad SDK. This object only carries privacy states already confirmed by
//  the host. It does not present consent dialogs, determine region or legal
//  applicability, or replace a CMP.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// User consent status under GDPR and similar regulations such as the EEA.
typedef NS_ENUM(NSInteger, SUDOPGdprConsentStatus) {
    /// The host has not set this status.
    kSUDOPGdprConsentStatusUnset = -1,
    /// The current user or region is not subject to GDPR consent requirements.
    kSUDOPGdprConsentStatusNotApplicable = 0,
    /// The user has granted consent for ad-related data processing.
    kSUDOPGdprConsentStatusGranted = 1,
    /// The user has not granted or has withdrawn consent for ad-related data processing.
    kSUDOPGdprConsentStatusDenied = 2,
};

/// Whether the user has opted out of the sale or sharing of personal information under US state privacy regulations.
typedef NS_ENUM(NSInteger, SUDOPDoNotSellStatus) {
    /// The host has not set this status.
    kSUDOPDoNotSellStatusUnset = -1,
    /// The current user or region is not subject to US state sale/sharing opt-out requirements.
    kSUDOPDoNotSellStatusNotApplicable = 0,
    /// The user has opted out of sale or sharing.
    kSUDOPDoNotSellStatusOptedOut = 1,
    /// The user has not opted out of sale or sharing.
    kSUDOPDoNotSellStatusNotOptedOut = 2,
};

/// User consent status under the Brazilian LGPD.
typedef NS_ENUM(NSInteger, SUDOPLgpdConsentStatus) {
    /// The host has not set this status.
    kSUDOPLgpdConsentStatusUnset = -1,
    /// The current user or region is not subject to LGPD consent requirements.
    kSUDOPLgpdConsentStatusNotApplicable = 0,
    /// The user has granted consent for ad-related data processing.
    kSUDOPLgpdConsentStatusGranted = 1,
    /// The user has not granted or has withdrawn consent for ad-related data processing.
    kSUDOPLgpdConsentStatusDenied = 2,
};

/// Age-restricted treatment status for children or teenagers.
typedef NS_ENUM(NSInteger, SUDOPAgeRestrictedTreatment) {
    /// The host has not set this status.
    kSUDOPAgeRestrictedTreatmentUnset = -1,
    /// Child or teenage ad treatment is not specified.
    kSUDOPAgeRestrictedTreatmentUnspecified = 0,
    /// The user meets the definition of a child under applicable law.
    kSUDOPAgeRestrictedTreatmentChild = 1,
    /// The ad platform should treat the user as a teenager, but not as a child.
    kSUDOPAgeRestrictedTreatmentTeen = 2,
};

/// Privacy configuration snapshot. Every status defaults to unset; the integrator
/// creates the object and assigns only the statuses it has confirmed.
@interface SUDOPPrivacyConfig : NSObject

/// GDPR consent status; defaults to unset.
@property(nonatomic, assign) SUDOPGdprConsentStatus gdprConsentStatus;
/// US state sale/sharing opt-out status; defaults to unset.
@property(nonatomic, assign) SUDOPDoNotSellStatus doNotSellStatus;
/// LGPD consent status; defaults to unset.
@property(nonatomic, assign) SUDOPLgpdConsentStatus lgpdConsentStatus;
/// Child or teenage age-restricted treatment status; defaults to unset.
@property(nonatomic, assign) SUDOPAgeRestrictedTreatment ageRestrictedTreatment;

@end

NS_ASSUME_NONNULL_END
