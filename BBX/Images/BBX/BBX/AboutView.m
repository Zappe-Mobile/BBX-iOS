//
//  AboutView.m
//  BBX
//
//  Created by Roman Khan on 19/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "AboutView.h"
#import "BBXStringConstants.h"

@implementation AboutView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *  Trading Tips
 *
 *  @param sender Button Object
 */
- (IBAction)tradingTipsButtonClicked:(id)sender
{
    [self removeFromSuperview];
    [(AboutUsViewController *)delegate selectedViewControllerWithIdentifier:kTradingTipsViewController];
}

/**
 *  Trading Example
 *
 *  @param sender Button Object
 */
- (IBAction)tradingExampleButtonClicked:(id)sender
{
    [self removeFromSuperview];
    [(AboutUsViewController *)delegate selectedViewControllerWithIdentifier:kTradingExampleViewController];
}

/**
 *  Testimonial
 *
 *  @param sender Button Object
 */
- (IBAction)testimonialsButtonClicked:(id)sender
{
    [self removeFromSuperview];
    [(AboutUsViewController *)delegate selectedViewControllerWithIdentifier:kTestimonialViewController];
}

@end
