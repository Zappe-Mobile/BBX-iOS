//
//  LeisureDetailViewController.h
//  BBX
//
//  Created by rkhan-mbook on 27/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeisureDetailViewController : UIViewController

@property (nonatomic, strong) NSString * giftPackageHeading;
@property (nonatomic, strong) NSString * giftPackageSubHeading;
@property (nonatomic, strong) NSString * giftPackageDescription;
@property (nonatomic, strong) NSString * giftPackagePrice;
@property (nonatomic, strong) NSString * giftPackageAddress;
@property (nonatomic, strong) NSString * giftPackageImage;
- (id)initWithDictionary:(NSManagedObject *)dict;
@end
