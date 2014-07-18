//
//  UITextView+VerticalAlignment.m
//  BBX
//
//  Created by Roman Khan on 7/17/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "UITextView+VerticalAlignment.h"

@implementation UITextView (VerticalAlignment)

- (void)alignToTop
{
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    self.contentOffset = CGPointMake(5.0f, 10.0f);
    
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 5, .y = -topCorrect+10};

}

- (void)disableAlignment
{
    [self removeObserver:self forKeyPath:@"contentSize"];
}

- (void)scrollRectToVisibleInContainingScrollView
{
    return;
}
@end
