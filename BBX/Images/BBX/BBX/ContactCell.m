//
//  ContactCell.m
//  BBX
//
//  Created by Roman Khan on 14/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell
@synthesize viewHeader;
@synthesize lblCity;
@synthesize lblStreet;
@synthesize lblArea;
@synthesize lblPhone;
@synthesize lblFax;
@synthesize lblEmail;
@synthesize mapAddress;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        viewHeader = [[UIView alloc]init];
        viewHeader.frame = CGRectMake(10, 0, 260, 20);
        viewHeader.backgroundColor = [UIColor colorWithRed:106.0f/255.0f green:137.0f/255.0f blue:205.0f/255.0f alpha:0.5];
        
        lblCity = [[UILabel alloc]init];
        lblCity.frame = CGRectMake(20, 4, 200, 15);
        lblCity.backgroundColor = [UIColor clearColor];
        lblCity.textColor = [UIColor whiteColor];
        lblCity.textAlignment = NSTextAlignmentLeft;
        lblCity.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
        
        lblStreet = [[UILabel alloc]init];
        lblStreet.frame = CGRectMake(20, 30, 200, 15);
        lblStreet.backgroundColor = [UIColor clearColor];
        lblStreet.textColor = [UIColor whiteColor];
        lblStreet.textAlignment = NSTextAlignmentLeft;
        lblStreet.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
        
        lblArea = [[UILabel alloc]init];
        lblArea.frame = CGRectMake(20, 50, 200, 15);
        lblArea.backgroundColor = [UIColor clearColor];
        lblArea.textColor = [UIColor whiteColor];
        lblArea.textAlignment = NSTextAlignmentLeft;
        lblArea.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
        
        lblPhone = [[UILabel alloc]init];
        lblPhone.frame = CGRectMake(20, 70, 200, 15);
        lblPhone.backgroundColor = [UIColor clearColor];
        lblPhone.textColor = [UIColor whiteColor];
        lblPhone.textAlignment = NSTextAlignmentLeft;
        lblPhone.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
        
        lblFax = [[UILabel alloc]init];
        lblFax.frame = CGRectMake(20, 90, 200, 15);
        lblFax.backgroundColor = [UIColor clearColor];
        lblFax.textColor = [UIColor whiteColor];
        lblFax.textAlignment = NSTextAlignmentLeft;
        lblFax.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
        
        lblEmail = [[UILabel alloc]init];
        lblEmail.frame = CGRectMake(20, 110, 200, 15);
        lblEmail.backgroundColor = [UIColor clearColor];
        lblEmail.textColor = [UIColor whiteColor];
        lblEmail.textAlignment = NSTextAlignmentLeft;
        lblEmail.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
        
        mapAddress = [[MKMapView alloc]init];
        mapAddress.frame = CGRectMake(167, 42, 100, 70);
        mapAddress.backgroundColor = [UIColor clearColor];
        mapAddress.layer.cornerRadius = 5.0;
        
        
        [self.contentView addSubview:viewHeader];
        [self.contentView addSubview:lblCity];
        [self.contentView addSubview:lblStreet];
        [self.contentView addSubview:lblArea];
        [self.contentView addSubview:lblPhone];
        [self.contentView addSubview:lblFax];
        [self.contentView addSubview:lblEmail];
        //[self.contentView addSubview:mapAddress];

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

- (void)dealloc
{
    viewHeader = nil;
    lblCity = nil;
    lblStreet = nil;
    lblArea = nil;
    lblPhone = nil;
    lblFax = nil;
    lblEmail = nil;
    mapAddress = nil;

}
@end
