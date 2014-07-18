//
//  UINavigationController+Extras.m
//  BBX
//
//  Created by Roman Khan on 03/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "UINavigationController+Extras.h"

@implementation UINavigationController (Extras)

-(UILabel *)setTitleView:(NSString *)title
{
    UILabel * lblTitle = [[UILabel alloc]init];
    lblTitle.frame = CGRectMake(0, 0, 40, 25);
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.text = title;
    lblTitle.font = [UIFont fontWithName:@"Sakkal Majalla-Regular" size:20];
    
    return lblTitle;
    
}

@end
