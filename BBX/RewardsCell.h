//
//  RewardsCell.h
//  BBX
//
//  Created by Roman Khan on 15/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RewardsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView * imgProduct;
@property (nonatomic, strong) IBOutlet UILabel * lblProductName;
@property (nonatomic, strong) IBOutlet UILabel * lblProductDescription;

@end
