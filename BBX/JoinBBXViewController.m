//
//  JoinBBXViewController.m
//  BBX
//
//  Created by Roman Khan on 05/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "JoinBBXViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "Reachability.h"
#import "SVProgressHUD.h"

@interface JoinBBXViewController ()
{
    __weak IBOutlet UIView * viewBackground;
    __weak IBOutlet UIScrollView * scrollBase;
    
    __weak IBOutlet UITextField * txtCompanyName;
    //__weak IBOutlet UITextField * txtCompanyNumber;
    __weak IBOutlet UITextField * txtBusinessAddress;
    __weak IBOutlet UITextField * txtSuburb;
    __weak IBOutlet UITextField * txtPhone;
    //__weak IBOutlet UITextField * txtMobile;
    __weak IBOutlet UITextField * txtEmail;
    __weak IBOutlet UITextField * txtWebsite;
    __weak IBOutlet UITextField * txtDirector;
    //__weak IBOutlet UITextField * txtDateOfBirth;
    //__weak IBOutlet UITextField * txtDriverLicense;
    //__weak IBOutlet UIButton * btnTypeOfBusiness;
    //__weak IBOutlet UIButton * btnYearsInBusiness;
    //__weak IBOutlet UIButton * btnBBXAmbassdor;
    __weak IBOutlet UITextField * txtComment;
    
    __weak IBOutlet UITextView * txtAgree;
    __weak IBOutlet UIButton * btnAgree;
    __weak IBOutlet UIButton * btnSubmit;
    
    BOOL isAgree;
}

/*
*  @param companyName     Company Name
*  @param businessAddress Business Address
*  @param postCode        Post Code
*  @param phone           Phone
*  @param email           Email
*  @param website         Website
*  @param ownerName       Owner Name
*  @param comments        Comments
*/
@end

@implementation JoinBBXViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Join BBX", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    isAgree = NO;

    scrollBase.contentSize = CGSizeMake(280, 600);
    
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

- (IBAction)btnJoinBBXClicked:(id)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        if (isAgree) {
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            [[RequestManager sharedManager]joinBBXWithCompanyName:txtCompanyName.text withBusinessAddress:txtBusinessAddress.text withPostCodeState:txtSuburb.text withPhone:txtPhone.text withEmail:txtEmail.text withWebsite:txtWebsite.text withOwnerName:txtDirector.text withComments:txtComment.text withCompletionBlock:^(BOOL result, id resultObject) {
                
                [SVProgressHUD dismiss];
                if (result) {
                    
                    NSLog(@"%@",resultObject);
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[resultObject objectForKey:@"text"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                    [alert show];

                }
                else {
                    
                }
            }];

        }
        else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please Agree to Terms and Conditions" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [alert show];
        }
     }
    else {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Internet not available.Please try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];

    }
}

- (IBAction)btnTermsAgreeClicked:(id)sender
{
    if (!isAgree) {
        isAgree = YES;
        [btnAgree setImage:[UIImage imageNamed:@"1check_icon.png"] forState:UIControlStateNormal];
    }
    else {
        isAgree = NO;
        [btnAgree setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateNormal];
    }
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
