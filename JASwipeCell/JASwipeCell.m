//
//  JASwipeCell.m
//  JASwipeCell
//
//  Created by Jose Alvarez on 10/8/14.
//  Copyright (c) 2014 Jose Alvarez. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "JASwipeCell.h"
#import "JAActionButton.h"

#define kButtonTitlePadding     5.0

// Determines the direction that the user is swiping
typedef NS_ENUM(NSUInteger, JASwipeDirection) {
    JASwipeDirectionLeft,
    JASwipeDirectionRight
};

@interface JASwipeCell () <UIGestureRecognizerDelegate>

// Holds the width of a left button
@property (nonatomic) CGFloat leftButtonWidth;
// Holds the width of a right button
@property (nonatomic) CGFloat rightButtonWidth;
// Holds the left action buttons
@property (nonatomic, strong) NSArray *leftButtons;
// Holds the right action buttons
@property (nonatomic, strong) NSArray *rightButtons;
// Holds the starting x position for the left buttons
@property (nonatomic, strong) NSMutableArray *leftButtonsStartingX;
// Holds the starting x position for the right buttons
@property (nonatomic, strong) NSMutableArray *rightButtonsStartingX;
// Determines if the layout has already been applied on this cell
@property (nonatomic) BOOL isLayoutApplied;
// The starting point for the swipe
@property (nonatomic) CGPoint startingPoint;
// Currently swiping to the left
@property (nonatomic) BOOL swipingLeft;
// Currently swiping to the right
@property (nonatomic) BOOL swipingRight;
// Determines of the left most button is currently pinned to the top view.
@property (nonatomic) BOOL leftMostButtonPinned;
// Determines of the right most button is currently pinned to the top view.
@property (nonatomic) BOOL rightMostButtonPinned;
// Determines if the left buttons are revealed.
@property (nonatomic) BOOL leftButtonsRevealed;
// Determines if the right buttons are revealed.
@property (nonatomic) BOOL rightButtonsRevealed;

// Holds the pan gesture recognizer applied to the cell
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation JASwipeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self addSubview:self.topContentView];
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    _panGestureRecognizer.delegate = self;
    [self.topContentView addGestureRecognizer:_panGestureRecognizer];
}

- (UIView *)topContentView
{
    if (!_topContentView) {
        _topContentView = [[UIView alloc] init];
        _topContentView.backgroundColor = [UIColor whiteColor];
    }
    return _topContentView;
}

