//
//  FrontImageDetail.h
//  BBX
//
//  Created by Roman Khan on 7/16/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FrontImageDetail : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * latestBidAmount;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * rowNumber;
@property (nonatomic, retain) NSString * selCategoryId;
@property (nonatomic, retain) NSString * selCrrId;
@property (nonatomic, retain) NSString * selDateExpire;
@property (nonatomic, retain) NSString * selDatePosted;
@property (nonatomic, retain) NSString * selDis;
@property (nonatomic, retain) NSString * selEnteredByMemId;
@property (nonatomic, retain) NSString * selId;
@property (nonatomic, retain) NSString * selMemId;
@property (nonatomic, retain) NSString * selNoOfViews;
@property (nonatomic, retain) NSString * selPricePerQuantityCash;
@property (nonatomic, retain) NSString * selPricePerQuantityTrade;
@property (nonatomic, retain) NSString * selQuantity;
@property (nonatomic, retain) NSString * selTitle;
@property (nonatomic, retain) NSString * totalPages;
@property (nonatomic, retain) NSString * totalRecords;

@end
