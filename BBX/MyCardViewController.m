//
//  MyCardViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "MyCardViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "Card.h"

@interface MyCardViewController ()
{
    IBOutlet UIView * viewBackground;
    IBOutlet UIImageView * cardImage;
    IBOutlet UILabel * lblCardNumber;
    IBOutlet UILabel * lblCardExpire;
    IBOutlet UILabel * lblCardName;
}
@end

@implementation MyCardViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"My Card", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    if ([[DataManager loadActiveCardDataFromCoreData]count]>0) {
        
                [self setUpDataforCard:[DataManager loadActiveCardDataFromCoreData]];
    }
    else {
        
        if ([[Reachability reachabilityForInternetConnection]isReachable]) {
            
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            [[RequestManager sharedManager]getCurrentMemberAccountCardDetailsWithUsername:@"" withPassword:@"" withLanguageId:@"" withCompletionBlock:^(BOOL result, id resultObject) {
                
                [SVProgressHUD dismiss];
                if (result) {
                    
                    NSLog(@"%@",resultObject);
                    [DataManager storeCardData:[resultObject objectForKey:@"CardItems"] DataBlock:^(BOOL success, NSError *error) {
                        
                        if (success) {
                            
                                    [self setUpDataforCard:[DataManager loadActiveCardDataFromCoreData]];
                        }
                        else {
                            
                        }
                    }];
                }
                else {
                    
                }
            }];
            
        }
        else {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection.Please try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }


    
    
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];
    
//    cardImage.transform = CGAffineTransformRotate(cardImage.transform, -M_PI_2);
//    //lblCardNumber.transform = CGAffineTransformRotate(lblCardNumber.transform, M_2_PI);
//    [lblCardNumber setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];

    viewBackground.transform = CGAffineTransformMakeRotation(-M_PI/2);

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

- (void)setUpDataforCard:(NSArray *)cardData
{
    NSLog(@"%@",cardData);
    
    for (Card * Object in cardData) {
        
        NSLog(@"%@",Object.cardName);
        NSLog(@"%@",Object.cardNumber);
        NSLog(@"%@",Object.cardExpire);
        NSLog(@"%@",Object.cardType);
        
        
        lblCardNumber.text = Object.cardNumber;
        lblCardName.text = Object.cardName;
        lblCardExpire.text = Object.cardExpire;
        
        if ([Object.cardType isEqualToString:@"Bronze"]) {
            
            cardImage.image = [UIImage imageNamed:@"bbxcard_bronze.png"];
            lblCardNumber.textColor = [UIColor whiteColor];
            lblCardName.textColor = [UIColor whiteColor];
            lblCardExpire.textColor = [UIColor whiteColor];

        }
        else if ([Object.cardType isEqualToString:@"Black"]) {
            
            cardImage.image = [UIImage imageNamed:@"bbxcard_black.png"];
            lblCardNumber.textColor = [UIColor whiteColor];
            lblCardName.textColor = [UIColor whiteColor];
            lblCardExpire.textColor = [UIColor whiteColor];

        }
        else if ([Object.cardType isEqualToString:@"Silver"]) {
            
            cardImage.image = [UIImage imageNamed:@"bbxcard_silver.png"];
            lblCardNumber.textColor = [UIColor blackColor];
            lblCardName.textColor = [UIColor blackColor];
            lblCardExpire.textColor = [UIColor blackColor];

        }
        else if ([Object.cardType isEqualToString:@"Golden"]) {
            
            cardImage.image = [UIImage imageNamed:@"bbxcard_gold.png"];
            lblCardNumber.textColor = [UIColor blackColor];
            lblCardName.textColor = [UIColor blackColor];
            lblCardExpire.textColor = [UIColor blackColor];

        }
        else if ([Object.cardType isEqualToString:@"White"]) {
            
            cardImage.image = [UIImage imageNamed:@"bbxcard_white.png"];
            lblCardNumber.textColor = [UIColor blackColor];
            lblCardName.textColor = [UIColor blackColor];
            lblCardExpire.textColor = [UIColor blackColor];

        }
        else if ([Object.cardType isEqualToString:@"Platinum"]) {
            
            cardImage.image = [UIImage imageNamed:@"bbxcard_platinum.png"];
            lblCardNumber.textColor = [UIColor whiteColor];
            lblCardName.textColor = [UIColor whiteColor];
            lblCardExpire.textColor = [UIColor whiteColor];

        }

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
