//
//  MyAccountViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "MyAccountViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "AccountInfo.h"

@interface MyAccountViewController ()
{
    __weak IBOutlet UIScrollView * scrollBase;
    __weak IBOutlet UILabel * accountManagerEmailLabel;
    __weak IBOutlet UILabel * accountManagerNameLabel;
    __weak IBOutlet UILabel * accountManagerNumberLabel;
    __weak IBOutlet UILabel * availableSpendingLabel;
    __weak IBOutlet UILabel * cashBalanceLabel;
    __weak IBOutlet UILabel * companyNameLabel;
    __weak IBOutlet UILabel * contactNameLabel;
    __weak IBOutlet UILabel * creditLineLabel;
    __weak IBOutlet UILabel * emailLabel;
    __weak IBOutlet UILabel * franchiseLabel;
    __weak IBOutlet UILabel * mailingAddressLabel;
    __weak IBOutlet UILabel * mobileLabel;
    __weak IBOutlet UILabel * phoneLabel;
    __weak IBOutlet UILabel * streetAddressLabel;
    __weak IBOutlet UILabel * tradeBalanceLabel;
    __weak IBOutlet UILabel * tradingNameLabel;
    __weak IBOutlet UILabel * websiteLabel;
    
}
@end

@implementation MyAccountViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"My Account", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    scrollBase.contentSize = CGSizeMake(280, 750);

    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];
    
    
    [[RequestManager sharedManager]getMemberAccountDetailsWithUsername:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"] WithPassword:[[NSUserDefaults standardUserDefaults]objectForKey:@"PIN"] WithLanguageId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"] WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSLog(@"%@",resultObject);
            [DataManager storeAccountInfo:[resultObject objectForKey:@"Table1"] DataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                    [self setAccountInfo:[DataManager loadAccountInfoFromCoreData]];
                }
                else {
                    
                }
            }];
        }
        else {
            
        }
    }];

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

- (void)labelChangeForLanguage
{
    
}

- (void)setAccountInfo:(NSArray *)dataArray
{
    AccountInfo * objInfo = [dataArray objectAtIndex:0];
    
    NSLog(@"%@",objInfo);
    
    accountManagerEmailLabel.text = objInfo.accountManagerEmail;
    accountManagerNameLabel.text = objInfo.accountManagerName;
    accountManagerNumberLabel.text = objInfo.accountManagerNumber;
    availableSpendingLabel.text = objInfo.availableSpending;
    cashBalanceLabel.text = objInfo.cashBalance;
    companyNameLabel.text = objInfo.companyName;
    contactNameLabel.text = objInfo.contactName;
    creditLineLabel.text = objInfo.creditLine;
    emailLabel.text = objInfo.email;
    franchiseLabel.text = objInfo.franchise;
    mailingAddressLabel.text = objInfo.mailingAddress;
    mobileLabel.text = objInfo.mobile;
    phoneLabel.text = objInfo.phone;
    streetAddressLabel.text = objInfo.streetAddress;
    tradeBalanceLabel.text = objInfo.tradeBalance;
    tradingNameLabel.text = objInfo.tradingName;
    websiteLabel.text = objInfo.website;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}
@end
