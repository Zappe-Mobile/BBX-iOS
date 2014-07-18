//
//  SearchBBXDirectoryViewController.h
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, DirectoryPickerType)
{
    DirectoryPickerTypeCountry=0,
    DirectoryPickerTypeState,
    DirectoryPickerTypeCategory,
    DirectoryPickerTypeLanguage,
    DIrectoryPickerTypeSelectedCountry,
    DirectoryPickerTypeInvestmentCategory,
    DirectoryPickerTypeMinPrice,
    DirectoryPickerTypeMaxPrice,
    InviteFriendEmailPickerTypeCountry,
    InviteFriendEmailPickerTypeLanguage,
    InviteFriendSMSPickerTypeCountry,
    InviteFriendSMSPickerTypeLanguage,
    TransactionPickerTypeCategory,
    PayFeePickerTypeMonth,
    PayFeePickerTypeYear
};



@class ZPickerView;
@protocol SearchDirectory <NSObject>

@required
-(void)setSelectedValue:(NSString *)value WithSelectedId:(NSString *)selectedId WithPickerType:(DirectoryPickerType)pickerType;

@end


@interface SearchBBXDirectoryViewController : BaseViewController <SearchDirectory>

@end
