//
//  AboutView.h
//  BBX
//
//  Created by Roman Khan on 19/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutUsViewController.h"

@interface AboutView : UIView

@property (nonatomic, strong) id<AboutUsProtocol> delegate;

@end
