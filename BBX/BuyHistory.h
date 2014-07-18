//
//  BuyHistory.h
//  BBX
//
//  Created by Admin on 17/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BuyHistory : NSManagedObject

@property (nonatomic, retain) NSString * buyDateTime;
@property (nonatomic, retain) NSString * buyId;
@property (nonatomic, retain) NSString * buyMemId;
@property (nonatomic, retain) NSString * buyPricePerQuantityCash;
@property (nonatomic, retain) NSString * buyPricePerQuantityTrade;
@property (nonatomic, retain) NSString * buyQuantity;
@property (nonatomic, retain) NSString * buySelId;
@property (nonatomic, retain) NSString * buyStaIdType;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * selCrrId;
@property (nonatomic, retain) NSString * selDescription;
@property (nonatomic, retain) NSString * selMemId;
@property (nonatomic, retain) NSString * selTitle;

@end
