//
//  InvestmentCategory.h
//  BBX
//
//  Created by rkhan-mbook on 19/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InvestmentCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * categoryText;

@end
