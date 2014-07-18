//
//  ProcessTransactionView.h
//  BBX
//
//  Created by Roman Khan on 09/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcessBBXTransactionViewController.h"

@interface ProcessTransactionView : UIView

@property (nonatomic, strong) id<TransactionProtocol> delegate;
@end
