//
//  Videos.h
//  BBX
//
//  Created by rkhan-mbook on 17/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Videos : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;

@end
