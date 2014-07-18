//
//  Directory.h
//  BBX
//
//  Created by Admin's on 04/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Directory : NSManagedObject

@property (nonatomic, retain) NSString * directoryAddress;
@property (nonatomic, retain) NSString * directoryBuyPeriod;
@property (nonatomic, retain) NSString * directoryBuyPrepaidTextLink;
@property (nonatomic, retain) NSString * directoryCommEmail;
@property (nonatomic, retain) NSString * directoryCommFax;
@property (nonatomic, retain) NSString * directoryCommMobile;
@property (nonatomic, retain) NSString * directoryCommPhone;
@property (nonatomic, retain) NSString * directoryCommWebsite;
@property (nonatomic, retain) NSString * directoryCompany;
@property (nonatomic, retain) NSString * directoryContactPerson;
@property (nonatomic, retain) NSString * directoryId;
@property (nonatomic, retain) NSString * directoryMemberId;
@property (nonatomic, retain) NSString * directoryMepId;
@property (nonatomic, retain) NSString * directoryNetwordId;
@property (nonatomic, retain) NSString * directoryPPCText;
@property (nonatomic, retain) NSString * directoryPrcId;
@property (nonatomic, retain) NSString * directoryPrcImage;
@property (nonatomic, retain) NSString * directoryProductCategory;
@property (nonatomic, retain) NSString * directoryStaIdState;
@property (nonatomic, retain) NSString * directoryState;
@property (nonatomic, retain) NSString * directorySuburb;
@property (nonatomic, retain) NSString * directoryText;

@end
