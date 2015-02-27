# ESPinEntryView
iOS7 style passcode lock. Fully customizable.

## Examples
![](https://raw.githubusercontent.com/e-sites/ESPinEntryView/master/Assets/espinentryview1.gif)
![](https://raw.githubusercontent.com/e-sites/ESPinEntryView/master/Assets/espinentryview2.gif)


## Installation

```pod 'ESPinEntryView', '~> 1.0'```


## Usage

### ESPinEntryView
```#import <ESPinEntryView.h>```

```objc
ESPinEntryView *entryView = [[ESPinEntryView alloc] initWithFrame:self.view.bounds];
[entryView setBackgroundBlurRadius:15];
[entryView setBackgroundView:[[UIView alloc] init]];
[entryView.backgroundView setBackgroundColor:[UIColor blueColor]];
[entryView setShowAlphabet:YES];
[entryView setShowCancelButton:YES];
[self.view addSubview:entryView];
```

### ESPinEntryViewController
```#import <ESPinEntryViewController.h>```

```objc
ESPinEntryViewController *viewController = [[ESPinEntryViewController alloc] init];
[viewController.pinEntryView setBackgroundBlurRadius:15];
[viewController.pinEntryView setBackgroundView:[[UIView alloc] init]];
[viewController.pinEntryView setBackgroundColor:[UIColor blueColor]];
[viewController.pinEntryView setShowAlphabet:YES];
[viewController.pinEntryView setShowCancelButton:YES];
[self presentViewController:viewController animated:YES completion:nil];
```

## Customize

### Localization
- `deleteText`: The text in the delete button (default = "Delete")
- `cancelText`: The text in the cancel button (default = "Cancel")
- `headerText`: The top text that asks the user to enter a passcode (default = "Enter Passcode")

### Appearance
- `showCancelButton`: Should the cancel button appear when no digits are entered (Default = NO)
- `showAlphabet`: Should the entry buttons contain alphabet characters. (Default = NO)
- `backgroundView`: Should the entry buttons contain alphabet characters. (Default = Blue/grayish background)
- `backgroundBlurRadius`: The blur radius given to the background view (Default = 15)
- `backgroundColor`: The background color that overlays the backgroundView (Default = 70% alpha black)

### Validation
- `numberOfDigits`: The total number of digits that should be entered. (Default = 4)
- `attempts`: The total number of attempts (readonly)
- `code`: The code that is entered. (readonly)
- `vibrate`: Should the device vibrate when an incorrect entry is given (Default = YES)

### General
- `delegate`