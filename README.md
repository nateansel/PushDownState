# PushDownState
The idea for this framework came from [an observation from Max Rudberg](http://blog.maxrudberg.com/post/156814328513/ios-stiffness-the-neglected-touch-down-state). This framework seeks to make his suggestion of buttons in iOS having a “push down state” easier for developers to bring into their own projects.

![Button examples](https://images.typed.com/6ca9aec7-2259-4520-ab88-6bab49470f20/buttons.gif)

## Requirements

- iOS 9.0+
- Xcode 11.0+
- Swift 5.0+

## Installation

### Carthage
To add PushDownState to your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "nateansel/PushDownState"
```

Run `carthage update` to build the framework and drag the built `PushDownState.framework` into your Xcode project.

### Swift Package Manager
*note: Swift Package Manager Support requires Swift 5.3*

1. Navigate to project settings
2. Go to Swift Packages Tap
3. Add repository URL
4. Set version rules to `spm_support` branch.

## Usage
To use PushDownState in any file of your project, first

```swift
import PushDownState
```

To add a push down state to UIButtons, UITableViewCells, and UICollectionViewCells, simply subclass either `PushDownButton`, `PushDownTableViewCell`, or `PushDownCollectionViewCell`. A push down state will automatically be added to the UI element.

To fine tune the push down state for buttons or cells, simply edit the four values that you have access to. These values are all `@IBInspectable`, so they can be changed in your storyboard or xib files.

Currently, you can edit:

```swift
var pushDownDuration: TimeInterval
var pushDownScale: CGFloat
var pushDownRoundCorners: Bool
var pushDownBackgroundColor: UIColor?
```

## Todo

- [x] Add background color manipulation
- [ ] Add support for additional changes in the push down state

## License

PushDownState is released under the MIT license. See LICENSE for details.
