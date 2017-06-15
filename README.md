# ByvMenuNav

[![CI Status](http://img.shields.io/travis/Adrian Apodaca macbook air/ByvMenuNav.svg?style=flat)](https://travis-ci.org/Adrian Apodaca macbook air/ByvMenuNav)
[![Version](https://img.shields.io/cocoapods/v/ByvMenuNav.svg?style=flat)](http://cocoapods.org/pods/ByvMenuNav)
[![License](https://img.shields.io/cocoapods/l/ByvMenuNav.svg?style=flat)](http://cocoapods.org/pods/ByvMenuNav)
[![Platform](https://img.shields.io/cocoapods/p/ByvMenuNav.svg?style=flat)](http://cocoapods.org/pods/ByvMenuNav)

## ByvMenuNav

Is an UINavigationController than manage menus. 
If the status bar style is going to be changed you must add `View controller-based status bar appearance = NO`to project plist

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ByvMenuNav is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ByvMenuNav"
```

## Usage

Set root `UINavigationController` class to `ByvMenuNav` class.

Menu view must implement `ByvMenu` protocol. For default left menu you can assign it in three different ways. 

**1.- From storyboard**
Create an UIViewController with `StoryBoard ID` = `ByvLeftMenuVC`

**2.- From storyboard with other StoryBoard ID**
Dynamically update the custom StoryBoard Id `ByvMenuNav.instance.leftMenuIdentifier = "MyCustomByvLeftMenuVCStoryBoardId"`

**3.- Updating leftMenu**
Dynamically update the `leftMenu` var `ByvMenuNav.instance.leftMenu = myCustomByvLeftMenu`

## Mode

The menu button can be displayed only in the root view controller or in all view controllers setting  `allwaysShowLeftMenuButton = true`.

The root controller will add a pan gesture to display the menu
    `addPanGesture = true`.

Be carefull if the root view controller is an UITableViewController or any controller with a UIScrollView as root view. In this case pan gesture isn't added to allow scrolling... It can be added if you add the UIScrollView as a subview 

## Author

Adrian Apodaca, adrian@byvapps.com

## License

ByvMenuNav is available under the MIT license. See the LICENSE file for more info.
