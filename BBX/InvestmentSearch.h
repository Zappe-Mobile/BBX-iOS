//
//  InvestmentSearch.h
//  BBX
//
//  Created by Roman Khan on 7/17/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InvestmentSearch : NSManagedObject

@property (nonatomic, retain) NSString * selId;
@property (nonatomic, retain) NSString * selTitle;
@property (nonatomic, retain) NSString * selMemId;
@property (nonatomic, retain) NSString * selCatId;
@property (nonatomic, retain) NSString * selDescription;
@property (nonatomic, retain) NSString * selStaIdType;
@property (nonatomic, retain) NSString * selQuantity;
@property (nonatomic, retain) NSString * selPricePerQuantityCash;
@property (nonatomic, retain) NSString * selPricePerQuantityTrade;
@property (nonatomic, retain) NSString * selStaIdStatus;
@property (nonatomic, retain) NSString * selNoOfViews;
@property (nonatomic, retain) NSString * selDatePosted;
@property (nonatomic, retain) NSString * selDateExpire;
@property (nonatomic, retain) NSString * selCrrId;

@end
