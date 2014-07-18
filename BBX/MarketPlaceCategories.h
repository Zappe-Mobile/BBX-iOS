//
//  MarketPlaceCategories.h
//  BBX
//
//  Created by Roman Khan on 07/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MarketPlaceCategories : NSManagedObject

@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * categoryName;

@end
