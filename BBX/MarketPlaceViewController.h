//
//  MarketPlaceViewController.h
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol MarketProtocol <NSObject>

@required
- (void)selectedViewControllerWithIdentifier:(NSString *)identifier;

@end

@interface MarketPlaceViewController : BaseViewController<MarketProtocol>

@end
