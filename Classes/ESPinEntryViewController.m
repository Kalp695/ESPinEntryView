//
//  ESPinEntryViewController.m
//  ESPinEntry
//
//  Created by Bas van Kuijck on 26-02-15.
//  Copyright (c) 2015 e-sites. All rights reserved.
//

#import "ESPinEntryViewController.h"
#import "ESPinEntryView.h"
#import "Masonry.h"

@interface ESPinEntryViewController ()

@end

@implementation ESPinEntryViewController
@synthesize pinEntryView=_pinEntryView,delegate;

- (instancetype)init
{
    if (self = [super init]) {
        
        /**
         * @author Bas van Kuijck <bas@e-sites.nl>
         *
         * Replace the `view` property with a `ESPinEntryView` instance
         *
         * @date 01/03/2015
         * @since 1.0.1
         */
        _pinEntryView = [[ESPinEntryView alloc] init];
        [self setView:_pinEntryView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setDelegate:(id<ESPinEntryDelegate>)aDelegate
{
    [_pinEntryView setDelegate:aDelegate];
}

- (id<ESPinEntryDelegate>)delegate
{
    return _pinEntryView.delegate;
}


#pragma mark - Destructor
// ____________________________________________________________________________________________________________________

- (void)dealloc
{
    _pinEntryView = nil;
}

@end
