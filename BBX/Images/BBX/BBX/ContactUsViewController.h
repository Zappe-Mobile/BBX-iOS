//
//  ContactUsViewController.h
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ContactUsViewController : BaseViewController
{
    IBOutlet UIView * viewBackground;
    IBOutlet UITableView * tblView;
    
    NSMutableArray * arrayCity;
    NSMutableArray * arrayStreet;
    NSMutableArray * arrayArea;
    NSMutableArray * arrayPhone;
    NSMutableArray * arrayFax;
    NSMutableArray * arrayEmail;
    NSMutableArray * arrayLatitude;
    NSMutableArray * arrayLongitude;
}
@end
