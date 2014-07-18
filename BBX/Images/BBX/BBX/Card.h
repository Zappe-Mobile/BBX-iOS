//
//  Card.h
//  BBX
//
//  Created by rkhan-mbook on 14/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * cardExpire;
@property (nonatomic, retain) NSString * cardName;
@property (nonatomic, retain) NSString * cardNumber;
@property (nonatomic, retain) NSString * cardType;

@end
