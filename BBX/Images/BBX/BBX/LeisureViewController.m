//
//  LeisureViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "LeisureViewController.h"
#import "UINavigationController+Extras.h"
#import "LeisureListViewController.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "SVProgressHUD.h"

@interface LeisureViewController ()
{
    __weak IBOutlet UIButton * btnAccomodation;
    __weak IBOutlet UIButton * btnExperiences;
    __weak IBOutlet UIButton * btnGiftPackages;
    
}
@end

@implementation LeisureViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Leisure", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];

    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    viewBorder.layer.cornerRadius = 5.0;
    viewBorder.layer.borderWidth = 1.0;
    viewBorder.layer.borderColor = [UIColor colorWithRed:41.0f/255.0f green:149.0f/255.0f blue:229.0f/255.0f alpha:1.0].CGColor;
    
    viewBase.layer.cornerRadius = 5.0;
    
    btnAccomodation.layer.cornerRadius = 3.0;
    btnExperiences.layer.cornerRadius = 3.0;
    btnGiftPackages.layer.cornerRadius = 3.0;

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

- (IBAction)accomodationButtonClicked:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]getAllAccomodationsByCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSLog(@"%@",resultObject);
            [SVProgressHUD dismiss];
            [DataManager storeLifestyleAccomodations:[resultObject objectForKey:@"GiftCardList"] DataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                    LeisureListViewController * objList = [[LeisureListViewController alloc]initWithString:@"Accomodation"];
                    [self.navigationController pushViewController:objList animated:YES];
                }
                else {
                    
                }
            }];
        }
        else {
           [SVProgressHUD dismiss];
        }
    }];
}

- (IBAction)experiencesButtonClicked:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]getAllExperiencesByCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSLog(@"%@",resultObject);
            [SVProgressHUD dismiss];
            [DataManager storeLifestyleExperiences:[resultObject objectForKey:@"GiftCardList"] DataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                    LeisureListViewController * objList = [[LeisureListViewController alloc]initWithString:@"Experiences"];
                    [self.navigationController pushViewController:objList animated:YES];

                }
                else {
                    
                }
            }];
        }
        else {
            [SVProgressHUD dismiss];
        }
    }];
}

- (IBAction)giftPackagesButtonClicked:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]getAllGiftPackagesByCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSLog(@"%@",resultObject);
            [SVProgressHUD dismiss];
            [DataManager storeLifestyleGiftPackages:[resultObject objectForKey:@"GiftCardList"] DataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                    LeisureListViewController * objList = [[LeisureListViewController alloc]initWithString:@"GiftPackages"];
                    [self.navigationController pushViewController:objList animated:YES];

                }
                else {
                    
                }
            }];
        }
        else {
            [SVProgressHUD dismiss];
        }
    }];
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
