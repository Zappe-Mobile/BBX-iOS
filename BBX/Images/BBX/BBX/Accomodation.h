//
//  Accomodation.h
//  BBX
//
//  Created by rkhan-mbook on 30/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Accomodation : NSManagedObject

@property (nonatomic, retain) NSString * giftCardId;
@property (nonatomic, retain) NSString * giftCardAmount;
@property (nonatomic, retain) NSString * giftCardAvailableQuantity;
@property (nonatomic, retain) NSString * currencyName;
@property (nonatomic, retain) NSString * giftCardHeading;
@property (nonatomic, retain) NSString * giftCardSubHeading;
@property (nonatomic, retain) NSString * giftCardDetails;
@property (nonatomic, retain) NSString * giftCardPostalCode;
@property (nonatomic, retain) NSString * giftCardTerms;
@property (nonatomic, retain) NSString * giftCardAddress;
@property (nonatomic, retain) NSString * giftCardContactPerson;
@property (nonatomic, retain) NSString * giftCardContactPhone;
@property (nonatomic, retain) NSString * giftCardMemberName;
@property (nonatomic, retain) NSString * imageFirstSmall;
@property (nonatomic, retain) NSString * imageSecondSmall;
@property (nonatomic, retain) NSString * imageThirdSmall;
@property (nonatomic, retain) NSString * imageFourthSmall;
@property (nonatomic, retain) NSString * imageFirst;
@property (nonatomic, retain) NSString * imageSecond;
@property (nonatomic, retain) NSString * imageThird;
@property (nonatomic, retain) NSString * imageFourth;

@end
