//
//  UIDevice+Extras.m
//  BBX
//
//  Created by Roman Khan on 03/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "UIDevice+Extras.h"

@implementation UIDevice (Extras)

-(BOOL)isIPhone5 {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) &&
    [UIScreen mainScreen].bounds.size.height == 568.0;
}

-(BOOL)IS_OS_7 {
    
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}

-(BOOL)IS_OS_6 {
    
    return [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0;
}

@end
