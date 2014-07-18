//
//  Labels.h
//  BBX
//
//  Created by rkhan-mbook on 22/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Labels : NSManagedObject

@property (nonatomic, retain) NSString * languageId;
@property (nonatomic, retain) NSString * countryId;
@property (nonatomic, retain) NSString * keyText;
@property (nonatomic, retain) NSString * valueText;
@property (nonatomic, retain) NSString * labelId;

@end
