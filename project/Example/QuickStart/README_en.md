[中文](README.md)

# QuickStart

## Requirements

- iOS 15.0+
- Xcode and CocoaPods

## Install and Run

From the repository root:

```bash
cd project/Example/QuickStart
pod install --repo-update
open QuickStart.xcworkspace
```

Select the `QuickStart` scheme and a simulator or device. Configure your development team and signing before running on a device.

## SDK Dependencies

The Podfile uses the official CocoaPods GitHub Specs source and published SDK versions:

```ruby
source 'https://github.com/CocoaPods/Specs.git'

# These declarations belong inside the QuickStart target.
pod 'SUDGI', '~> 2.1.0'
pod 'SUDM/admob', '~> 2.1.0'
```

`SUDGI` brings in `SUDCoreKit`. `SUDM/admob` also brings in `SUDCoreKit`, `SUDReport` and the Google Mobile Ads SDK. No separate declarations for the core or reporting components are needed.

The sample wrapper remains a local dependency:

```ruby
pod 'SUDOPWrappedClientKit', :path => '../../SUDOPWrappedClientKit/'
```

To develop against local SDKs, uncomment the four local SDK lines in the Podfile and comment out the two remote SDK lines, then run `pod install`. Do not enable both local and remote declarations for the same SDK.

See the [repository README](../../../README.md) for host app integration.

## Documentation

[Developer documentation](https://developer.sud.tech/openpaas/app/guide/guide-dev/start.html)
