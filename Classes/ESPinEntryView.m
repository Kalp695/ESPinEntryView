//
//  ESPinEntryView.m
//  ESPinEntry
//
//  Created by Bas van Kuijck on 26-02-15.
//  Copyright (c) 2015 e-sites. All rights reserved.
//

#import "ESPinEntryView.h"
#import <Masonry.h>
#import <QuartzCore/QuartzCore.h>
#import <FXBlurView.h>
#import <AudioToolbox/AudioServices.h>

@interface _ESPinEntryViewCanvas : UIView
{
    CAShapeLayer *_backgroundLayer;
    __weak ESPinEntryView *_pinEntryView;
}
- (instancetype)initWithPinEntryView:(ESPinEntryView *)pinEntryView;
@end

@interface ESPinEntryView ()
{
    UIView *_backgroundContainerView;
    FXBlurView *_backgroundBlurView;
    NSMutableArray *_dotViews;
    UIView *_containerView;
    NSMutableArray *_alphabetLabels;
    NSMutableDictionary *_buttonBackgrounds;
    UILabel *_enterPasscodeLabel;
    NSMutableArray *_buttons;
    UIImage *_screenshotImageOfBackground;
    UIColor *_backgroundColor;
    _ESPinEntryViewCanvas *_canvas;
    UIView *_dotsContainer;
    UIButton *_deleteButton;
}
@property (nonatomic, readonly, getter=isIncorrectAnimationBusy) BOOL incorrectAnimationBusy;
@end
@implementation ESPinEntryView
@synthesize backgroundView=_backgroundView,code=_code,showCancelButton=_showCancelButton,cancelText=_cancelText,deleteText=_deleteText,showAlphabet=_showAlphabet,numberOfDigits=_numberOfDigits,incorrectAnimationBusy=_incorrectAnimationBusy,attempts=_attempts,backgroundBlurRadius=_backgroundBlurRadius;

- (instancetype)init
{
    if (self = [super initWithFrame:CGRectZero]) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
        
    }
    return self;
}

