//
//  AboutUsViewController.h
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"

@protocol AboutUsProtocol <NSObject>

@required
- (void)selectedViewControllerWithIdentifier:(NSString *)identifier;

@end

@interface AboutUsViewController : BaseViewController <AboutUsProtocol>
{
    IBOutlet UIView * viewBackground;
    IBOutlet UITextView * txtAboutUs;
    
    UIView * viewAbout;
}
@end
