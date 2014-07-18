//
//  MarketPlaceCategoryCell.m
//  BBX
//
//  Created by Roman Khan on 11/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "MarketPlaceCategoryCell.h"

@implementation MarketPlaceCategoryCell
@synthesize viewBackground;
@synthesize lblCategory;
@synthesize imgCategory;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        viewBackground = [[UIView alloc]init];
        viewBackground.frame = CGRectMake(0, 2, 280, 40);
        viewBackground.backgroundColor = [UIColor whiteColor];
        
        lblCategory = [[UILabel alloc]init];
        lblCategory.frame = CGRectMake(10, 12, 200, 20);
        lblCategory.backgroundColor = [UIColor clearColor];
        lblCategory.textColor = [UIColor whiteColor];
        lblCategory.textAlignment = NSTextAlignmentLeft;
        lblCategory.font = [UIFont fontWithName:@"Helvetica" size:15];
        
        imgCategory = [[UIImageView alloc]init];
        imgCategory.frame = CGRectMake(220, 10, 60, 30);
        imgCategory.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:viewBackground];
        [self.contentView addSubview:lblCategory];
        [self.contentView addSubview:imgCategory];
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
