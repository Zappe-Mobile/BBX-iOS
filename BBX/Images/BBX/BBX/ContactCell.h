//
//  ContactCell.h
//  BBX
//
//  Created by Roman Khan on 14/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ContactCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIView * viewHeader;
@property (nonatomic,strong) IBOutlet UILabel * lblCity;
@property (nonatomic,strong) IBOutlet UILabel * lblStreet;
@property (nonatomic,strong) IBOutlet UILabel * lblArea;
@property (nonatomic,strong) IBOutlet UILabel * lblPhone;
@property (nonatomic,strong) IBOutlet UILabel * lblFax;
@property (nonatomic,strong) IBOutlet UILabel * lblEmail;
@property (nonatomic,strong) IBOutlet MKMapView * mapAddress;

@end
