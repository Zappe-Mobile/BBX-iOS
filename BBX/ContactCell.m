//
//  ContactCell.m
//  BBX
//
//  Created by Roman Khan on 14/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ContactCell.h"
#import "UITextView+VerticalAlignment.h"

@implementation ContactCell
@synthesize viewBackground;
@synthesize lblCity;
@synthesize lblStreet;
@synthesize lblArea;
@synthesize txtPhone;
@synthesize lblFax;
@synthesize lblEmail;
@synthesize mapAddress;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        viewBackground = [[UIView alloc]init];
        viewBackground.frame = CGRectMake(10, 0, 300, 143);
        viewBackground.backgroundColor = [UIColor whiteColor];
        viewBackground.layer.cornerRadius = 0.0;
        viewBackground.layer.borderWidth = 1.0;
        viewBackground.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        lblCity = [[UILabel alloc]init];
        lblCity.frame = CGRectMake(20, 4, 200, 15);
        lblCity.backgroundColor = [UIColor clearColor];
        lblCity.textColor = [UIColor blackColor];
        lblCity.textAlignment = NSTextAlignmentLeft;
        lblCity.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
        
        lblStreet = [[UILabel alloc]init];
        lblStreet.frame = CGRectMake(20, 30, 200, 15);
        lblStreet.backgroundColor = [UIColor clearColor];
        lblStreet.textColor = [UIColor blackColor];
        lblStreet.textAlignment = NSTextAlignmentLeft;
        lblStreet.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
        
        lblArea = [[UILabel alloc]init];
        lblArea.frame = CGRectMake(20, 50, 200, 15);
        lblArea.backgroundColor = [UIColor clearColor];
        lblArea.textColor = [UIColor blackColor];
        lblArea.textAlignment = NSTextAlignmentLeft;
        lblArea.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
        
        txtPhone = [[UITextView alloc]init];
        txtPhone.frame = CGRectMake(20, 70, 200, 15);
        txtPhone.backgroundColor = [UIColor clearColor];
        txtPhone.textColor = [UIColor blackColor];
        txtPhone.textAlignment = NSTextAlignmentLeft;
        txtPhone.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
        txtPhone.editable = NO;
        txtPhone.dataDetectorTypes = UIDataDetectorTypeAll;
        [txtPhone alignToTop];
        
        lblFax = [[UILabel alloc]init];
        lblFax.frame = CGRectMake(20, 90, 200, 15);
        lblFax.backgroundColor = [UIColor clearColor];
        lblFax.textColor = [UIColor blackColor];
        lblFax.textAlignment = NSTextAlignmentLeft;
        lblFax.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
        
        lblEmail = [[UILabel alloc]init];
        lblEmail.frame = CGRectMake(20, 110, 200, 15);
        lblEmail.backgroundColor = [UIColor clearColor];
        lblEmail.textColor = [UIColor blackColor];
        lblEmail.textAlignment = NSTextAlignmentLeft;
        lblEmail.font = [UIFont fontWithName:@"Avenir-Roman" size:12];
        lblEmail.userInteractionEnabled = YES;
        
        mapAddress = [[MKMapView alloc]init];
        mapAddress.frame = CGRectMake(167, 42, 100, 70);
        mapAddress.backgroundColor = [UIColor clearColor];
        mapAddress.layer.cornerRadius = 5.0;
        
        
        [self.contentView addSubview:viewBackground];
        [self.contentView addSubview:lblCity];
        [self.contentView addSubview:lblStreet];
        [self.contentView addSubview:lblArea];
        [self.contentView addSubview:txtPhone];
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
    viewBackground = nil;
    lblCity = nil;
    lblStreet = nil;
    lblArea = nil;
    txtPhone = nil;
    lblFax = nil;
    lblEmail = nil;
    mapAddress = nil;

}
@end
