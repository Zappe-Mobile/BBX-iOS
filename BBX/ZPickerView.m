//
//  ZPickerView.m
//  BBX
//
//  Created by Admin's on 03/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ZPickerView.h"
#import "DataManager.h"
#import "CountryInfo.h"
#import "StateInfo.h"
#import "ProductCategory.h"
#import "LanguageInfo.h"
#import "MinPrice.h"
#import "MaxPrice.h"
#import "InvestmentCategory.h"
#import "InvestmentSearchViewController.h"
#import "InviteFriendViewController.h"
#import "ProcessBBXTransactionViewController.h"
#import "PayFeeViewController.h"

@interface ZPickerView ()
{
    NSMutableArray * arrayPickerName;
    NSMutableArray * arrayPickerId;
    
    DirectoryPickerType type;
    
    IBOutlet UIPickerView * pickerViewDirectory;
    NSInteger selectedRow;
    UIViewController * viewController;
}
@end

@implementation ZPickerView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadDataForPickerType:(DirectoryPickerType)pickerType withManagedObject:(LanguageInfo *)managedObj withViewController:(UIViewController *)vC
{
    type = pickerType;
    viewController = vC;
    
    arrayPickerId = [[NSMutableArray alloc]init];
    arrayPickerName = [[NSMutableArray alloc]init];
    
    switch (pickerType) {
        case DirectoryPickerTypeCountry:
        {
            [self setCountryData:[DataManager loadAllActiveCountryFromCoreData]];
            
        }
            break;
        case DirectoryPickerTypeState:
        {
            [self setStateData:[DataManager loadAllStateInfoForCountryIdFromCoreData]];
        }
            break;
        case DirectoryPickerTypeCategory:
        {
            [self setCategoryData:[DataManager loadAllProductCategoriesFromCoreData]];
        }
            break;
        case DirectoryPickerTypeLanguage:
        {
            [self setLanguageData:[DataManager loadAllActiveLanguageFromCoreData]];
        }
            break;
        case DIrectoryPickerTypeSelectedCountry:
        {
            [self setSelectedCountryData:managedObj];
        }
            break;
        case DirectoryPickerTypeMinPrice:
        {
            [self setMinPriceData:[DataManager loadMinPriceFromCoreData]];
        }
            break;
        case DirectoryPickerTypeMaxPrice:
        {
            [self setMaxPriceData:[DataManager loadMaxPriceFromCoreData]];
        }
            break;
        case DirectoryPickerTypeInvestmentCategory:
        {
            [self setInvestmentCategory:[DataManager loadAllInvestmentCategoryDataFromCoreData]];
        }
            break;
        case InviteFriendEmailPickerTypeCountry:
        {
            [self setCountryData:[DataManager loadAllActiveCountryFromCoreData]];
        }
            break;
        case InviteFriendEmailPickerTypeLanguage:
        {
            [self setSelectedCountryData:managedObj];
        }
            break;
        case InviteFriendSMSPickerTypeCountry:
        {
            [self setCountryData:[DataManager loadAllActiveCountryFromCoreData]];
        }
            break;
        case InviteFriendSMSPickerTypeLanguage:
        {
            [self setSelectedCountryData:managedObj];
        }
            break;
        case TransactionPickerTypeCategory:
        {
            [self setTransactionCategoryData];
        }
            break;
        case PayFeePickerTypeMonth:
        {
            [self setMonthData];
        }
            break;
        case PayFeePickerTypeYear:
        {
            [self setYearData];
        }
            break;
        default:
            break;
    }
    
    [pickerViewDirectory reloadAllComponents];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (type) {
        case DirectoryPickerTypeCountry:
            return [arrayPickerName count];
            break;
        case DirectoryPickerTypeState:
            return [arrayPickerName count];
            break;
        case DirectoryPickerTypeCategory:
            return [arrayPickerName count];
            break;
        case DirectoryPickerTypeLanguage:
            return [arrayPickerName count];
            break;
        case DIrectoryPickerTypeSelectedCountry:
            return [arrayPickerName count];
            break;
        case DirectoryPickerTypeMinPrice:
            return [arrayPickerName count];
            break;
        case DirectoryPickerTypeMaxPrice:
            return [arrayPickerName count];
            break;
        case DirectoryPickerTypeInvestmentCategory:
            return [arrayPickerName count];
            break;
        case InviteFriendEmailPickerTypeCountry:
            return [arrayPickerName count];
            break;
        case InviteFriendEmailPickerTypeLanguage:
            return [arrayPickerName count];
            break;
        case InviteFriendSMSPickerTypeCountry:
            return [arrayPickerName count];
            break;
        case InviteFriendSMSPickerTypeLanguage:
            return [arrayPickerName count];
            break;
        case TransactionPickerTypeCategory:
            return [arrayPickerName count];
            break;
        case PayFeePickerTypeMonth:
            return [arrayPickerName count];
            break;
        case PayFeePickerTypeYear:
            return [arrayPickerName count];
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (type) {
        case DirectoryPickerTypeCountry:
            return [arrayPickerName objectAtIndex:row];
            break;
        case DirectoryPickerTypeState:
            return [arrayPickerName objectAtIndex:row];
            break;
        case DirectoryPickerTypeCategory:
            return [arrayPickerName objectAtIndex:row];
            break;
        case DirectoryPickerTypeLanguage:
            return [arrayPickerName objectAtIndex:row];
            break;
        case DIrectoryPickerTypeSelectedCountry:
            return [arrayPickerName objectAtIndex:row];
            break;
        case DirectoryPickerTypeMinPrice:
            return [arrayPickerName objectAtIndex:row];
            break;
        case DirectoryPickerTypeMaxPrice:
            return [arrayPickerName objectAtIndex:row];
            break;
        case DirectoryPickerTypeInvestmentCategory:
            return [arrayPickerName objectAtIndex:row];
            break;
        case InviteFriendEmailPickerTypeCountry:
            return [arrayPickerName objectAtIndex:row];
            break;
        case InviteFriendEmailPickerTypeLanguage:
            return [arrayPickerName objectAtIndex:row];
            break;
        case InviteFriendSMSPickerTypeCountry:
            return [arrayPickerName objectAtIndex:row];
            break;
        case InviteFriendSMSPickerTypeLanguage:
            return [arrayPickerName objectAtIndex:row];
            break;
        case TransactionPickerTypeCategory:
            return [arrayPickerName objectAtIndex:row];
            break;
        case PayFeePickerTypeMonth:
            return [arrayPickerName objectAtIndex:row];
            break;
        case PayFeePickerTypeYear:
            return [arrayPickerName objectAtIndex:row];
            break;
        default:
            break;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow = row;
}


- (IBAction)cancelButtonClicked:(id)sender
{
    switch (type) {
        case DirectoryPickerTypeCountry:
        {
            [(SearchBBXDirectoryViewController *) delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:DirectoryPickerTypeCountry];
        }
            break;
        default:
            break;
    }
    [self removeFromSuperview];
}

- (IBAction)doneButtonClicked:(id)sender
{
    switch (type) {
        case DirectoryPickerTypeCountry:
        {
            [(SearchBBXDirectoryViewController *) delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:DirectoryPickerTypeCountry];
        }
            break;
        case DirectoryPickerTypeState:
        {
            [(SearchBBXDirectoryViewController *) delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:DirectoryPickerTypeState];
            
        }
            break;
        case DirectoryPickerTypeCategory:
        {
            [(SearchBBXDirectoryViewController *) delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:DirectoryPickerTypeCategory];
            
        }
            break;
        case DirectoryPickerTypeLanguage:
        {
            [(SearchBBXDirectoryViewController *) delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:DirectoryPickerTypeLanguage];
            
        }
            break;
        case DIrectoryPickerTypeSelectedCountry:
        {
            [(SearchBBXDirectoryViewController *) delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:DIrectoryPickerTypeSelectedCountry];

        }
            break;
        case DirectoryPickerTypeMinPrice:
        {
            [(InvestmentSearchViewController *) delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:DirectoryPickerTypeMinPrice];
        }
            break;
        case DirectoryPickerTypeMaxPrice:
        {
            [(InvestmentSearchViewController *) delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:DirectoryPickerTypeMaxPrice];
        }
            break;
        case DirectoryPickerTypeInvestmentCategory:
        {
            [(InvestmentSearchViewController *) delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:DirectoryPickerTypeInvestmentCategory];
        }
            break;
        case InviteFriendEmailPickerTypeCountry:
        {
            [(InviteFriendViewController *)delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:InviteFriendEmailPickerTypeCountry];
        }
            break;
        case InviteFriendEmailPickerTypeLanguage:
        {
            [(InviteFriendViewController *)delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:InviteFriendEmailPickerTypeLanguage];
        }
            break;
        case InviteFriendSMSPickerTypeCountry:
        {
            [(InviteFriendViewController *)delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:InviteFriendSMSPickerTypeCountry];
        }
            break;
        case InviteFriendSMSPickerTypeLanguage:
        {
            [(InviteFriendViewController *)delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:InviteFriendSMSPickerTypeLanguage];
        }
            break;
        case TransactionPickerTypeCategory:
        {
            [(ProcessBBXTransactionViewController *)delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:@"" WithPickerType:TransactionPickerTypeCategory];
        }
            break;
        case PayFeePickerTypeMonth:
        {
            [(PayFeeViewController *)delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:PayFeePickerTypeMonth];
        }
            break;
        case PayFeePickerTypeYear:
        {
            [(PayFeeViewController *)delegate setSelectedValue:[arrayPickerName objectAtIndex:selectedRow] WithSelectedId:[arrayPickerId objectAtIndex:selectedRow] WithPickerType:PayFeePickerTypeYear];
        }
            break;
        default:
            break;
    }

    [self removeFromSuperview];
}


- (void)setCountryData:(NSArray *)countryArray
{
    for (CountryInfo * Object in countryArray) {
        
        [arrayPickerId addObject:Object.countryId];
        [arrayPickerName addObject:Object.countryName];
        
    }
}


- (void)setStateData:(NSArray *)stateArray
{
    [arrayPickerId removeAllObjects];
    [arrayPickerName removeAllObjects];
    
    for (StateInfo * Object in stateArray) {
        
        [arrayPickerId addObject:Object.stateId];
        [arrayPickerName addObject:Object.stateName];

    }
}


- (void)setCategoryData:(NSArray *)categoryArray
{
    [arrayPickerId removeAllObjects];
    [arrayPickerName removeAllObjects];

    for (ProductCategory * Object in categoryArray) {
        
        [arrayPickerId addObject:Object.categoryId];
        [arrayPickerName addObject:Object.categoryName];
        
    }

}


- (void)setLanguageData:(NSArray *)languageArray
{
    [arrayPickerId removeAllObjects];
    [arrayPickerName removeAllObjects];

    for (LanguageInfo * Object in languageArray) {
        
        [arrayPickerId addObject:Object.languageId];
        [arrayPickerName addObject:Object.languageName];
        
    }

}


- (void)setSelectedCountryData:(LanguageInfo *)info
{
    [arrayPickerId removeAllObjects];
    [arrayPickerName removeAllObjects];
        
    [arrayPickerId addObject:info.languageId];
    [arrayPickerName addObject:info.languageName];

}

- (void)setMinPriceData:(NSArray *)minPriceArray
{
    [arrayPickerId removeAllObjects];
    [arrayPickerName removeAllObjects];
    
    for (MinPrice * Object in minPriceArray) {
        
        [arrayPickerId addObject:Object.value];
        [arrayPickerName addObject:Object.name];
        
    }

}

- (void)setMaxPriceData:(NSArray *)maxPriceArray
{
    [arrayPickerId removeAllObjects];
    [arrayPickerName removeAllObjects];
    
    for (MaxPrice * Object in maxPriceArray) {
        
        [arrayPickerId addObject:Object.value];
        [arrayPickerName addObject:Object.name];
        
    }

}

- (void)setInvestmentCategory:(NSArray *)investmentCategoryArray
{
    [arrayPickerId removeAllObjects];
    [arrayPickerName removeAllObjects];
    
    for (InvestmentCategory * Object in investmentCategoryArray) {
        
        [arrayPickerId addObject:Object.categoryId];
        [arrayPickerName addObject:Object.categoryText];
        
    }

}

- (void)setTransactionCategoryData
{
    [arrayPickerId removeAllObjects];
    [arrayPickerName removeAllObjects];
    
    
    arrayPickerId = [[NSMutableArray alloc]initWithObjects:@"",@"",nil];
    arrayPickerName = [[NSMutableArray alloc]initWithObjects:@"Seller",@"Buyer",nil];
}


- (void)setMonthData
{
    [arrayPickerId removeAllObjects];
    [arrayPickerName removeAllObjects];

    arrayPickerId = [[NSMutableArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
    arrayPickerName = [[NSMutableArray alloc]initWithObjects:@"Jan",@"Feb",@"March",@"April",@"May",@"June",@"July",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];

}


- (void)setYearData
{
    [arrayPickerId removeAllObjects];
    [arrayPickerName removeAllObjects];

    arrayPickerId = [[NSMutableArray alloc]initWithObjects:@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",nil];
    arrayPickerName = [[NSMutableArray alloc]initWithObjects:@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",nil];

}

@end
