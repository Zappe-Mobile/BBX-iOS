//
//  SearchBBXDirectoryViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "SearchBBXDirectoryViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "ProductsPerCategoryCell.h"
#import "Directory.h"
#import "UIImageView+AFNetworking.h"
#import "DirectorySearchResultsViewController.h"
#import "SVProgressHUD.h"
#import "ZPickerView.h"
#import "UIDevice+Extras.h"
#import "LanguageInfo.h"

@interface SearchBBXDirectoryViewController () 
{
    IBOutlet UITextField * txtKeyword;
    IBOutlet UIButton * countryButton;
    IBOutlet UIButton * stateButton;
    IBOutlet UIButton * categoryButton;
    IBOutlet UIButton * languageButton;
    IBOutlet UIButton * submitButton;
    
    NSMutableArray * arrayDirectoryResultsDescription;
    NSMutableArray * arrayDirectoryResultsId;
    NSMutableArray * arrayDirectoryResultsCompany;
    NSMutableArray * arrayDirectoryResultsContactPerson;
    NSMutableArray * arrayDirectoryResultsImages;
    
    NSString * countryId;
    NSString * stateId;
    NSString * categoryId;
    NSString * languageId;
    
    LanguageInfo * info;
}
@property (strong, nonatomic) ZPickerView * containerView;
@property (nonatomic, assign) id currentResponder;
@end

@implementation SearchBBXDirectoryViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Search BBX Directory", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    arrayDirectoryResultsDescription = [[NSMutableArray alloc]init];
    arrayDirectoryResultsId = [[NSMutableArray alloc]init];
    arrayDirectoryResultsCompany = [[NSMutableArray alloc]init];
    arrayDirectoryResultsContactPerson = [[NSMutableArray alloc]init];
    arrayDirectoryResultsImages = [[NSMutableArray alloc]init];
    
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    [countryButton setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRYNAME"] forState:UIControlStateNormal];

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


- (IBAction)countryButtonClicked:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:DirectoryPickerTypeCountry withManagedObject:nil withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}

- (IBAction)stateButtonClicked:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:DirectoryPickerTypeState withManagedObject:nil withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}

- (IBAction)categoryButtonClicked:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:DirectoryPickerTypeCategory withManagedObject:nil withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}

- (IBAction)languageButtonClicked:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:DIrectoryPickerTypeSelectedCountry withManagedObject:info withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}

- (IBAction)submitButtonClicked:(id)sender
{
    if ([stateId length]!=0 && [countryId length]!=0 && [languageId length]!=0 && [categoryId length]!=0) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getBBXDirectorySearchResultWithKeyword:txtKeyword.text WithStateId:stateId WithCountryId:countryId WithLanguageId:languageId WithProductCategoryId:categoryId WithCompletionBlock:^(BOOL result, id resultObject) {
            
            [SVProgressHUD dismiss];
            if (result) {
                
                if ([[resultObject objectForKey:@"GiftCardList"] count]> 0) {
                    
                    [DataManager storeDirectorySearchResults:[resultObject objectForKey:@"GiftCardList"] DataBlock:^(BOOL success, NSError *error) {
                        
                        if (success) {
                            
                            DirectorySearchResultsViewController * searchResultsObj = [[DirectorySearchResultsViewController alloc]init];
                            [self.navigationController pushViewController:searchResultsObj animated:YES];
                        }
                        else {
                            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Record Found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [alert show];
                            
                        }
                        
                    }];

                    
                }
                else {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Record Found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];

                }
             }
            else {
                
            }
        }];

    }
    else {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Mesage" message:@"Please fill in all data" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

}


- (void)setSelectedValue:(NSString *)value WithSelectedId:(NSString *)selectedId WithPickerType:(DirectoryPickerType)pickerType
{
    switch (pickerType) {
        case DirectoryPickerTypeCountry:
        {
            countryId = selectedId;
            [countryButton setTitle:value forState:UIControlStateNormal];
            
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            [[RequestManager sharedManager]getStateIdByCountryWithCountryId:countryId WithCompletionBlock:^(BOOL result, id resultObject) {
                
                [SVProgressHUD dismiss];
                if (result) {
                    
                    NSLog(@"%@",resultObject);
                    [DataManager storeStateInfoForCountry:[resultObject objectForKey:@"Table1"] DataBlock:^(BOOL success, NSError *error) {
                        if (success) {
                            
                        }
                        else {
                            
                        }
                        
                    }];
                    
                }
                else {
                    
                }
                
            }];
            
            
            [[RequestManager sharedManager]getLanguageIdByCountryIdWithCountryId:countryId withCompletionBlock:^(BOOL result, id resultObject) {
                
                [SVProgressHUD dismiss];
                if (result) {
                    
                    NSLog(@"%@",resultObject);
                    info = [DataManager getLanguageInfoForLanguageId:[resultObject objectForKey:@"text"]];
                    
                    
                }
                else {
                    
                }
            }];

        }
            break;
         case DirectoryPickerTypeState:
        {
            stateId = selectedId;
            [stateButton setTitle:value forState:UIControlStateNormal];
            
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            [[RequestManager sharedManager]getProductCategoryByCountryId:countryId WithCompletionBlock:^(BOOL result, id resultObject) {
                
                [SVProgressHUD dismiss];
                if (result) {
                    
                    NSLog(@"%@",resultObject);
                    [DataManager storeProductCategories:[resultObject objectForKey:@"ActiveSicCodes"] DataBlock:^(BOOL success, NSError *error) {
                        
                        if (success) {
                            
                        }
                        else {
                            
                        }
                    }];
                    
                }
                else {
                    
                }
            }];
        }
            break;
        case DirectoryPickerTypeCategory:
        {
            categoryId = selectedId;
            [categoryButton setTitle:value forState:UIControlStateNormal];
            
//            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
//            [[RequestManager sharedManager]getActiveLanguageListWithCompletionBlock:^(BOOL result, id resultObject) {
//                
//                if (result) {
//                    
//                    [SVProgressHUD dismiss];
//                    [DataManager storeLanguageData:[resultObject objectForKey:@"Table1"] DataBlock:^(BOOL success, NSError *error) {
//                        
//                        if (success) {
//                            
//                        }
//                        else {
//                            
//                        }
//                    }];
//                }
//                else {
//                    
//                }
//            }];
        }
            break;
        case DirectoryPickerTypeLanguage:
        {
            languageId = selectedId;
            [languageButton setTitle:value forState:UIControlStateNormal];
        }
            break;
        case DIrectoryPickerTypeSelectedCountry:
        {
            languageId = selectedId;
            [languageButton setTitle:value forState:UIControlStateNormal];
            
        }
            break;

        default:
            break;
    }
}


-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

//Implement the below delegate method:

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

//Implement resignOnTap:

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

- (void)labelChangeForLanguage
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    countryButton = nil;
    stateButton = nil;
    categoryButton = nil;
    languageButton = nil;
    submitButton = nil;
}
@end
