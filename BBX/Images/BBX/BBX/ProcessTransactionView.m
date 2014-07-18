//
//  ProcessTransactionView.m
//  BBX
//
//  Created by Roman Khan on 09/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ProcessTransactionView.h"
#import "BBXStringConstants.h"

@implementation ProcessTransactionView
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
 *  View Transaction
 *
 *  @param sender Button Object
 */
- (IBAction)viewTransactionButtonClicked:(id)sender
{
    [self removeFromSuperview];
    [(ProcessBBXTransactionViewController *)delegate selectedViewControllerWithIdentifier:kViewTransactionViewController];
}

/**
 *  View Payment
 *
 *  @param sender Button Object
 */
- (IBAction)viewPaymentButtonClicked:(id)sender
{
    [self removeFromSuperview];
    [(ProcessBBXTransactionViewController *)delegate selectedViewControllerWithIdentifier:kViewPaymentViewController];
}

@end
