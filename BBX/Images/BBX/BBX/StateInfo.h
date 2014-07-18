//
//  StateInfo.h
//  BBX
//
//  Created by Admin's on 03/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StateInfo : NSManagedObject

@property (nonatomic, retain) NSString * stateId;
@property (nonatomic, retain) NSString * stateName;

@end