- (instancetype)initWithDelegate:(id<ESPinEntryDelegate>)aDelegate
{
    if (self = [self initWithFrame:CGRectZero]) {
        [self setDelegate:aDelegate];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}


- (void)_init
{
    [self setVibrate:YES];
    _code = [@"" copy];
    [self setOpaque:YES];
    _backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    _alphabetLabels = [[NSMutableArray alloc] init];
    _dotViews = [[NSMutableArray alloc] init];
    _numberOfDigits = 4;
    _buttonBackgrounds = [[NSMutableDictionary alloc] init];
    _buttons = [[NSMutableArray alloc] init];
    
    _backgroundContainerView = [[UIView alloc] init];
    [_backgroundContainerView setUserInteractionEnabled:NO];
    [self addSubview:_backgroundContainerView];
    [_backgroundContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _backgroundBlurView = [[FXBlurView alloc] init];
    [_backgroundBlurView setDynamic:NO];
    [_backgroundContainerView addSubview:_backgroundBlurView];
    [_backgroundBlurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backgroundContainerView);
    }];
    
    [super setBackgroundColor:[UIColor whiteColor]];
    
    _canvas = [[_ESPinEntryViewCanvas alloc] initWithPinEntryView:self];
    [self addSubview:_canvas];
    [_canvas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_canvas setNeedsDisplay];
    
    _containerView = [[UIView alloc] init];
    [self addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(containerWidth));
        make.height.equalTo(@(containerHeight));
        make.center.equalTo(self);
    }];
    
    _enterPasscodeLabel = [[UILabel alloc] init];
    [_enterPasscodeLabel setTextAlignment:NSTextAlignmentCenter];
    [_enterPasscodeLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:_enterPasscodeLabel];
    [_enterPasscodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(25));
        make.left.equalTo(_containerView.mas_left);
        make.right.equalTo(_containerView.mas_right);
        make.top.equalTo(_containerView.mas_top);
    }];
    
    UIView *pinEntryContainer = [[UIView alloc] init];
    [_containerView addSubview:pinEntryContainer];
    [pinEntryContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo([NSValue valueWithCGSize:_pinNumbersContainerSize()]);
        make.centerY.equalTo(_containerView.mas_centerY).offset(pinEntryContainerTopOffset);
        make.centerX.equalTo(_containerView.mas_centerX);
    }];
    _dotsContainer = [[UIView alloc] init];
    [_dotsContainer setUserInteractionEnabled:NO];
    [_containerView addSubview:_dotsContainer];
    [_dotsContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_containerView);
    }];
    CGFloat wh = circleDiameter - (circleBorder * 2);
    for (NSInteger i = 0; i < 10; i++) {
        CGPoint origin = _positionForEntry(i);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.layer setCornerRadius:wh / 2];
        [btn setClipsToBounds:YES];
        [btn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:34]];
        [btn addTarget:self action:@selector(_press:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [btn addTarget:self action:@selector(_release:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit | UIControlEventTouchUpOutside];
        [btn addTarget:self action:@selector(_up:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:self.backgroundColor];
        [pinEntryContainer addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@(wh));
            make.left.equalTo(@(origin.x + circleBorder));
            make.top.equalTo(@(origin.y + circleBorder));
        }];
        NSString *value = [NSString stringWithFormat:@"%zd", (i + 1 == 10 ? 0 : i + 1)];
        [btn setTitle:value forState:UIControlStateNormal];
        [_buttons addObject:btn];
        
        if (i > 0 && i < 9) {
            UILabel *alphabet = [[UILabel alloc] init];
            [alphabet setTextAlignment:NSTextAlignmentCenter];
            [alphabet setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:9]];
            [alphabet setTextColor:[UIColor whiteColor]];
            [pinEntryContainer addSubview:alphabet];
            [_alphabetLabels addObject:alphabet];
            NSString *str = @"";
            switch (i) {
                case 1:
                    str = @"ABC";
                    break;
                case 2:
                    str = @"DEF";
                    break;
                case 3:
                    str = @"GHI";
                    break;
                case 4:
                    str = @"JKL";
                    break;
                case 5:
                    str = @"MNO";
                    break;
                case 6:
                    str = @"PQRS";
                    break;
                case 7:
                    str = @"TUV";
                    break;
                case 8:
                    str = @"WXYZ";
                    break;
            }
            NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:str];
            [attstr beginEditing];
            [attstr addAttributes:@{
                                    NSKernAttributeName: @(3)
                                    } range:NSMakeRange(0, str.length)];
            [alphabet setAttributedText:attstr];
            [attstr endEditing];
            [alphabet setHidden:YES];
            [alphabet mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(btn.mas_width);
                make.height.equalTo(@(14));
                make.left.equalTo(btn.mas_left);
                make.right.equalTo(btn.mas_right);
                make.bottom.equalTo(btn.mas_bottom).offset(-12);
            }];
        } else {
            [_alphabetLabels addObject:[[UILabel alloc] init]];
        }
    }
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_deleteButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_deleteButton addTarget:self action:@selector(_up:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_containerView addSubview:_deleteButton];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(circleDiameter));
        make.right.equalTo(pinEntryContainer.mas_right);
        make.bottom.equalTo(pinEntryContainer.mas_bottom);
    }];
    [_deleteButton setHidden:YES];
    
    /**
     *	@author Bas van Kuijck <bas@e-sites.nl>
     *
     *	Listen for orientation changes
     *
     *  @date 01/03/2015
     *	@since 1.0.1
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_didChangeOrientation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    // Default values
    [self setCancelText:@"Cancel"];
    [self setDeleteText:@"Delete"];
    [self setHeaderText:@"Enter passcode"];
    [self setBackgroundBlurRadius:15];
    [_deleteButton setTitle:self.cancelText forState:UIControlStateNormal];
    [self setBackgroundView:[[UIView alloc] init]];
    [self.backgroundView setBackgroundColor:[UIColor grayColor]];
    [self _createDotViews];
}

#pragma mark - Orientation
// ____________________________________________________________________________________________________________________


/**
 *	@author Bas van Kuijck <bas@e-sites.nl>
 *
 *	Orientation changes would invoke a redraw of the bacground canvas
 *
 *  @date 01/03/2015
 *	@since 1.0.1
 */
- (void)_didChangeOrientation:(NSNotification *)notification
{
    [_canvas setNeedsDisplay];
}

#pragma mark - Interaction
// ____________________________________________________________________________________________________________________

- (void)_press:(UIButton *)sender
{
    if (_incorrectAnimationBusy) {
        return;
    }
    [UIView animateWithDuration:.06 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [sender setBackgroundColor:[UIColor clearColor]];
    } completion:nil];
}

- (void)_release:(UIButton *)sender
{
    if (_incorrectAnimationBusy) {
        return;
    }
    [UIView animateWithDuration:.37 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [sender setBackgroundColor:self.backgroundColor];
    } completion:nil];
}

