//
//  BBXWorksCell.h
//  BBX
//
//  Created by Roman Khan on 15/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BBXWorksCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView * viewBackground;
@property (nonatomic, strong) IBOutlet UIWebView * webVideo;
@property (nonatomic, strong) IBOutlet UILabel * lblTitle;
@property (nonatomic, strong) IBOutlet UILabel * lblDescription;
@end
