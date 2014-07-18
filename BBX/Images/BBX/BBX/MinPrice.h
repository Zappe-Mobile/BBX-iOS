//
//  MinPrice.h
//  BBX
//
//  Created by rkhan-mbook on 29/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MinPrice : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * value;

@end
