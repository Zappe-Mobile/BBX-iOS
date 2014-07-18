//
//  InvestmentSearchViewController.m
//  BBX
//
//  Created by rkhan-mbook on 29/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "InvestmentSearchViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "InvestmentSearchResultsViewController.h"
#import "ZPickerView.h"
#import "UIDevice+Extras.h"
#import "SVProgressHUD.h"
#import "Reachability.h"

@interface InvestmentSearchViewController ()
{
    __weak IBOutlet UITextField * txtKeyword;
    __weak IBOutlet UIButton * btnCategory;
    __weak IBOutlet UIButton * btnMinPrice;
    __weak IBOutlet UIButton * btnMaxPrice;
    
    NSString * minPriceValue;
    NSString * maxPriceValue;
    NSString * categoryValue;
}
@property (strong, nonatomic) ZPickerView * containerView;
@end

@implementation InvestmentSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //! Navigation Bar Setup
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Investment Search", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    minPriceValue = @"";
    maxPriceValue = @"";
    categoryValue = @"";

    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getInvestmentPriceMaxWithCountryId:@"5" withCompletionBlock:^(BOOL result, id resultObject) {
            
            if (result) {
                
                [DataManager storeMaxPriceData:[resultObject objectForKey:@"Table1"] DataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        
                        [[RequestManager sharedManager]getInvestmentPriceMinWithCountryId:@"5" withCompletionBlock:^(BOOL result, id resultObject) {
                            
                            [SVProgressHUD dismiss];
                            if (result) {
                                
                                [DataManager storeMinPriceData:[resultObject objectForKey:@"Table1"] DataBlock:^(BOOL success, NSError *error) {
                                    
                                    if (success) {
                                        
                                    }
                                    else {
                                        [SVProgressHUD dismiss];
                                    }
                                }];
                            }
                            else {
                                [SVProgressHUD dismiss];
                            }
                        }];
                        
                    }
                    else {
                        [SVProgressHUD dismiss];
                    }
                }];
            }
            else {
                [SVProgressHUD dismiss];
            }
        }];

    }
    else {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Internet Connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}





#pragma mark - Set Navigation Bar Left Button
//! Set Left Bar Button
- (UIBarButtonItem *)setLeftBarButton
{
    UIButton * btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSettings.frame = CGRectMake(0, 0, 20, 20);
    [btnSettings setImage:[UIImage imageNamed:@"navbar_btn_back@2x.png"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(btnLeftBarClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:btnSettings];
    
    return barBtnItem;
}

#pragma mark - Navigation Bar Left Button Selector
//! Method invoked when left bar button clicked
- (void)btnLeftBarClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)getMinPriceClicked:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:DirectoryPickerTypeMinPrice withManagedObject:nil withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}


- (IBAction)getMaxPriceClicked:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:DirectoryPickerTypeMaxPrice withManagedObject:nil withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}


- (IBAction)getCategoryClicked:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:DirectoryPickerTypeInvestmentCategory withManagedObject:nil withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}

- (IBAction)searchButtonClicked:(id)sender
{
    [[RequestManager sharedManager]getInvestmentSearchWithKeyword:txtKeyword.text withPriceStart:minPriceValue withPriceEnd:maxPriceValue withCategoryId:categoryValue withLanguageId:@"247" withCountryId:@"5" withPageNumber:@"1" withProductsCount:@"100" withCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
        }
        else {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Request Failed.Internal Server Error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [alert show];
            
        }
    }];
}


- (void)setSelectedValue:(NSString *)value WithSelectedId:(NSString *)selectedId WithPickerType:(DirectoryPickerType)pickerType
{
    switch (pickerType) {
        case DirectoryPickerTypeInvestmentCategory:
        {
            categoryValue = selectedId;
            [btnCategory setTitle:value forState:UIControlStateNormal];
        }
            break;
        case DirectoryPickerTypeMinPrice:
        {
            minPriceValue = selectedId;
            [btnMinPrice setTitle:value forState:UIControlStateNormal];
        }
            break;
        case DirectoryPickerTypeMaxPrice:
        {
            maxPriceValue = selectedId;
            [btnMaxPrice setTitle:value forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
