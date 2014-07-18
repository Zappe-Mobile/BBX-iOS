//
//  EventsCell.m
//  BBX
//
//  Created by Roman Khan on 12/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "EventsCell.h"

@implementation EventsCell
@synthesize viewBackground;
@synthesize lblEventTitle;
@synthesize lblVenueName;
@synthesize lblVenueAddress;
@synthesize lblDateTime;
@synthesize lblContactInfo;
@synthesize lblEventsDescription;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        viewBackground = [[UIView alloc]init];
        viewBackground.frame = CGRectMake(10, 0, 300, 110);
        viewBackground.backgroundColor = [UIColor whiteColor];
        viewBackground.layer.cornerRadius = 0.0;
        viewBackground.layer.borderWidth = 1.0;
        viewBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        lblEventTitle = [[UILabel alloc]init];
        lblEventTitle.frame = CGRectMake(15, 2, 270, 30);
        lblEventTitle.backgroundColor = [UIColor clearColor];
        lblEventTitle.textColor = [UIColor blackColor];
        lblEventTitle.textAlignment = NSTextAlignmentLeft;
        lblEventTitle.font = [UIFont fontWithName:@"Helvetica" size:13];
        lblEventTitle.numberOfLines = 0;
        lblEventTitle.lineBreakMode = NSLineBreakByWordWrapping;
        
        lblVenueName = [[UILabel alloc]init];
        lblVenueName.frame = CGRectMake(15, 32, 240, 15);
        lblVenueName.backgroundColor = [UIColor clearColor];
        lblVenueName.textColor = [UIColor blackColor];
        lblVenueName.textAlignment = NSTextAlignmentLeft;
        lblVenueName.font = [UIFont fontWithName:@"Helvetica" size:13];
        
        lblVenueAddress = [[UILabel alloc]init];
        lblVenueAddress.frame = CGRectMake(15, 47, 240, 30);
        lblVenueAddress.backgroundColor = [UIColor clearColor];
        lblVenueAddress.textColor = [UIColor blackColor];
        lblVenueAddress.textAlignment = NSTextAlignmentLeft;
        lblVenueAddress.font = [UIFont fontWithName:@"Helvetica" size:13];
        lblVenueAddress.numberOfLines = 0;
        lblVenueAddress.lineBreakMode = NSLineBreakByWordWrapping;

        lblDateTime = [[UILabel alloc]init];
        lblDateTime.frame = CGRectMake(15, 77, 240, 15);
        lblDateTime.backgroundColor = [UIColor clearColor];
        lblDateTime.textColor = [UIColor blackColor];
        lblDateTime.textAlignment = NSTextAlignmentLeft;
        lblDateTime.font = [UIFont fontWithName:@"Helvetica" size:13];

        lblContactInfo = [[UILabel alloc]init];
        lblContactInfo.frame = CGRectMake(15, 92, 240, 15);
        lblContactInfo.backgroundColor = [UIColor clearColor];
        lblContactInfo.textColor = [UIColor blackColor];
        lblContactInfo.textAlignment = NSTextAlignmentLeft;
        lblContactInfo.font = [UIFont fontWithName:@"Helvetica" size:13];

        [self.contentView addSubview:viewBackground];
        [self.contentView addSubview:lblEventTitle];
        [self.contentView addSubview:lblVenueName];
        [self.contentView addSubview:lblVenueAddress];
        [self.contentView addSubview:lblDateTime];
        [self.contentView addSubview:lblContactInfo];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
