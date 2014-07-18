//
//  EnquiryViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "EnquiryViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "EAMTextView.h"

@interface EnquiryViewController ()
{
    IBOutlet UITextField * txtName;
    IBOutlet UITextField * txtEmailId;
    IBOutlet EAMTextView * txtInquiry;
}
@end

@implementation EnquiryViewController

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
    
    NSString * strValue = [NSString stringWithFormat:@"%@-VALUE",[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSMutableArray * arrayKey = [[[DataManager sharedManager]dictData]objectForKey:@"KEY"];
    NSMutableArray * arrayValue = [[[DataManager sharedManager]dictData]objectForKey:strValue];
    
    txtInquiry.placeholder = @"Message";
    
    //! Navigation Bar Setup
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"Inquiry"]]];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    //self.navigationItem.rightBarButtonItem = [self setRightBarButton];
    
    viewBackground.layer.cornerRadius = 5.0;
    
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


#pragma mark - Set Navigation Bar Right Button
//! Set Right Bar Button
- (UIBarButtonItem *)setRightBarButton
{
    UIButton * btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSettings.frame = CGRectMake(0, 0, 25, 25);
    [btnSettings setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(btnRightBarClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:btnSettings];
    
    return barBtnItem;
}

#pragma mark - Navigation Bar Left Button Selector
//! Method invoked when left bar button clicked
- (void)btnRightBarClicked
{
    
}


- (IBAction)submitButtonClicked:(id)sender
{
    if ([txtInquiry.text length]!= 0) {
        
        if ([[Reachability reachabilityForInternetConnection]isReachable]) {
            
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            //! Enquiry Submit
            [[RequestManager sharedManager]submitEnquiryWithUsername:@"6220430160116252" WithPassword:@"8139" WithEnquiryText:@"Hello" WithCompletionBlock:^(BOOL result, id resultObject) {
                
                [SVProgressHUD dismiss];
                if (result) {
                    
                    NSLog(@"%@",resultObject);
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[resultObject objectForKey:@"text"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    txtName.text = @"";
                    txtEmailId.text = @"";
                    txtInquiry.text = @"";
                    
                }
                else {
                    
                }
            }];

        }
        else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Internet Connection Not Available.Try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

        }

    }
    else {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please fill in All Data" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    

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
    
}
@end
