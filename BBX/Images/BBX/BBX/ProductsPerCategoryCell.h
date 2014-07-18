//
//  ProductsPerCategoryCell.h
//  BBX
//
//  Created by Roman Khan on 12/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsPerCategoryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView * viewBackground;
@property (nonatomic, strong) IBOutlet UIImageView * imgCategory;
@property (nonatomic, strong) IBOutlet UILabel * lblCategory;

@end