- (void)setLeftButtons:(NSArray *)leftButtons
{
    // Remove any existing left button from the superView before adding new ones
    if (_leftButtons) {
        for (UIButton *button in _leftButtons) {
            [button removeFromSuperview];
        }
        self.isLayoutApplied = NO;
    }
    _leftButtons = leftButtons;
    
    // The first button should be the top button on the z-axis
    for (UIButton *button in _leftButtons.reverseObjectEnumerator) {
        NSAssert([button isMemberOfClass:[JAActionButton class]], @"This cell expects JAActionButton class buttons");
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
}

- (void)setRightButtons:(NSArray *)rightButtons
{
    // Remove any existing right button from the superView before adding new ones
    if (_rightButtons) {
        for (UIButton *button in _rightButtons) {
            [button removeFromSuperview];
        }
        self.isLayoutApplied = NO;
    }
    _rightButtons = rightButtons;
    
    // The first button should be the top button on the z-axis
    for (UIButton *button in _rightButtons.reverseObjectEnumerator) {
        NSAssert([button isMemberOfClass:[JAActionButton class]], @"This cell expects JAActionButton class buttons");
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
}

- (void)buttonTapped:(JAActionButton *)button
{
    if (button.handler) {
        button.handler(button, self);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.isLayoutApplied) {
        self.topContentView.frame = self.contentView.frame;
        // Layout left buttons
        for (int i = 0; i < self.leftButtons.count; i++) {
            UIButton *lButton = self.leftButtons[i];
            // The first button's width is the same as the contentView. This will be the cell that will
            // pin to the topView.
            if (i == 0) {
                CGRect button1Frame = self.contentView.frame;
                button1Frame.origin.x = - self.contentView.frame.size.width;
                lButton.frame = button1Frame;
                [lButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                // Add right padding to the button title
                [lButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kButtonTitlePadding)];
            } else {
                lButton.frame = CGRectMake(-self.leftButtonWidth , 0, self.leftButtonWidth, self.contentView.frame.size.height);
            }
        }
        
        // Layout right buttons
        for (int i = 0; i < self.rightButtons.count; i++) {
            UIButton *rButton = self.rightButtons[i];
            // The first button's width is the same as the contentView. This will be the cell that will
            // pin to the topView.
            if (i == 0) {
                CGRect button1Frame = self.contentView.frame;
                button1Frame.origin.x = self.contentView.frame.size.width;
                rButton.frame = button1Frame;
                [rButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                // Add right padding to the button title
                [rButton setTitleEdgeInsets:UIEdgeInsetsMake(0, kButtonTitlePadding, 0, 0)];
            } else {
                rButton.frame = CGRectMake(self.contentView.frame.size.width, 0, self.rightButtonWidth, self.contentView.frame.size.height);
            }
        }
        
        // Need to remember the original frames for when we are swiping the buttons.
        self.leftButtonsStartingX = [[NSMutableArray alloc] initWithCapacity:self.leftButtons.count];
        self.rightButtonsStartingX = [[NSMutableArray alloc] initWithCapacity:self.rightButtons.count];
        for (UIButton *lButton in self.leftButtons) {
            [self.leftButtonsStartingX addObject:[NSNumber numberWithFloat:lButton.frame.origin.x]];
        }
        for (UIButton *rButton in self.rightButtons) {
            [self.rightButtonsStartingX addObject:[NSNumber numberWithFloat:rButton.frame.origin.x]];
        }
        
        self.isLayoutApplied = YES;
    }
}

- (void)addActionButtons:(NSArray *)actionButtons withButtonPosition:(JAButtonLocation)buttonPosition
{
    [self addActionButtons:actionButtons withButtonWidth:kJAButtonWidth withButtonPosition:buttonPosition];
}

- (void)addActionButtons:(NSArray *)actionButtons withButtonWidth:(CGFloat)width withButtonPosition:(JAButtonLocation)buttonPosition
{
    if (buttonPosition == JAButtonLocationLeft) {
        self.leftButtons = actionButtons;
        self.leftButtonWidth = (width > 0) ? width : kJAButtonWidth;
    } else {
        self.rightButtons = actionButtons;
        self.rightButtonWidth = (width > 0) ? width: kJAButtonWidth;
    }
}

#pragma -mark Helper Methods

- (CGFloat)leftButtonsTotalWidth
{
    return self.leftButtons.count * self.leftButtonWidth;
}

- (CGFloat)rightButtonsTotalWidth
{
    return self.rightButtons.count * self.rightButtonWidth;
}

- (void)hideLeftButtons
{
    for (UIButton *button in self.leftButtons){
        button.hidden = YES;
    }
}

- (void)showLeftButtons
{
    for (UIButton *button in self.leftButtons){
        button.hidden = NO;
    }
}

- (void)hideRightButtons
{
    for (UIButton *button in self.rightButtons){
        button.hidden = YES;
    }
}

- (void)showRightButtons
{
    for (UIButton *button in self.rightButtons){
        button.hidden = NO;
    }
}

/**
 Resets the top container view and buttons to their original states.
 */
- (void)resetContainerView
{
    if (self.topContentView.frame.origin.x > 0) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = self.topContentView.frame;
            frame.origin.x = 0;
            self.topContentView.frame = frame;
            [self revealButtonsWithTopViewWithOffset:0 swipeDirection:JASwipeDirectionRight];
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = self.topContentView.frame;
            frame.origin.x = 0;
            self.topContentView.frame = frame;
            [self revealButtonsWithTopViewWithOffset:0 swipeDirection:JASwipeDirectionLeft];
        } completion:nil];

    }

}

- (void)completePinToTopViewAnimation
{
    CGFloat newXOffset = self.rightButtonsRevealed ? -self.topContentView.frame.size.width : self.topContentView.frame.size.width;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self pinButtonToTopViewWithOffset:newXOffset swipeDirection:self.rightButtonsRevealed ? JASwipeDirectionLeft : JASwipeDirectionRight];
        self.topContentView.frame = CGRectMake(newXOffset, self.topContentView.frame.origin.y, CGRectGetWidth(self.topContentView.frame), CGRectGetHeight(self.topContentView.frame));
    } completion:nil];
}

/**
 Pins the left most or right most button to the top view.
 @param xOffset The x offset where this button needs to pin to
 @param panDirection The swipe direction.
 */
- (void)pinButtonToTopViewWithOffset:(CGFloat)xOffset swipeDirection:(JASwipeDirection)swipeDirection
{
    UIButton *pinButton = nil;
    CGFloat pinButtonStartingX;
    if (swipeDirection == JASwipeDirectionLeft) {
        pinButton = self.rightButtons[0];
        pinButtonStartingX = [(NSNumber *)self.rightButtonsStartingX[0] floatValue];
    } else {
        pinButton = self.leftButtons[0];
        pinButtonStartingX = [(NSNumber *)self.leftButtonsStartingX[0] floatValue];
    }
    pinButton.frame = CGRectMake(pinButtonStartingX + xOffset, pinButton.frame.origin.y, pinButton.frame.size.width, pinButton.frame.size.height);
}

