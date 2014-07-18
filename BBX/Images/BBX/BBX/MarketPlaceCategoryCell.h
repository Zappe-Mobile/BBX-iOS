//
//  MarketPlaceCategoryCell.h
//  BBX
//
//  Created by Roman Khan on 11/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MarketPlaceCategoryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView * viewBackground;
@property (nonatomic, strong) IBOutlet UILabel * lblCategory;
@property (nonatomic, strong) IBOutlet UIImageView * imgCategory;
@end
