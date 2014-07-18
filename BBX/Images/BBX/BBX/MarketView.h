//
//  MarketView.h
//  BBX
//
//  Created by Roman Khan on 08/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketPlaceViewController.h"

@interface MarketView : UIView

@property (nonatomic, strong) id<MarketProtocol> delegate;

@end