- (void)_up:(UIButton *)sender
{
    if ([sender isEqual:_deleteButton]) {
        if (_code.length == 0 && self.showCancelButton) {
            if ([self.delegate respondsToSelector:@selector(pinEntryDidPressCancel:)]) {
                [self.delegate pinEntryDidPressCancel:self];
            }
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ESPinEntryCodeDidUpdateNotification object:self];
        [self willChangeValueForKey:@"code"];
        _code = [[_code substringToIndex:_code.length - 1] copy];
        [self didChangeValueForKey:@"code"];
        [self _updateDotViews];
        if ([self.delegate respondsToSelector:@selector(pinEntryDidPressDelete:)]) {
            [self.delegate pinEntryDidPressDelete:self];
        }
        
        if ([self.delegate respondsToSelector:@selector(pinEntry:didChangeCode:)]) {
            [self.delegate pinEntry:self didChangeCode:_code];
        }
        [self _updateDeleteButtonState];
        return;
    }
    
    if (_code.length == self.numberOfDigits || _incorrectAnimationBusy) {
        return;
    }
    
    NSInteger index = [_buttons indexOfObject:sender];
    NSInteger digit = index + 1;
    if (digit == 10) {
        digit = 0;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ESPinEntryCodeDidUpdateNotification object:self];
    [self willChangeValueForKey:@"code"];
    _code = [[_code stringByAppendingFormat:@"%zd", digit] copy];
    [self didChangeValueForKey:@"code"];
    [self _updateDeleteButtonState];
    [self _updateDotViews];
    if ([self.delegate respondsToSelector:@selector(pinEntry:didPressDigit:)]) {
        [self.delegate pinEntry:self didPressDigit:digit];
    }
    if ([self.delegate respondsToSelector:@selector(pinEntry:didChangeCode:)]) {
        [self.delegate pinEntry:self didChangeCode:_code];
    }
    if (_code.length == self.numberOfDigits) {
        BOOL result = NO;
        _attempts++;
        if ([self.delegate respondsToSelector:@selector(pinEntry:isValidCode:)]) {
            result = [self.delegate pinEntry:self isValidCode:_code];
        }
        if (!result) {
            [self _incorrect];
        } else {
            _attempts = 0;
        }
    }
}

#pragma mark - Properties
// ____________________________________________________________________________________________________________________

- (void)setShowAlphabet:(BOOL)showAlphabet
{
    if (_showAlphabet == showAlphabet) {
        return;
    }
    _showAlphabet = showAlphabet;
    for (UILabel *alphabet in _alphabetLabels) {
        [alphabet setHidden:!showAlphabet];
    }
    
    NSInteger i = 0;
    for (UIButton *btn in _buttons) {
        if (i < 9) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, _showAlphabet ? 12 : 0, 0)];
        }
        i++;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    [_canvas setNeedsDisplay];
    [self _createDotViews];
}

- (UIColor *)backgroundColor
{
    return _backgroundColor;
}

- (void)setCancelText:(NSString *)cancelText
{
    _cancelText = cancelText;
    if (_code.length == 0 && self.showCancelButton) {
        [_deleteButton setTitle:cancelText forState:UIControlStateNormal];
    }
}

- (void)setNumberOfDigits:(NSUInteger)numberOfDigits
{
    if (numberOfDigits == _numberOfDigits || numberOfDigits < 1) { return; }
    _numberOfDigits = numberOfDigits;
    [self _createDotViews];
}

- (void)setDeleteText:(NSString *)deleteText
{
    _deleteText = deleteText;
    if (_code.length > 0) {
        [_deleteButton setTitle:deleteText forState:UIControlStateNormal];
    }
}

- (void)setShowCancelButton:(BOOL)showCancelButton
{
    _showCancelButton = showCancelButton;
    if (_showCancelButton) {
        [_deleteButton setHidden:NO];
    } else if (_code.length == 0) {
        [_deleteButton setHidden:YES];
    }
}

- (void)setHeaderText:(NSString *)headerText
{
    [_enterPasscodeLabel setText:headerText];
}

- (NSString *)headerText
{
    return _enterPasscodeLabel.text;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [_enterPasscodeLabel setTextColor:tintColor];
    for (UIButton *btn in _buttons) {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    [_backgroundView removeFromSuperview];
    _backgroundView = backgroundView;
    [_backgroundContainerView insertSubview:_backgroundView atIndex:0];
    [_backgroundBlurView setNeedsDisplay];
    [_backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backgroundContainerView);
    }];
}

- (void)setBackgroundBlurRadius:(CGFloat)backgroundBlurRadius
{
    if (backgroundBlurRadius == _backgroundBlurRadius) {
        return;
    }
    _backgroundBlurRadius = backgroundBlurRadius;
    [_backgroundBlurView setBlurEnabled:backgroundBlurRadius > 0];
    [_backgroundBlurView setBlurRadius:backgroundBlurRadius];
}


