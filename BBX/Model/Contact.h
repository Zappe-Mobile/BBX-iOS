//
//  Contact.h
//  BBX
//
//  Created by Roman Khan on 03/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, strong) NSString * franchiseName;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * fax;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * mapLocation;
@property (nonatomic, strong) NSString * contactPerson;

@end
