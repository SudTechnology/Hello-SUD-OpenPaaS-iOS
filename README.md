# OpenPaaS

[SUD OpenPaaS](https://developer.sud.tech)


## Requirements

- iOS 11.0+
- CocoaPods

## Installation

Add the following line to your `Podfile`:

```ruby
platform :ios, '11.0'

target 'YourAppTarget' do
  use_frameworks!

  pod 'SUDGI', '2.0.0'
end
```

Then run:

```bash
pod install --repo-update
```

Open the generated `.xcworkspace` file.

## Import

Objective-C:

```objc
#import <SUDGI/SUDGI.h>
```

Swift:

Add to your Bridging Header:

```objc
#import <SUDGI/SUDGI.h>
```

## Troubleshooting

If you see:

```text
Unable to find a specification for `SUDGI (= 2.0.0)`
```

Please make sure the CocoaPods spec source is configured correctly. If `SUDGI` is hosted in a private Specs repo, add it to your `Podfile`:

```ruby
source 'https://cdn.cocoapods.org/'
source 'https://your-private-spec-repo-url.git'
```

Then run:

```bash
pod install --repo-update
```
