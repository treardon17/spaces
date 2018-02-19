[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=phranck&url=https://github.com/phranck/CCNLaunchAtLoginItem&title=CCNLaunchAtLoginItem&tags=github&category=software)



## Overview

`CCNLaunchAtLoginItem` is a Objective-C class that encapsulates the functionality for launching a Mac application automatic on login, presented in a very simple interface.


## Integration

You can add `CCNLaunchAtLoginItem` by using CocoaPods. Just add this line to your Podfile:

```
pod 'CCNLaunchAtLoginItem'
```


## Usage

The general use case couldn't be simpler. Somewhere in your preferences view controller place a checkbox, add an appropriate `NSButton` property, name it `launchAtLoginCheckbox` (just like in the example below), add an `IBAction`, whire all the stuff and you're nearly done:

```Objective-C
- (void)viewDidLoad {
   ...
   // init the login item
   self.loginItem = [CCNLaunchAtLoginItem itemForBundle:[NSBundle mainBundle]];
   // restore the current state
   self.launchAtLoginCheckbox.state = ([self.loginItem isActive] ? NSOnState : NSOffState);
   ...
}

- (IBAction)launchAtLoginCheckboxAction:(NSButton *)launchAtLoginCheckbox {
    switch (launchAtLoginCheckbox.state) {
        case NSOnState:     [self.loginItem activate]; break;
        case NSOffState:    [self.loginItem deActivate]; break;
    }
}
```

That's all!


## Requirements

`CCNLaunchAtLoginItem` was written using ARC and "modern" Objective-C 2. At the moment it has only support for OS X 10.10 Yosemite. OS X 10.9 Mavericks should work too, but it's untested yet.


## Contribution

The code is provided as-is, and it is far off being complete or free of bugs. If you like this component feel free to support it. Make changes related to your needs, extend it or just use it in your own project. Pull-Requests and Feedbacks are very welcome. Just contact me at [phranck@cocoanaut.com](mailto:phranck@cocoanaut.com?Subject=[CCNLaunchAtLoginItem] Your component on Github) or send me a ping on Twitter [@TheCocoaNaut](http://twitter.com/TheCocoaNaut). 


## Documentation
The complete documentation you will find on [CocoaDocs](http://cocoadocs.org/docsets/CCNLaunchAtLoginItem/).


## License
This software is published under the [MIT License](http://cocoanaut.mit-license.org).
