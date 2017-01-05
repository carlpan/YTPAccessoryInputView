# YTPAccessoryInputView

[![CI Status](http://img.shields.io/travis/carlpan/YTPAccessoryInputView.svg?style=flat)](https://travis-ci.org/carlpan/YTPAccessoryInputView)
[![Version](https://img.shields.io/cocoapods/v/YTPAccessoryInputView.svg?style=flat)](http://cocoapods.org/pods/YTPAccessoryInputView)
[![License](https://img.shields.io/cocoapods/l/YTPAccessoryInputView.svg?style=flat)](http://cocoapods.org/pods/YTPAccessoryInputView)
[![Platform](https://img.shields.io/cocoapods/p/YTPAccessoryInputView.svg?style=flat)](http://cocoapods.org/pods/YTPAccessoryInputView)

Easy way to add accessory input view to custom input tool bar.

## Introduction

Typically in chat page or comment page of the app, you will need to attach an input tool bar to the bottom of the view. This input tool bar will contain a textfield and a button. Sometimes you will find writing chat messages or comments not enough, you will probably want to send stickers, payments, contact info, location info, etc. The easiest way you would do is to add an extra button to the input tool bar and connect it to an action sheet. With this category, you can do more than that, just design an input view and tell the ViewController your input view.

## Demo

## Installation
*YTPAccessoryInputView requires iOS 10.0 or later.*

### Using [CocoaPods](http://cocoapods.org)
1. Simply add the following line to your Podfile:

```ruby
pod "YTPAccessoryInputView"
```
2. Run `pod install` and then open your project's `.xcworkspace` file to launch XCode.
3. Put `@import YTPAccessoryInputView;` in the ViewController containing your TableView or CollectionView where you want to add accessory input view.

## Example
Imagine you already connected your input tool bar, input tool bar button, and the bottom layout constraint.

```Objective-C
@property (weak, nonatomic) IBOutlet UIView *chatInputToolBar;  // Your tool bar 
@property (weak, nonatomic) IBOutlet UIButton *chatInputToolBarButton;  // Button in your tool bar to bring accessory input view up
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;  // Constraint from input tool bar to the bottom of the view
```
Now tell your view controller the custom input view you want to use.

```Objective-C
UIView *inputView = [[[NSBundle mainBundle] loadNibNamed:@"YourInputView" owner:self options:nil] firstObject];
self.accessoryInputView = inputView;

self.inputToolBar = self.chatInputToolBar;
self.inputToolBarBottomSpace = self.bottomConstraint;
```
Then configure your input view with following call
```Objective-C
[self ytp_configureAccessoryInputView];
```
Next step is to connect the button to trigger your custom input view. In the IBAction of your button, add following
``` Objective-C
[self ytp_toggleAccessoryInputViewWithButton:self.chatInputToolBarButton];
```
Finally, if you want dissmiss keyboard or your custom accessory input view, for example
```Objective-C
[self ytp_dismissKeyboardOrAccessoryInputView];
```
That's it!!

## Author

carlpan, carlpan66@gmail.com

## License

YTPAccessoryInputView is available under the MIT license. See the LICENSE file for more info.
