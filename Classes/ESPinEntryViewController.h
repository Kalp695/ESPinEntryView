//
//  ESPinEntryViewController.h
//  ESPinEntry
//
//  Created by Bas van Kuijck on 26-02-15.
//  Copyright (c) 2015 e-sites. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESPinEntryView.h"

@interface ESPinEntryViewController : UIViewController

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	The actual ESPinEntryView
 *  @see ESPinEntryView for more information
 *
 *	@since 1.0
 *  @date 26/02/2015
 */
@property (nonatomic, readonly, strong) ESPinEntryView *pinEntryView;

/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	Forward declaration of the delegate
 *  @see [ESPinEntryView delegate] for more information
 *
 *	@since 1.0
 *  @date 26/02/2015
 */
@property (nonatomic, weak) id<ESPinEntryDelegate> delegate;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil __attribute__((unavailable("use init instead")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("use init instead")));
@end
