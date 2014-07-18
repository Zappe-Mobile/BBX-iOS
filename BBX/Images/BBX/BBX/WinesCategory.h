//
//  WinesCategory.h
//  BBX
//
//  Created by Admin's on 25/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WinesCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * categoryName;

@end
