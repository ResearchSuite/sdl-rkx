# sdl-rkx

The [Small Data Lab](http://smalldata.io) ResearchKit Extensions package is the easiest way to include SDL visual surveys (YADL, MEDL, PAM) into a ResearchKit application.

## Requirements

 - iOS 9.0+
 - Xcode 7.3+

## InstallationNeil

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.0.0+ is required to build sdl-rkx 0.1.0+.

To integrate sdl-rkx into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

pod 'sdl-rkx', '~> 0.1'
```

Then, run the following command:

```bash
$ pod install
```

> NOTE: When building ResearchKit, you may need to set 'No Common Blocks' to 'No' under the Apple LLVM Code Generation heading in the ResearchKit framework Build Settings

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

James Kizer @ Cornell Tech Foundry

## License

sdl-rkx is available under the Apache 2.0 license. See the LICENSE file for more info.
