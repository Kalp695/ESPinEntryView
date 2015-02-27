//
//  ESPinEntryViewController.m
//  ESPinEntry
//
//  Created by Bas van Kuijck on 26-02-15.
//  Copyright (c) 2015 e-sites. All rights reserved.
//

#import "ESPinEntryViewController.h"
#import "ESPinEntryView.h"
#import <Masonry.h>

@interface ESPinEntryViewController ()

@end

@implementation ESPinEntryViewController
@synthesize pinEntryView=_pinEntryView,delegate;

- (instancetype)init
{
    if (self = [super init]) {
        
        _pinEntryView = [[ESPinEntryView alloc] init];
        [self.view addSubview:_pinEntryView];
        [_pinEntryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
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
