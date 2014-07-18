//
//  Events.h
//  BBX
//
//  Created by Roman Khan on 12/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Events : NSManagedObject

@property (nonatomic, retain) NSString * eventType;
@property (nonatomic, retain) NSString * eventContactInfo;
@property (nonatomic, retain) NSString * eventCostDetails;
@property (nonatomic, retain) NSString * eventDateTime;
@property (nonatomic, retain) NSString * eventTitle;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * eventVenueAddress;
@property (nonatomic, retain) NSString * eventVenueName;

@end
