//
//  InviteFriendViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "ZPickerView.h"
#import "UIDevice+Extras.h"
#import "SVProgressHUD.h"
#import "LanguageInfo.h"
#import "DataManager.h"
#import "Reachability.h"

@interface InviteFriendViewController ()
{
    UIView * viewEmail;
    UIView * viewSMS;
    
    IBOutlet UISegmentedControl * segCtl;
    IBOutlet UIView * viewBase;
    
    //! Email
    IBOutlet UITextField * txtEmails;
    IBOutlet UITextField * txtSubject;
    IBOutlet UITextView * txtEmailBody;
    IBOutlet UIButton * btnEmailSelectedCountry;
    IBOutlet UIButton * btnEmailSelectedLanguage;
    
    //! SMS
    IBOutlet UITextField * txtNumbers;
    IBOutlet UITextView * txtSMSBody;
    IBOutlet UIButton * btnSMSSelectedCountry;
    IBOutlet UIButton * btnSMSSelectedLanguage;
    
    NSString * countryId;
    NSString * languageId;
    
    LanguageInfo * info;
}
@property (strong, nonatomic) ZPickerView * containerView;
@end

@implementation InviteFriendViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Invite Friend", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];
    
    [self setupFirstView];

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

- (void)setupFirstView
{
    viewEmail = [self getTemplateView:@"InviteByEmailView" for:self];
    [viewEmail setAlpha:0];
    
    CGRect rect = viewEmail.frame;
    rect.origin.x = rect.origin.x;
    rect.origin.y = rect.origin.y;
    [viewEmail setFrame:rect];
    
    [viewBase addSubview:viewEmail];
    
    [UIView beginAnimations:nil context:NULL];
    
    [viewEmail setUserInteractionEnabled:YES];
    
    [UIView setAnimationDuration:.5];
    
    [viewEmail setAlpha:1];
    
    [UIView commitAnimations];
    
    [btnEmailSelectedLanguage setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGENAME"] forState:UIControlStateNormal];
    [btnEmailSelectedCountry setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRYNAME"] forState:UIControlStateNormal];
    
    countryId = [[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"];
    languageId = [[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"];
    

    
}

/**
 *  Setting Up Second View
 */
- (void)setupSecondView
{
    viewSMS = [self getTemplateView:@"InviteBySMSView" for:self];
    [viewSMS setAlpha:0];
    
    CGRect rect = viewSMS.frame;
    rect.origin.x = rect.origin.x;
    rect.origin.y = rect.origin.y;
    [viewSMS setFrame:rect];
    
    [viewBase addSubview:viewSMS];
    
    [UIView beginAnimations:nil context:NULL];
    
    [viewSMS setUserInteractionEnabled:YES];
    
    [UIView setAnimationDuration:.5];
    
    [viewSMS setAlpha:1];
    
    [UIView commitAnimations];
    
    [btnSMSSelectedLanguage setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGENAME"] forState:UIControlStateNormal];
    [btnSMSSelectedCountry setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRYNAME"] forState:UIControlStateNormal];
    
    
    countryId = [[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"];
    languageId = [[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"];
    

    
}


- (void)labelChangeForLanguage
{
    
}

- (IBAction)segmentedControlValueChanged:(id)sender
{
    switch (segCtl.selectedSegmentIndex) {
        case 0:
        {
            [viewSMS removeFromSuperview];
            [self setupFirstView];
        }
            break;
        case 1:
        {
            [viewEmail removeFromSuperview];
            [self setupSecondView];
        }
            break;
        default:
            break;
    }
    
}


- (IBAction)byEmailLanguageSelected:(id)sender
{
    
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:InviteFriendEmailPickerTypeLanguage withManagedObject:info withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];


}


- (IBAction)byEmailCountrySelected:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:InviteFriendEmailPickerTypeCountry withManagedObject:nil withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}


- (IBAction)byEmailSubmit:(id)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]inviteFriendByEmailWithEmails:txtEmails.text withSubject:txtSubject.text withBody:txtEmailBody.text withCompletionBlock:^(BOOL result, id resultObject) {
            
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
}

- (IBAction)bySMSLanguageSelected:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:InviteFriendSMSPickerTypeLanguage withManagedObject:info withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}

- (IBAction)bySMSCountrySelected:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:InviteFriendSMSPickerTypeCountry withManagedObject:nil withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}

- (IBAction)bySMSSubmit:(id)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]inviteFriendBySMSWithNumbers:txtNumbers.text withBody:txtSMSBody.text withCompletionBlock:^(BOOL result, id resultObject) {
            
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
}


- (void)setSelectedValue:(NSString *)value WithSelectedId:(NSString *)selectedId WithPickerType:(DirectoryPickerType)pickerType
{
    switch (pickerType) {
        case InviteFriendEmailPickerTypeCountry:
        {
            countryId = selectedId;
            [btnEmailSelectedCountry setTitle:value forState:UIControlStateNormal];
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:countryId forKey:@"SELECTEDCOUNTRY"];
            [defaults setObject:value forKey:@"SELECTEDCOUNTRYNAME"];
            [defaults synchronize];
            
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            [[RequestManager sharedManager]getLanguageIdByCountryIdWithCountryId:countryId withCompletionBlock:^(BOOL result, id resultObject) {
                
                [SVProgressHUD dismiss];
                if (result) {
                    
                    NSLog(@"%@",resultObject);
                    info = [DataManager getLanguageInfoForLanguageId:[resultObject objectForKey:@"text"]];
                    NSLog(@"%@",info);
                    NSLog(@"%@",[DataManager getLanguageInfoForLanguageId:[resultObject objectForKey:@"text"]]);
                    
                    
                }
                else {
                    
                }
            }];
        }
            break;
        case InviteFriendEmailPickerTypeLanguage:
        {
            languageId = selectedId;
            [btnEmailSelectedLanguage setTitle:value forState:UIControlStateNormal];
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:languageId forKey:@"SELECTEDLANGUAGE"];
            [defaults setObject:value forKey:@"SELECTEDLANGUAGENAME"];
            [defaults synchronize];
            
            
            //[self getNewLanguageLabels];
        }
            break;
        case InviteFriendSMSPickerTypeCountry:
        {
            countryId = selectedId;
            [btnSMSSelectedCountry setTitle:value forState:UIControlStateNormal];
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:countryId forKey:@"SELECTEDCOUNTRY"];
            [defaults setObject:value forKey:@"SELECTEDCOUNTRYNAME"];
            [defaults synchronize];
            
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            [[RequestManager sharedManager]getLanguageIdByCountryIdWithCountryId:countryId withCompletionBlock:^(BOOL result, id resultObject) {
                
                [SVProgressHUD dismiss];
                if (result) {
                    
                    NSLog(@"%@",resultObject);
                    info = [DataManager getLanguageInfoForLanguageId:[resultObject objectForKey:@"text"]];
                    NSLog(@"%@",info);
                    NSLog(@"%@",[DataManager getLanguageInfoForLanguageId:[resultObject objectForKey:@"text"]]);
                    
                    
                }
                else {
                    
                }
            }];
        }
            break;
        case InviteFriendSMSPickerTypeLanguage:
        {
            languageId = selectedId;
            [btnSMSSelectedLanguage setTitle:value forState:UIControlStateNormal];
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:languageId forKey:@"SELECTEDLANGUAGE"];
            [defaults setObject:value forKey:@"SELECTEDLANGUAGENAME"];
            [defaults synchronize];
            
            
            //[self getNewLanguageLabels];
        }
            break;

        default:
            break;
    }
}


# pragma mark - Popup Generic Method

- (UIView *)getTemplateView:(NSString*)template for:(id)s
{
    
    return [self getTemplateView:template for:s atIndex:0];
    
}

- (UIView *)getTemplateView:(NSString*)template for:(id)s atIndex:(int)index
{
    
    BOOL isIpad = ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad);
    
    if(isIpad){
        
        template = [NSString stringWithFormat:@"%@",template];
        
    }else{
        
        template = [NSString stringWithFormat:@"%@",template];
        
    }
    
    NSArray * ViewAry = [[NSBundle mainBundle] loadNibNamed:template owner:s options:nil];
    
    return [ViewAry objectAtIndex:index];
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
