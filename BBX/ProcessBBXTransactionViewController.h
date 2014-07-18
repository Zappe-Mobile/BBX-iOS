//
//  BBXTransactionViewController.h
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SearchBBXDirectoryViewController.h"

@protocol TransactionProtocol <NSObject>

@required
- (void)selectedViewControllerWithIdentifier:(NSString *)identifier;

@end
@interface ProcessBBXTransactionViewController : BaseViewController <TransactionProtocol,SearchDirectory>

@end
