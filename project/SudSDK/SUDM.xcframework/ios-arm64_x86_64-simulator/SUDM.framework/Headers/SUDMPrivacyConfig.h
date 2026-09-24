//
//  SUDMPrivacyConfig.h
//  SUDM
//
//  An optional immutable privacy configuration snapshot for ad SDK initialization.
//  Every status defaults to unset; unset statuses are not applied to the ad SDK.
//  This object only carries privacy states already confirmed by the host. It does
//  not present consent dialogs, determine region or legal applicability, or replace
//  a CMP.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// User consent status under GDPR and similar regulations such as the EEA.
typedef NS_ENUM(NSInteger, SUDMGdprConsentStatus) {
    /// The host has not set this status.
    SUDMGdprConsentStatusUnset = -1,
    /// The current user or region is not subject to GDPR consent requirements.
    SUDMGdprConsentStatusNotApplicable = 0,
    /// The user has granted consent for ad-related data processing.
    SUDMGdprConsentStatusGranted = 1,
    /// The user has not granted or has withdrawn consent for ad-related data processing.
    SUDMGdprConsentStatusDenied = 2,
};

/// Whether the user has opted out of the sale or sharing of personal information under US state privacy regulations.
typedef NS_ENUM(NSInteger, SUDMDoNotSellStatus) {
    /// The host has not set this status.
    SUDMDoNotSellStatusUnset = -1,
    /// The current user or region is not subject to US state sale/sharing opt-out requirements.
    SUDMDoNotSellStatusNotApplicable = 0,
    /// The user has opted out of sale or sharing.
    SUDMDoNotSellStatusOptedOut = 1,
    /// The user has not opted out of sale or sharing.
    SUDMDoNotSellStatusNotOptedOut = 2,
};

/// User consent status under the Brazilian LGPD.
typedef NS_ENUM(NSInteger, SUDMLgpdConsentStatus) {
    /// The host has not set this status.
    SUDMLgpdConsentStatusUnset = -1,
    /// The current user or region is not subject to LGPD consent requirements.
    SUDMLgpdConsentStatusNotApplicable = 0,
    /// The user has granted consent for ad-related data processing.
    SUDMLgpdConsentStatusGranted = 1,
    /// The user has not granted or has withdrawn consent for ad-related data processing.
    SUDMLgpdConsentStatusDenied = 2,
};

/// Age-restricted treatment status for children or teenagers.
typedef NS_ENUM(NSInteger, SUDMAgeRestrictedTreatment) {
    /// The host has not set this status.
    SUDMAgeRestrictedTreatmentUnset = -1,
    /// Child or teenage ad treatment is not specified.
    SUDMAgeRestrictedTreatmentUnspecified = 0,
    /// The user meets the definition of a child under applicable law.
    SUDMAgeRestrictedTreatmentChild = 1,
    /// The ad platform should treat the user as a teenager, but not as a child.
    SUDMAgeRestrictedTreatmentTeen = 2,
};

/// Privacy configuration snapshot. Every status defaults to unset; the integrator
/// creates the object and assigns only the statuses it has confirmed.
@interface SUDMPrivacyConfig : NSObject

/// GDPR consent status; defaults to unset.
@property (nonatomic, assign) SUDMGdprConsentStatus gdprConsentStatus;
/// US state sale/sharing opt-out status; defaults to unset.
@property (nonatomic, assign) SUDMDoNotSellStatus doNotSellStatus;
/// LGPD consent status; defaults to unset.
@property (nonatomic, assign) SUDMLgpdConsentStatus lgpdConsentStatus;
/// Child or teenage age-restricted treatment status; defaults to unset.
@property (nonatomic, assign) SUDMAgeRestrictedTreatment ageRestrictedTreatment;

@end

NS_ASSUME_NONNULL_END