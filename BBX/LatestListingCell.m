//
//  LatestListingCell.m
//  BBX
//
//  Created by Roman Khan on 14/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "LatestListingCell.h"

@implementation LatestListingCell
@synthesize viewBackground;
@synthesize imgCategory;
@synthesize lblCategory;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        viewBackground = [[UIView alloc]init];
        viewBackground.frame = CGRectMake(0, 2, 320, 76);
        viewBackground.backgroundColor = [UIColor whiteColor];
        
        imgCategory = [[UIImageView alloc]init];
        imgCategory.frame = CGRectMake(10, 10, 60, 60);
        imgCategory.backgroundColor = [UIColor clearColor];
        
        lblCategory = [[UILabel alloc]init];
        lblCategory.frame = CGRectMake(80, 12, 230, 40);
        lblCategory.backgroundColor = [UIColor clearColor];
        lblCategory.textColor = [UIColor blackColor];
        lblCategory.textAlignment = NSTextAlignmentLeft;
        lblCategory.font = [UIFont fontWithName:@"Helvetica" size:15];
        lblCategory.numberOfLines = 0;
        lblCategory.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.contentView addSubview:viewBackground];
        [self.contentView addSubview:imgCategory];
        [self.contentView addSubview:lblCategory];

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
