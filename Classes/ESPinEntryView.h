//
//  ESPinEntryView.h
//  ESPinEntry
//
//  Created by Bas van Kuijck on 26-02-15.
//  Copyright (c) 2015 e-sites. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *const ESPinEntryCodeDidUpdateNotification = @"ESPinEntryCodeDidUpdateNotification";

@class ESPinEntryView;
/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	Protocol declaration for the ESPinEntryView class
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
@protocol ESPinEntryDelegate <NSObject>
@required
/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	This delegate method will be called once the total number of digits that is entered is equal to the total required digits.
 *  YES should be returned when the entered code equals the code you're expecting, else return NO
 *  @note This method is required
 *
 *	@param pinEntryView ESPinEntry*
 *	@param code         NSString*
 *
 *	@return BOOL
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
- (BOOL)pinEntry:(ESPinEntryView *)pinEntryView isValidCode:(NSString *)code;
@optional

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	This will be invoked once the "Delete" button is pressed
 *
 *	@param pinEntryView ESPinEntry*
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
- (void)pinEntryDidPressDelete:(ESPinEntryView *)pinEntryView;
/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	This will be invoked once the "Cancel" button is pressed
 *
 *	@param pinEntryView ESPinEntry*
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
- (void)pinEntryDidPressCancel:(ESPinEntryView *)pinEntryView;

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	This will be invoked once a digit is pressed
 *
 *	@param pinEntryView ESPinEntry*
 *	@param digit        NSUInteger
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
- (void)pinEntry:(ESPinEntryView *)pinEntryView didPressDigit:(NSUInteger)digit;

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	This will be invoked once the code is changed
 *
 *	@param pinEntryView ESPinEntry*
 *	@param digit        NSString*
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
- (void)pinEntry:(ESPinEntryView *)pinEntryView didChangeCode:(NSString *)code;

@end

@interface ESPinEntryView : UIView

// __________________________________________________________________________________________

/// @name Localization properties

// __________________________________________________________________________________________
/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *  
 *  The text to display when you want to delete a digit
 *  @note Default: "Delete"
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
@property (nonatomic, copy) NSString *deleteText;

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *  The text to display when you want to cancel pin entry
 *  @note Default: "Cancel"
 *  @warning This will only be visible if you set the `showCancelButton` to `YES`
 *
 *	@since 1.0
 *  @date 27/02/2015
 */

@property (nonatomic, copy) NSString *cancelText;

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *  The top text that asks the user to enter a passcode
 *  @note Default: "Enter passcode"
 *
 *	@since 1.0
 *  @date 27/02/2015
 */

@property (nonatomic, copy) NSString *headerText;

// __________________________________________________________________________________________

/// @name Appearance properties

// __________________________________________________________________________________________

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	Should the cancel button appear when no digits are entered.
 *  Pressing this button will invoke the `delegate` method `pinEntryDidPressCancel:`
 *  @note Default: NO
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
@property (nonatomic, readwrite) BOOL showCancelButton;

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	Should the entry buttons contain alphabet characters.
 *  For instance, 2 will have "ABC". 3: "DEF", 4: "GHI", etc.
 *  @note Default: NO
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
@property (nonatomic, readwrite) BOOL showAlphabet;

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	The background of the Entry view. This UIView will be blurred
 *  @note Deafult: A UIView with a gray background
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
@property (nonatomic, strong) UIView *backgroundView;

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	The blur radius given to the background view
 *  @note Default: 15
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
@property (nonatomic, readwrite) CGFloat backgroundBlurRadius;

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	The background color that overlays the backgroundView
 *  @note Default: [UIColor colorWithWhite:0 alpha:0.7]
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
@property (nonatomic, strong) UIColor *backgroundColor;

// __________________________________________________________________________________________

/// @name Validation properties

// __________________________________________________________________________________________

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	The total number of digits that should be entered.
 *  @warning When the number of digits that are entered reaches this point `pinEntry:isValidCode:` will be invoked
 *  @warning Minimum must be 1
 *  @note Default: 4
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
@property (nonatomic, readwrite) NSUInteger numberOfDigits;

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	The total number of incorrect attempts
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
@property (nonatomic, readonly) NSUInteger attempts;

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	The code that is entered
 *  @warning Everytime this changes the delegate method `pinEntry:didChangeCode:` will be invoked.
 *           You can also use KVO to listen for changes.
 *           Another option would be to use `NSNotificationCenter` to observe for the `ESPinEntryCodeDidUpdateNotification` keypath.
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
@property (nonatomic, readonly, copy) NSString *code;

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	Should the device vibrate when an incorrect entry is given
 *  @note Default: YES
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
@property (nonatomic, readwrite, getter=shouldVibrate) BOOL vibrate;

// __________________________________________________________________________________________

/// @name General properties

// __________________________________________________________________________________________
/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	The delegate to message to
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
@property (nonatomic, weak) id<ESPinEntryDelegate> delegate;


// __________________________________________________________________________________________

/// @name Instance methods

// __________________________________________________________________________________________

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	Initializer with delegate parmaeter
 *
 *	@param aDelegate id<ESPinEntryDelegate>
 *
 *	@return `ESPinEntryView` instance
 *
 *	@since 1.0
 *  @date 27/02/2015
 */
- (instancetype)initWithDelegate:(id<ESPinEntryDelegate>)aDelegate;
@end