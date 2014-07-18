//
//  EventsCell.h
//  BBX
//
//  Created by Roman Khan on 12/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView * viewBackground;
@property (nonatomic, strong) IBOutlet UILabel * lblEventTitle;
@property (nonatomic, strong) IBOutlet UILabel * lblVenueName;
@property (nonatomic, strong) IBOutlet UILabel * lblVenueAddress;
@property (nonatomic, strong) IBOutlet UILabel * lblDateTime;
@property (nonatomic, strong) IBOutlet UILabel * lblEventsDescription;
@property (nonatomic, strong) IBOutlet UILabel * lblContactInfo;

@end
