//
//  ProductCategory.h
//  BBX
//
//  Created by rkhan-mbook on 31/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProductCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * categoryName;

@end