/**
 Reveals the buttons as the top view pans. The buttons are offset from each other.
 
 @param xOffset The current x offset of the top view.
 @param panDirection The swipe direction.
 */
- (void)revealButtonsWithTopViewWithOffset:(CGFloat)xOffset swipeDirection:(JASwipeDirection)swipeDirection
{
    NSArray *buttons = (swipeDirection == JASwipeDirectionRight) ? self.leftButtons : self.rightButtons;
    NSUInteger buttonCount = buttons.count;
    for (int i = 0; i < buttonCount; i++) {
        JAActionButton *button = buttons[i];
        CGFloat buttonStartingX = (swipeDirection == JASwipeDirectionRight) ?  [(NSNumber *)self.leftButtonsStartingX[i] floatValue] : [(NSNumber *)self.rightButtonsStartingX[i] floatValue];
        if (i == buttonCount - 1) {
            // Last button (closest to the top view) will be offset by the same amount as the top view.
            button.frame = CGRectMake(buttonStartingX + xOffset, button.frame.origin.y, button.frame.size.width, button.frame.size.height);
        } else {
            // The rest of the buttons will be offset from each other.
            button.frame = CGRectMake(buttonStartingX + (xOffset/buttonCount) * (i + 1), button.frame.origin.y, button.frame.size.width, button.frame.size.height);
        }
    }
}

#pragma  -mark UIPanGestureRecognizer delegate methods

- (void)panHandler:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.startingPoint = self.topContentView.frame.origin;
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat currentX = [recognizer translationInView:self].x;
            CGFloat newXOffset = self.startingPoint.x + currentX;
            
            // When starting from a closed state.
            if (self.startingPoint.x == 0) {
                self.swipingLeft = currentX < self.startingPoint.x;
                self.swipingRight = currentX > self.startingPoint.x;
            } else {
                // Starting on an open state.
                self.swipingLeft = currentX > self.startingPoint.x;
                self.swipingRight = currentX < self.startingPoint.x;
            }
            
            if (self.swipingLeft) {
                // Exit if we don't have any right buttons
                if (self.rightButtons.count == 0 ){
                    return;
                }
                [self hideLeftButtons];
                [self showRightButtons];
                
                if ([self.delegate respondsToSelector:@selector(swipingLeftForCell:)]) {
                    [self.delegate swipingLeftForCell:self];
                }
                
                // Starting in a closed state
                if (self.startingPoint.x == 0) {
                    // Handle panning and revealing the right buttons
                    [self handlePanningButtons:newXOffset swipeDirection:JASwipeDirectionLeft];
                }
                // Top view is open revealing the right buttons
                else {
                    // Starting open with right buttons revealed
                    if (fabs(self.startingPoint.x) == [self rightButtonsTotalWidth]) {
                        // Handle panning and revealing the right buttons
                        [self handlePanningButtons:newXOffset swipeDirection:JASwipeDirectionLeft];
                    }
                }
            }
            // Swiping to the right
            else if (self.swipingRight) {
                // Exit if we don't have any left buttons
                if (self.leftButtons.count == 0) {
                    return;
                }
                [self hideRightButtons];
                [self showLeftButtons];
                if ([self.delegate respondsToSelector:@selector(swipingRightForCell:)]) {
                    [self.delegate swipingRightForCell:self];
                }
                
                // Starting in a closed state
                if (self.startingPoint.x == 0) {
                    // Handle panning and revealing the left buttons
                    [self handlePanningButtons:newXOffset swipeDirection:JASwipeDirectionRight];
                }
                // Top view is open revealing the left buttons
                else {
                    // Started open with right buttons revealed
                    if (self.startingPoint.x == [self leftButtonsTotalWidth]) {
                        // Handle panning and revealing the left buttons
                        [self handlePanningButtons:newXOffset swipeDirection:JASwipeDirectionRight];
                    }
                }
            }
            
            self.topContentView.frame = CGRectMake(newXOffset, self.startingPoint.y, CGRectGetWidth(self.topContentView.frame), CGRectGetHeight(self.topContentView.frame));
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGFloat currentX = self.topContentView.frame.origin.x;
            CGFloat newXOffset = 0.0;
            
            if (self.swipingLeft) {
                // Exit if we don't have any right buttons
                if (self.rightButtons.count == 0) {
                    return;
                }
                // Complete the swipe to the left
                if (fabs(currentX) > [self rightButtonsTotalWidth]) {
                    newXOffset = -self.topContentView.frame.size.width;
                    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self pinButtonToTopViewWithOffset:newXOffset swipeDirection:JASwipeDirectionLeft];
                    } completion:^(BOOL finished) {
                        [self.delegate rightMostButtonSwipeCompleted:self];
                    }];
                    self.rightButtonsRevealed = NO;
                }
                // Open to reveal right buttons
                else if (fabs(currentX) == [self rightButtonsTotalWidth] || fabs(currentX) > [self rightButtonsTotalWidth]/2) {
                    newXOffset = -[self rightButtonsTotalWidth];
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self revealButtonsWithTopViewWithOffset:newXOffset swipeDirection:JASwipeDirectionLeft];
                    } completion:nil];
                    self.rightButtonsRevealed = YES;
                }
                // Move top view to closed state
                else {
                    newXOffset = 0;
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self revealButtonsWithTopViewWithOffset:newXOffset swipeDirection:JASwipeDirectionLeft];
                    } completion:nil];
                    self.rightButtonsRevealed = NO;
                }
            }
            // Swiping right
            else if (self.swipingRight) {
                // Exit if we don't have any left buttons
                if (self.leftButtons.count == 0) {
                    return;
                }
                // Complete the pan to the right
                if (currentX > [self leftButtonsTotalWidth]) {
                    newXOffset = self.topContentView.frame.size.width;
                    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self pinButtonToTopViewWithOffset:newXOffset swipeDirection:JASwipeDirectionRight];
                    } completion:^(BOOL finished) {
                        [self.delegate leftMostButtonSwipeCompleted:self];
                    }];
                    self.leftButtonsRevealed = NO;
                }
                // Open to reveal left buttons
                else if (currentX == [self leftButtonsTotalWidth] || fabs(currentX) > [self leftButtonsTotalWidth]/2) {
                    newXOffset = [self leftButtonsTotalWidth];
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self revealButtonsWithTopViewWithOffset:newXOffset swipeDirection:JASwipeDirectionRight];
                    } completion:nil];
                    self.leftButtonsRevealed = YES;
                }
                // Move top view to closed state
                else {
                    newXOffset = 0;
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self revealButtonsWithTopViewWithOffset:newXOffset swipeDirection:JASwipeDirectionRight];
                    } completion:nil];
                    self.leftButtonsRevealed = NO;
                }
            }
           
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.topContentView.frame = CGRectMake(newXOffset, self.topContentView.frame.origin.y, CGRectGetWidth(self.topContentView.frame), CGRectGetHeight(self.topContentView.frame));
            } completion:nil];
            
            break;
        }
        default:
            break;
    }
}