#pragma mark - Helpers
// ____________________________________________________________________________________________________________________

- (UIImage *)_backgroundImageForButton:(NSInteger)i
{
    if (_screenshotImageOfBackground == nil) {
        return nil;
    }
    if (_buttonBackgrounds[@(i)] != nil) {
        return _buttonBackgrounds[@(i)];
    }
    
    CGFloat x0 = (self.frame.size.width - ((circleDiameter * 3) + (circleMargin * 2))) / 2;
    CGFloat y0 = pinEntryContainerTopOffset + ((self.frame.size.height - ((circleDiameter * 4) + (circleMargin * 3))) / 2);
    
    CGRect rect;
    rect.origin = _positionForEntry(i);
    rect.origin.x = rect.origin.x + x0;
    rect.origin.y = rect.origin.y + y0;
    rect.size = CGSizeMake(circleDiameter, circleDiameter);
    CGImageRef imageRef = CGImageCreateWithImageInRect([_screenshotImageOfBackground CGImage], rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    _buttonBackgrounds[@(i)] = image;
    return image;
}

- (void)_incorrect
{
    NSLog(@"[ESPinEntry] Invalid code!");
    if (self.shouldVibrate) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
    _incorrectAnimationBusy = YES;
    [_canvas setNeedsDisplay];
    
    [self _updateDotsWithBorderWidth:0];
    
    for (UIView *dot in _dotViews) {
        [dot setAlpha:1];
        [dot setBackgroundColor:[UIColor redColor]];
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.75];
    
    CGFloat aOffset = 40;
    NSInteger maxShakes = 5;
    CGFloat aBreakFactor = 0.65;
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:20];
    NSInteger infinitySec = maxShakes;
    while (aOffset > 0.01) {
        [keys addObject:[NSValue valueWithCGPoint:CGPointMake(_dotsContainer.center.x - aOffset, _dotsContainer.center.y)]];
        aOffset *= aBreakFactor;
        [keys addObject:[NSValue valueWithCGPoint:CGPointMake(_dotsContainer.center.x + aOffset, _dotsContainer.center.y)]];
        aOffset *= aBreakFactor;
        infinitySec--;
        if (infinitySec <= 0) {
            break;
        }
    }
    
    animation.values = keys;
    
    [animation setDelegate:self];
    [_dotsContainer.layer addAnimation:animation forKey:@"position"];
    [self willChangeValueForKey:@"code"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ESPinEntryCodeDidUpdateNotification object:self];
    _code = [@"" copy];
    [self didChangeValueForKey:@"code"];
    [self _updateDeleteButtonState];

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _incorrectAnimationBusy = NO;
    [_canvas setNeedsDisplay];
    [self _updateDotsWithBorderWidth:dotBorder];
    for (UIView *dot in _dotViews) {
        [dot setAlpha:1];
        [dot setBackgroundColor:self.backgroundColor];
    }
    if ([self.delegate respondsToSelector:@selector(pinEntry:didChangeCode:)]) {
        [self.delegate pinEntry:self didChangeCode:_code];
    }
}

- (void)_updateDotsWithBorderWidth:(CGFloat)border
{
    CGFloat wh = dotDiameter - (border * 2);
    NSInteger i = 0;
    for (UIView *dot in _dotViews) {
        [dot.layer setCornerRadius:(wh / 2)];
        CGFloat x = (containerWidth - ((dotDiameter * self.numberOfDigits) + (dotMargin * (self.numberOfDigits - 1)))) / 2;
        x += i * (dotDiameter + dotMargin);
        x += border;
        [dot mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@(wh));
            make.top.equalTo(_dotsContainer.mas_top).offset(dotsTopOffset + border);
            make.left.equalTo(_dotsContainer.mas_left).offset(x);
        }];
        i++;
        
    }
}

- (void)_updateDeleteButtonState
{
    if (_code.length == 0) {
        if (self.showCancelButton) {
            [_deleteButton setTitle:self.cancelText forState:UIControlStateNormal];
        } else {
            [_deleteButton setHidden:YES];
        }
    } else {
        [_deleteButton setTitle:self.deleteText forState:UIControlStateNormal];
        [_deleteButton setHidden:NO];
    }
}

