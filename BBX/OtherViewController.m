//
//  OtherViewController.m
//  BBX
//
//  Created by rkhan-mbook on 19/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "OtherViewController.h"
#import "SearchBBXDirectoryViewController.h"
#import "ZPickerView.h"
#import "SVProgressHUD.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "LanguageInfo.h"
#import "Labels.h"
#import "UINavigationController+Extras.h"
#import "UIDevice+Extras.h"
#import "AppDelegate.h"

@interface OtherViewController () 
{
    __weak IBOutlet UILabel * selectCountryLabel;
    __weak IBOutlet UILabel * selectLanguageLabel;
    __weak IBOutlet UIButton * selectedCountryButton;
    __weak IBOutlet UIButton * selectedLangaugeButton;
    
    NSString * countryId;
    NSString * languageId;
    
    LanguageInfo * info;

}
@property (strong, nonatomic) ZPickerView * containerView;
@end

@implementation OtherViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Settings", nil)];

    
    [selectedLangaugeButton setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGENAME"] forState:UIControlStateNormal];
    [selectedCountryButton setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRYNAME"] forState:UIControlStateNormal];
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

}

- (IBAction)selectCountryButtonClicked:(id)sender
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

- (IBAction)selectLanguageButtonClicked:(id)sender
{
    NSLog(@"%@",info);
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    info = [DataManager getLanguageInfoForLanguageId:[[NSUserDefaults standardUserDefaults]objectForKey:@"LANGSELECTED"]];
    [_containerView loadDataForPickerType:DIrectoryPickerTypeSelectedCountry withManagedObject:info withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}

- (IBAction)logoutButtonClicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"USERNAME"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PIN"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setController:@"1"];

}

- (void)setSelectedValue:(NSString *)value WithSelectedId:(NSString *)selectedId WithPickerType:(DirectoryPickerType)pickerType
{
    switch (pickerType) {
        case DirectoryPickerTypeCountry:
        {
            countryId = selectedId;
            [selectedCountryButton setTitle:value forState:UIControlStateNormal];
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:countryId forKey:@"SELECTEDCOUNTRY"];
            [defaults setObject:value forKey:@"SELECTEDCOUNTRYNAME"];
            [defaults synchronize];

            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            [[RequestManager sharedManager]getLanguageIdByCountryIdWithCountryId:countryId withCompletionBlock:^(BOOL result, id resultObject) {
                
                [SVProgressHUD dismiss];
                if (result) {
                    
                    NSLog(@"%@",resultObject);
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:[resultObject objectForKey:@"text"] forKey:@"LANGSELECTED"];
                    [defaults synchronize];
                    //info = [DataManager getLanguageInfoForLanguageId:[resultObject objectForKey:@"text"]];
                    NSLog(@"%@",info);
                    NSLog(@"%@",[DataManager getLanguageInfoForLanguageId:[resultObject objectForKey:@"text"]]);
                    
                    
                }
                else {
                    
                }
            }];
        }
            break;
        case DIrectoryPickerTypeSelectedCountry:
        {
            languageId = selectedId;
            [selectedLangaugeButton setTitle:value forState:UIControlStateNormal];
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:languageId forKey:@"SELECTEDLANGUAGE"];
            [defaults setObject:value forKey:@"SELECTEDLANGUAGENAME"];
            [defaults synchronize];

            
            [self getNewLanguageLabels];
        }
            break;
        default:
            break;
    }
}


- (void)labelChangeForLanguage
{
    
}


- (void)getNewLanguageLabels
{
    [[RequestManager sharedManager]getLabelsByLanguageId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"] withCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            [DataManager storeLabelData:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                    [self storeLabelData:[DataManager loadAllLabelDataFromCoreData]];
                    
                }
                else {
                    
                }
            }];
        }
        else {
            
        }
    }];

}

- (void)storeLabelData:(NSArray *)dataArray
{
    NSMutableArray * arrayKey = [[NSMutableArray alloc]init];
    NSMutableArray * arrayValue = [[NSMutableArray alloc]init];
    
    for (Labels * Object in dataArray) {
        
        [arrayKey addObject:Object.keyText];
        [arrayValue addObject:Object.valueText];
    }
    
    NSString * strValue = [NSString stringWithFormat:@"%@-VALUE",[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSLog(@"%@",arrayKey);
    
    
    [[DataManager sharedManager].dictData setObject:arrayKey forKey:@"KEY"];
    [[DataManager sharedManager].dictData setObject:arrayValue forKey:strValue];
    
    
    NSLog(@"%@",[[DataManager sharedManager]dictData]);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LANGUAGECHANGE" object:nil];

    
    //[self labelChangeForLanguage];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