/**
 Helper method that handles pinning the left/right most button to the top view and also the panning of all the buttons.
 */
- (void)handlePanningButtons:(CGFloat)xOffset swipeDirection:(JASwipeDirection)swipeDirection
{
    CGFloat newXOffset = (swipeDirection == JASwipeDirectionLeft) ? fabs(xOffset) : xOffset;
    CGFloat totalButtonsWidth = (swipeDirection == JASwipeDirectionLeft) ? [self rightButtonsTotalWidth] : [self leftButtonsTotalWidth];
    BOOL buttonPinned = (swipeDirection == JASwipeDirectionLeft) ? self.rightMostButtonPinned : self.leftMostButtonPinned;
    
    // Pin the furthest left/right button to the top view
    if (newXOffset > totalButtonsWidth) {
        // Animate the pinning of the edge-most button
        if (!buttonPinned) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self pinButtonToTopViewWithOffset:xOffset swipeDirection:swipeDirection];
            } completion:nil];
        } else {
            [self pinButtonToTopViewWithOffset:xOffset swipeDirection:swipeDirection];
        }
        if (swipeDirection == JASwipeDirectionLeft) {
            self.rightMostButtonPinned = YES;
        } else {
            self.leftMostButtonPinned = YES;
        }
        
    } else {
        // Move the buttons along with the top view
        if (buttonPinned) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self revealButtonsWithTopViewWithOffset:xOffset swipeDirection:swipeDirection];
            } completion:nil];
        } else {
            [self revealButtonsWithTopViewWithOffset:xOffset swipeDirection:swipeDirection];
        }
        if (swipeDirection == JASwipeDirectionLeft) {
            self.rightMostButtonPinned = NO;
        } else {
            self.leftMostButtonPinned = NO;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        // Find the current vertical scrolling velocity
        CGFloat velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view].y;
        
        // Return YES if no scrolling up
        return fabs(velocity) <= 0.2;
        
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if ( gestureRecognizer == self.panGestureRecognizer ) {
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        return fabs(translation.y) <= fabs(translation.x);
    }
    else {
        return YES;
    }
}

@end
