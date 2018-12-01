# IOPatternLock
An easy-to-use, customizable Android Pattern Lock view for iOS
![IOPatternLock](https://raw.githubusercontent.com/ilk33r/IOPatternLock/master/Demo.gif)

## Specs
This library allows you to implement pattern locking mechanism in your app **easily and quickly**. It is very easy to use and there are **plenty of customization options** available to change the functionality and look-and-feel of this view to match your needs.

## Installation
### Cocoapods
The easiest way of installing IOPatternLock is via CocoaPods.

```bash
pod 'IOPatternLock', '~> 1.0.0'
```

### Carthage
To integrate IOPatternLock into your Xcode project using Carthage, specify it in your `Cartfile`:

```bash
github "ilk33r/IOPatternLock" ~> 1.0.0
```

Run `carthage update` to build the framework and drag the built `IOPatternLock.framework` into your Xcode project.

## Usage
![IOPatternLock](https://raw.githubusercontent.com/ilk33r/IOPatternLock/master/Usage.gif)

### Delegate
You can implement IOPatternLockDelegate to use following methods.

Delegate methods that you can use:

```objective-c
- (void)ioPatternLockView:(IOPatternLockView *)patternLockView patternCompleted:(NSArray<NSNumber *> *)selectedPatterns;
- (void)ioPatternLockView:(IOPatternLockView *)patternLockView patternCompletedWithError:(NSError *)error;
```

```swift
func ioPatternLockView(_ patternLockView: IOPatternLockView, patternCompleted selectedPatterns: [NSNUmber]);
func ioPatternLockView(_ patternLockView: IOPatternLockView, patternCompletedWithError error: NSError);
```

## License
IOPatternLock is released under the MIT license. [See LICENSE](https://github.com/ilk33r/IOPatternLock/blob/master/LICENSE) for details.