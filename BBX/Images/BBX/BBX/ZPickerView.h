//
//  ZPickerView.h
//  BBX
//
//  Created by Admin's on 03/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchBBXDirectoryViewController.h"
#import "LanguageInfo.h"

@interface ZPickerView : UIView

@property (nonatomic, retain) id<SearchDirectory> delegate;
- (void)loadDataForPickerType:(DirectoryPickerType)pickerType withManagedObject:(LanguageInfo *)managedObj withViewController:(UIViewController *)vC;
@end
