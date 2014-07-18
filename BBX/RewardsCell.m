//
//  RewardsCell.m
//  BBX
//
//  Created by Roman Khan on 15/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "RewardsCell.h"

@implementation RewardsCell
@synthesize imgProduct;
@synthesize lblProductName;
@synthesize lblProductDescription;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        imgProduct = [[UIImageView alloc]init];
        imgProduct.frame = CGRectMake(10, 10, 80, 80);
        imgProduct.backgroundColor = [UIColor clearColor];
        imgProduct.layer.cornerRadius = 5.0;
        imgProduct.layer.borderWidth = 1.0;
        imgProduct.layer.borderColor = [UIColor whiteColor].CGColor;
        
        lblProductName = [[UILabel alloc]init];
        lblProductName.frame = CGRectMake(100, 10, 100, 15);
        lblProductName.backgroundColor = [UIColor clearColor];
        lblProductName.textColor = [UIColor whiteColor];
        lblProductName.textAlignment = NSTextAlignmentLeft;
        lblProductName.font = [UIFont fontWithName:@"Avenir-Roman" size:10];
        
        lblProductDescription = [[UILabel alloc]init];
        lblProductDescription.frame = CGRectMake(100, 30, 100, 50);
        lblProductDescription.backgroundColor = [UIColor clearColor];
        lblProductDescription.textColor = [UIColor whiteColor];
        lblProductDescription.textAlignment = NSTextAlignmentLeft;
        lblProductDescription.font = [UIFont fontWithName:@"Avenir-Roman" size:9];
        lblProductDescription.numberOfLines = 0;
        lblProductDescription.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.contentView addSubview:imgProduct];
        [self.contentView addSubview:lblProductName];
        [self.contentView addSubview:lblProductDescription];
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