- (void)_createDotViews
{
    if (_dotsContainer == nil) {
        return;
    }
    for (UIView *dot in _dotViews) {
        [dot removeFromSuperview];
    }
    [_dotViews removeAllObjects];
    [_canvas setNeedsDisplay];
    
    for (NSInteger i = 0; i < _numberOfDigits; i++) {
        UIView *dot = [[UIView alloc] init];
        [dot.layer setMasksToBounds:YES];
        [dot setBackgroundColor:self.backgroundColor];
        [_dotsContainer addSubview:dot];
        [_dotViews addObject:dot];
    }
    [self _updateDotsWithBorderWidth:dotBorder];
}

- (void)_updateDotViews
{
    [UIView animateWithDuration:.125 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        NSInteger i = 0;
        for (UIView *dot in _dotViews) {
            [dot setAlpha:(i < _code.length ? 0 : 1)];
            i++;
        }
    } completion:nil];
}

const CGFloat containerWidth = 320.0f;
const CGFloat containerHeight = 480.0f;
const CGFloat circleDiameter = 75.0f;
const CGFloat dotsTopOffset = 50.0f;
const CGFloat dotDiameter = 12.0f;
const CGFloat dotMargin = 24.0f;
const CGFloat circleMargin = 15.0f;
const CGFloat circleBorder = 1.5f;
const CGFloat dotBorder = 1.0f;
const CGFloat pinEntryContainerTopOffset = 30.0f;

#pragma mark - Drawing
// ____________________________________________________________________________________________________________________

CGPoint _positionForEntry(NSInteger i)
{
    if (i == 9) {
        i = 10;
    }
    NSInteger row = floor(i / 3);
    NSInteger col = i % 3;
    CGFloat x = (circleDiameter + circleMargin) * col;
    CGFloat y = (circleDiameter + circleMargin) * row;
    return CGPointMake(x, y);
}

CGSize _pinNumbersContainerSize()
{
    return CGSizeMake((circleDiameter * 3) + (circleMargin * 2), (circleDiameter * 4) + (circleMargin * 3));
}

#pragma mark - Destructor
// ____________________________________________________________________________________________________________________

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    _buttonBackgrounds = nil;
    _backgroundView = nil;
    _dotViews = nil;
    _buttons = nil;
    _code = nil;
    _alphabetLabels = nil;
}

@end

// ____________________________________________________________________________________________________________________

// _ E S   P I N   E N T R Y   V I E W   C A N V A S

// ____________________________________________________________________________________________________________________


@implementation _ESPinEntryViewCanvas

- (instancetype)initWithPinEntryView:(ESPinEntryView *)pinEntryView
{
    if (self = [super init]) {
        _pinEntryView = pinEntryView;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_backgroundLayer == nil) {
        _backgroundLayer = [CAShapeLayer layer];
        [self.layer insertSublayer:_backgroundLayer atIndex:0];
    }
    [_backgroundLayer setBackgroundColor:_pinEntryView.backgroundColor.CGColor];
    [_backgroundLayer setPosition:self.center];
    [_backgroundLayer setBounds:rect];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    [maskLayer setPosition:_backgroundLayer.position];
    [maskLayer setBounds:rect];
    CGMutablePathRef maskPath = CGPathCreateMutable();
    CGPathAddRect(maskPath, NULL, rect); // this line is new
    
    CGFloat x0 = (self.frame.size.width - ((circleDiameter * 3) + (circleMargin * 2))) / 2;
    CGFloat y0 = pinEntryContainerTopOffset + ((self.frame.size.height - ((circleDiameter * 4) + (circleMargin * 3))) / 2);
    
    for (NSInteger i = 0; i < 10; i++) {
        CGPoint origin = _positionForEntry(i);
        origin.x = origin.x + x0;
        origin.y = origin.y + y0;
        CGPathAddEllipseInRect(maskPath, NULL, CGRectMake(origin.x, origin.y, circleDiameter, circleDiameter));
    }
    if (!_pinEntryView.isIncorrectAnimationBusy) {
        x0 = (self.frame.size.width - ((dotDiameter * _pinEntryView.numberOfDigits) + (dotMargin * (_pinEntryView.numberOfDigits - 1)))) / 2;
        y0 = ((self.frame.size.height - containerHeight) / 2) + dotsTopOffset;
        for (NSInteger i = 0; i < _pinEntryView.numberOfDigits; i++) {
            CGFloat x = x0 + ((dotDiameter + dotMargin) * i);
            CGPathAddEllipseInRect(maskPath, NULL, CGRectMake(x, y0, dotDiameter, dotDiameter));
        }
    }
    
    [maskLayer setPath:maskPath];
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    CGPathRelease(maskPath);
    _backgroundLayer.mask = maskLayer;
}

@end