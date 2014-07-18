//
//  TradeViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "TradeViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"

@interface TradeViewController ()
{
    __weak IBOutlet UIView * viewBackground;
    __weak IBOutlet UITextView * txtTrade;
    
}
@end

@implementation TradeViewController

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
    
    
    //! Navigation Bar Setup
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"Trade"]]];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    //self.navigationItem.rightBarButtonItem = [self setRightBarButton];

    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

//    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Welcome to the BBX world of International Cashless Trading...\n\nList, Buy, Sell and navigate International trading opportunities. Your business may want to open or expand in India, Malaysia or Costa Rica, you may have products that are suitable in any BBX operated country. The cost of International expansion or distribution may inhibit many businesses from doing so.\nWell, Via the BBX Cashless Global Payment Platform the opporunities for International Business are simplified and cost effective. Members can now list and search For International opportunities:\n\n\t1. Stock for sale and wanted\n\t2. Business for sale and wanted\n\t3. Franchises for sale and wanted\n\t4. Legal advice in different countries\n\t5. Assistance with Visa and travel\n\t6. International Vacations\n\t7. International Networking\n\t8. International Live Chat Room\n\t9. Invest in Real Estate with your BBX Trade Dollar\n\tDeposit.\n\nThe list of BBX International advantages goes on and on. Enjoy the BBX OPPORTUNITY.\n\nMichael Touma\nManaging Director\nBBX INTERNATIONAL HONG KONG"];
//    
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"Helvetica-Bold" size:14]
//                  range:NSMakeRange(0, 61)];
//    
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"Helvetica" size:13]
//                  range:NSMakeRange(62, 974)];
//    
//    
//    txtTrade.attributedText = hogan;
//    txtTrade.textColor = [UIColor whiteColor];
    
    
    [[RequestManager sharedManager]getAboutUsTextWithSectionId:@"3" withCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] withLanguageId:@"247" withCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSLog(@"%@",[resultObject objectForKey:@"text"]);
            txtTrade.text = [resultObject objectForKey:@"text"];
            txtTrade.textColor = [UIColor blackColor];
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
//    volView=(VOLView*)[[[NSBundle mainBundle] loadNibNamed:@"VOLView" owner:nil options:nil] objectAtIndex:0];
//    volView.frame = CGRectMake(100, 50, 250, 150);
//    [self.navigationController.view addSubview:volView];
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
