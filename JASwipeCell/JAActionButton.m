//
//  JAActionButton.m
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

#import "JAActionButton.h"

@interface JAActionButton ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy, readwrite) JAActionButtonHandler handler;
@end

@implementation JAActionButton

- (instancetype)initActionButtonWithTitle:(NSString *)title color:(UIColor *)color handler:(JAActionButtonHandler)handler
{
    self = [super init];
    if (self) {
        _title = title;
        _color = color;
        _handler = handler;
        
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setNumberOfLines:2];
        self.backgroundColor = color;
    }
    return self;
}

+ (instancetype)actionButtonWithTitle:(NSString *)title color:(UIColor *)color handler:(JAActionButtonHandler)handler
{
    JAActionButton *button = [[JAActionButton alloc] initActionButtonWithTitle:title color:color handler:handler];
    return button;
}

@end