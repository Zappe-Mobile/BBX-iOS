//
//  BBXWorksCell.m
//  BBX
//
//  Created by Roman Khan on 15/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "BBXWorksCell.h"

@implementation BBXWorksCell
@synthesize webVideo;
@synthesize lblTitle;
@synthesize lblDescription;
@synthesize viewBackground;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        viewBackground = [[UIView alloc]init];
        viewBackground.frame = CGRectMake(0, 0, 320, 60);
        viewBackground.backgroundColor = [UIColor colorWithRed:212.0f/255.0f green:241.0f/255.0f blue:250.0f/255.0f alpha:1.0];
        
        webVideo = [[UIWebView alloc]init];
        webVideo.frame = CGRectMake(10, 0, 80, 60);
        webVideo.layer.borderWidth = 1.0;
        webVideo.layer.borderColor = [UIColor blackColor].CGColor;
        
        lblTitle = [[UILabel alloc]init];
        lblTitle.frame = CGRectMake(100, 5, 200, 40);
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor blackColor];
        lblTitle.textAlignment = NSTextAlignmentLeft;
        lblTitle.font = [UIFont fontWithName:@"Avenir-Roman" size:11];
        lblTitle.numberOfLines = 0;
        lblTitle.lineBreakMode = NSLineBreakByWordWrapping;

        
        lblDescription = [[UILabel alloc]init];
        lblDescription.frame = CGRectMake(140, 30, 140, 30);
        lblDescription.backgroundColor = [UIColor clearColor];
        lblDescription.textColor = [UIColor whiteColor];
        lblDescription.textAlignment = NSTextAlignmentLeft;
        lblDescription.numberOfLines = 0;
        lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
        lblDescription.font = [UIFont fontWithName:@"Avenir-Roman" size:10];
        
        [self.contentView addSubview:viewBackground];
        [self.contentView addSubview:webVideo];
        [self.contentView addSubview:lblTitle];
        [self.contentView addSubview:lblDescription];
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
