//
//  AccountManagerViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "AccountManagerViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "SVProgressHUD.h"

@interface AccountManagerViewController ()
{
    __weak IBOutlet UITextField * txtINeed;
    __weak IBOutlet UITextField * txtHowOften;
    __weak IBOutlet UITextField * txtInquiryText;
    __weak IBOutlet UITextField * txtPoSupName;
    __weak IBOutlet UITextField * txtPoSupAddress;
    __weak IBOutlet UITextField * txtPoSupPhone;
}
@end

@implementation AccountManagerViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Account Manager", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];

    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

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

- (IBAction)submitButtonClicked:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]contactYourAccountManagerWithUsername:@"" withPassword:@"" withINeed:txtINeed.text withHowOften:txtHowOften.text withInquiryText:txtInquiryText.text withPoSupName:txtPoSupName.text withPoSupAddress:txtPoSupAddress.text withPoSupPhone:txtPoSupPhone.text withLanguageId:@"" withCountryId:@"" withCompletionBlock:^(BOOL result, id resultObject) {
        
        [SVProgressHUD dismiss];
        if (result) {
            
            NSLog(@"%@",resultObject);
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[resultObject objectForKey:@"text"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            
        }
    }];
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
