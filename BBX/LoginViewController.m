//
//  LoginViewController.m
//  BBX
//
//  Created by Roman Khan on 02/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "UINavigationController+Extras.h"
#import "DataManager.h"
#import "SVProgressHUD.h"
#import "RequestManager.h"
#import "Reachability.h"

@interface LoginViewController ()
{
    __weak IBOutlet UIView * viewBackgroud;
    __weak IBOutlet UITextField * txtUsername;
    __weak IBOutlet UITextField * txtPassword;
    __weak IBOutlet UIButton * btnRememberMe;
    
    BOOL isRememberPassword;
}
@end

@implementation LoginViewController

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
    
    viewBackgroud.layer.cornerRadius = 10.0;
    viewBackgroud.layer.borderWidth = 1.0f;
    viewBackgroud.layer.borderColor = [UIColor colorWithRed:41.0f/255.0f green:149.0f/255.0f blue:229.0f/255.0f alpha:1.0].CGColor;
    
    NSString * strValue = [NSString stringWithFormat:@"%@-VALUE",[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSMutableArray * arrayKey = [[[DataManager sharedManager]dictData]objectForKey:@"KEY"];
    NSMutableArray * arrayValue = [[[DataManager sharedManager]dictData]objectForKey:strValue];

    //! Navigation Bar Setup
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"Login"]]];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];
    
    isRememberPassword = NO;
    
    NSString * strEmail = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINEMAIL"];
    NSString * strPassword = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINPASSWORD"];
    
    txtUsername.text = strEmail;
    txtPassword.text = strPassword;
    
    if ([strEmail isEqualToString:@""] && [strPassword isEqualToString:@""]) {
        [btnRememberMe setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateNormal];
        isRememberPassword = NO;
    }
    else {
        [btnRememberMe setImage:[UIImage imageNamed:@"1check_icon.png"] forState:UIControlStateNormal];
        isRememberPassword = YES;
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
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setController:@"0"];
}


- (void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}


- (IBAction)btnLoginClicked:(id)sender
{
    
    if (isRememberPassword) {
        [[NSUserDefaults standardUserDefaults] setObject:txtUsername.text forKey:@"LOGINEMAIL"];
        [[NSUserDefaults standardUserDefaults] setObject:txtPassword.text forKey:@"LOGINPASSWORD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LOGINEMAIL"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LOGINPASSWORD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    if ([txtUsername.text length]!=0 && [txtPassword.text length]!=0) {
        
        if ([[Reachability reachabilityForInternetConnection]isReachable]) {
            
            [SVProgressHUD showWithStatus:@"Processing" maskType:SVProgressHUDMaskTypeBlack];
            [[RequestManager sharedManager]loginUserWithUsername:txtUsername.text WithPin:txtPassword.text WithCompletionBlock:^(BOOL result, id resultObject) {
                
                if (result) {
                    [SVProgressHUD dismiss];
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:txtUsername.text forKey:@"USERNAME"];
                    [defaults setObject:txtPassword.text forKey:@"PIN"];
                    [defaults synchronize];
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setController:@"2"];
                    
                }
                else {
                    [SVProgressHUD dismiss];
                }
                
            }];

        }
        else {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection.Please Try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

        }

    }
    else {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please fill in all the data" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


- (IBAction)btnRememberMeClicked:(id)sender
{
    if (!isRememberPassword) {
        
        [btnRememberMe setImage:[UIImage imageNamed:@"1check_icon.png"] forState:UIControlStateNormal];
        isRememberPassword = YES;
    }
    else {
        [btnRememberMe setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateNormal];
        
        isRememberPassword = NO;
    }
    

}


- (void)labelChangeForLanguage
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    viewBackgroud = nil;
    txtUsername = nil;
    txtPassword = nil;
}
@end
