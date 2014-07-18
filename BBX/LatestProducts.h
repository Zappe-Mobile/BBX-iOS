//
//  LatestProducts.h
//  BBX
//
//  Created by Roman Khan on 14/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LatestProducts : NSManagedObject

@property (nonatomic, retain) NSString * sellId;
@property (nonatomic, retain) NSString * sellMemId;
@property (nonatomic, retain) NSString * sellTitle;
@property (nonatomic, retain) NSString * sellDescription;
@property (nonatomic, retain) NSString * sellQuantity;
@property (nonatomic, retain) NSString * sellPricePerQuantityCash;
@property (nonatomic, retain) NSString * sellPricePerQuantityTrade;
@property (nonatomic, retain) NSString * sellNoOfViews;
@property (nonatomic, retain) NSString * sellDatePosted;
@property (nonatomic, retain) NSString * sellDateExpire;
@property (nonatomic, retain) NSString * sellCrrId;
@property (nonatomic, retain) NSString * sellEnteredByMemId;
@property (nonatomic, retain) NSString * lastBidAmount;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * sellCatId;
@property (nonatomic, retain) NSString * image;

@end
