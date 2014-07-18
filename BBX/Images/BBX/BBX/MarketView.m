//
//  MarketView.m
//  BBX
//
//  Created by Roman Khan on 08/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "MarketView.h"
#import "MarketPlaceViewController.h"
#import "BBXStringConstants.h"

@implementation MarketView
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
 *  Products List
 *
 *  @param sender Button Object
 */
- (IBAction)productsButtonClicked:(id)sender
{
    
}

/**
 *  Search Products
 *
 *  @param sender Button Object
 */
- (IBAction)searchProductsButtonClicked:(id)sender
{
    [self removeFromSuperview];
    [(MarketPlaceViewController *)delegate selectedViewControllerWithIdentifier:kMarketPlaceSearchViewController];

}

/**
 *  Search Buy's
 *
 *  @param sender Button Object
 */
- (IBAction)buySearchButtonClicked:(id)sender
{
    
}

/**
 *  Buy Latest Listing
 *
 *  @param sender Button Object
 */
- (IBAction)buyLatestListingButtonClicked:(id)sender
{
    [self removeFromSuperview];
    [(MarketPlaceViewController *)delegate selectedViewControllerWithIdentifier:kMarketPlaceLatestProductsViewController];
}

/**
 *  Buy Closing Soon
 *
 *  @param sender Button Object
 */
- (IBAction)buyClosingSoonButtonClicked:(id)sender
{
    
}

/**
 *  My Buy's
 *
 *  @param sender Button Object
 */
- (IBAction)myBuysButtonClicked:(id)sender
{
    [self removeFromSuperview];
    [(MarketPlaceViewController *)delegate selectedViewControllerWithIdentifier:kCurrentMemberBuyHistoryViewController];

}

/**
 *  Start Telling
 *
 *  @param sender Button Object
 */
- (IBAction)startSellingButtonClicked:(id)sender
{
    
}

/**
 *  My Selling
 *
 *  @param sender Button Object
 */
- (IBAction)mySellingButtonClicked:(id)sender
{
    [self removeFromSuperview];
    [(MarketPlaceViewController *)delegate selectedViewControllerWithIdentifier:kCurrentMemberSellHistoryViewController];

}

/**
 *  Message
 *
 *  @param sender Button Object
 */
- (IBAction)messageButtonClicked:(id)sender
{
    [self removeFromSuperview];
    [(MarketPlaceViewController *)delegate selectedViewControllerWithIdentifier:@"A"];
}
@end
