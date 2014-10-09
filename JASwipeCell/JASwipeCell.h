//
//  JASwipeCell.h
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

#import <UIKit/UIKit.h>

// Default button width for buttons.
static CGFloat const kJAButtonWidth = 60;

typedef NS_OPTIONS(NSUInteger, JAButtonLocation) {
    // Buttons are located on the left side.
    JAButtonLocationLeft,
    // Buttons are located on the right side.
    JAButtonLocationRight
};

@class JASwipeCell;

@protocol JASwipeCellDelegate <NSObject>
// Called when the left most button has swiped all the way to the right.
- (void)leftMostButtonSwipeCompleted:(JASwipeCell *)cell;
// Called when the right most button has swiped all the way to the left.
- (void)rightMostButtonSwipeCompleted:(JASwipeCell *)cell;
@optional
// Called when the user begins swiping right on the cell.
- (void)swipingRightForCell:(JASwipeCell *)cell;
// Called when the user begins swiping left on the cell.
- (void)swipingLeftForCell:(JASwipeCell *)cell;
@end

/**
 This cell class provides a mechanism for rendering JAActionButtons behind a top container
 view. These buttons can be added to the left and/or right side of the cell. This is a similar
 implementation to IOS 8's mail application. As you swipe the cell, the buttons underneath are 
 revealed up to their max width. If the user swipes past a threshold, the left/right most button will
 pin to the container view and that button's action will fire once the swipe completes.
 */
@interface JASwipeCell : UITableViewCell
// Top view that will contain all subviews displayed on the cell.
@property (nonatomic, strong) UIView *topContentView;
// Delegate that will respond to cell swipes and button actions.
@property (nonatomic, weak) id <JASwipeCellDelegate> delegate;

/**
 Adds action buttons to the cell at the specified location with default widths.
 
 @param actionButtons The action buttons that will be located underneath the top view.
 @param buttonPosition Where the buttons will be located (JAButtonLocationLeft or JAButtonLocationRight).
 */
- (void)addActionButtons:(NSArray *)actionButtons withButtonPosition:(JAButtonLocation)buttonPosition;

/**
 Adds action buttons to the cell at the specified location.
 
 @param actionButtons The action buttons that will be located underneath the top view.
 @param width Width of the buttons.
 @param buttonLocation Where the buttons will be located (JAButtonLocationLeft or JAButtonLocationRight).
 */
- (void)addActionButtons:(NSArray *)actionButtons withButtonWidth:(CGFloat)width withButtonPosition:(JAButtonLocation)buttonPosition;

/**
 Resets the top container view and buttons back to their original state.
 */
- (void)resetContainerView;

/**
 Completes the pin to the top view.
 */
- (void)completePinToTopViewAnimation;

@end
