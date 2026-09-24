# OpenPaaS

[SUD OpenPaaS](https://developer.sud.tech)

## Requirements

- iOS 15.0+ for the current binary SDK integration
- Xcode with the iOS SDK
- CocoaPods

## Installation

The SDKs are published in the public CocoaPods Specs repository. Add the following to your `Podfile`, replacing `YourAppTarget` with your app target name:

```ruby
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '15.0'
use_frameworks!

target 'YourAppTarget' do
  pod 'SUDGI', '~> 2.1.0'

  # Include this subspec when using AdMob advertising.
  pod 'SUDM/admob', '~> 2.1.0'
end
```

`SUDCoreKit` is brought in by `SUDGI`. `SUDM/admob` also brings in `SUDCoreKit`, `SUDReport` and the Google Mobile Ads SDK. You do not need to declare `SUDCoreKit` or `SUDReport` separately.

Then run:

```bash
pod install --repo-update
```

Open the generated `.xcworkspace` file instead of the `.xcodeproj` file.

## Run QuickStart

From the repository root:

```bash
cd project/Example/QuickStart
pod install --repo-update
open QuickStart.xcworkspace
```

Select the `QuickStart` scheme and an iOS 15.0+ simulator or device. For a device build, configure your development team and signing in Xcode.

The sample uses remote `SUDGI` and `SUDM/admob` with the version constraint `~> 2.1.0` (at least `2.1.0` and below `2.2.0`). `SUDOPWrappedClientKit` remains a local dependency at `../../SUDOPWrappedClientKit/` and is included in this repository.

To use local SDKs for development, uncomment the four local dependency lines in the sample Podfile and comment out the two remote SDK lines. Do not enable local and remote declarations for the same SDK at the same time. Run `pod install` after switching.

## Import

Objective-C:

```objc
#import <SUDGI/SUDOP.h>
```

For Swift, add the same import to your app's Objective-C bridging header:

```objc
#import <SUDGI/SUDOP.h>
```

## Troubleshooting

If CocoaPods cannot find `SUDGI (~> 2.1.0)` or another newly published SDK version, check the public Specs source in your Podfile and run `pod install --repo-update`.

If the CocoaPods CDN reports download or HTTP/2 errors, use the official GitHub Specs source shown above. A private Specs repository is not required. The first GitHub Specs checkout may take longer than a CDN update.

For sample-specific instructions, see [QuickStart (中文)](project/Example/QuickStart/README.md) or [QuickStart (English)](project/Example/QuickStart/README_en.md).
