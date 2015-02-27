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

@property (nonatomic, readonly, strong) ESPinEntryView *pinEntryView;
@property (nonatomic, weak) id<ESPinEntryDelegate> delegate;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil __attribute__((unavailable("use init instead")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("use init instead")));
@end
