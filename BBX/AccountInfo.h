//
//  AccountInfo.h
//  BBX
//
//  Created by rkhan-mbook on 23/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AccountInfo : NSManagedObject

@property (nonatomic, retain) NSString * accountManagerEmail;
@property (nonatomic, retain) NSString * accountManagerName;
@property (nonatomic, retain) NSString * accountManagerNumber;
@property (nonatomic, retain) NSString * availableSpending;
@property (nonatomic, retain) NSString * cashBalance;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * creditLine;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * franchise;
@property (nonatomic, retain) NSString * mailingAddress;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * streetAddress;
@property (nonatomic, retain) NSString * tradeBalance;
@property (nonatomic, retain) NSString * tradingName;
@property (nonatomic, retain) NSString * website;

@end
