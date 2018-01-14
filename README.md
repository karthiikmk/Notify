# Notify

[![Version](https://img.shields.io/cocoapods/v/Notify.svg?style=flat)](http://cocoapods.org/pods/Notify)
[![License](https://img.shields.io/cocoapods/l/Notify.svg?style=flat)](http://cocoapods.org/pods/Notify)
[![Platform](https://img.shields.io/cocoapods/p/Notify.svg?style=flat)](http://cocoapods.org/pods/Notify)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![Effect](https://github.com/karthikAdaptavant/Notify//raw/master/Notify2.gif)

## Requirements

## Installation

Notify is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Notiefy'
```

## How to use

```swift
    Notify.shared.add(on: self.navigationController!)
             .delegate(for: self)
             .message(message: "This is example")
             .closeIcon(icon: .closeWhite)
             .messageAlignment(alignment: .left)
             .show()
```
## Author

karthikAdaptavant, karthik.samy@a-cti.com

## License

Notify is available under the MIT license. See the LICENSE file for more info.
