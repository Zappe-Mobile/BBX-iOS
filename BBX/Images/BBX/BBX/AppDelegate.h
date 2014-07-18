//
//  AppDelegate.h
//  BBX
//
//  Created by Roman Khan on 02/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString * Value;
}
-(void)setController:(NSString *)value;
@property (strong, nonatomic) UIWindow *window;

@end
