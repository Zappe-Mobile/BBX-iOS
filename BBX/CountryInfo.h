//
//  CountryInfo.h
//  BBX
//
//  Created by Admin's on 04/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CountryInfo : NSManagedObject

@property (nonatomic, retain) NSString * countryId;
@property (nonatomic, retain) NSString * countryName;

@end
