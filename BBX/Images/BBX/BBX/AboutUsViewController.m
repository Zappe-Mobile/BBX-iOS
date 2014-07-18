//
//  AboutUsViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UINavigationController+Extras.h"
#import "TradingTipsViewController.h"
#import "TradingExampleViewController.h"
#import "TestimonialViewController.h"
#import "AboutView.h"
#import "BBXStringConstants.h"
#import "BBXFrameConstants.h"
#import "RequestManager.h"
#import "DataManager.h"

@interface AboutUsViewController ()
{
    AboutView * aboutUsView;
}
@end

@implementation AboutUsViewController

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
    
    viewBackground.layer.cornerRadius = 5.0;
    
    NSString * strValue = [NSString stringWithFormat:@"%@-VALUE",[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSMutableArray * arrayKey = [[[DataManager sharedManager]dictData]objectForKey:@"KEY"];
    NSMutableArray * arrayValue = [[[DataManager sharedManager]dictData]objectForKey:strValue];
    
    
    //! Navigation Bar Setup
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"About BBX"]]];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    self.navigationItem.rightBarButtonItem = [self setRightBarButton];
    
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

//    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Welcome to BBX\n\n\"BBX MANAGES THE BUYING AND SELLING OF GOODS AND SERVICES ON BEHALF OF ITS MEMBERS IN A CASHLESS ENVIRONMENT, UTILISING THE BBX GLOBAL CASHLESS PAYMENT PLATFORM\"\n\nEstablished in April 1993, BBX is the largest Trade Exchange Network in the world.Currently operational in eight countries with over 15,000 card holders and 250 staff, BBX continues its expansion into the all-important marketplace of the Asia-Pacific region.  BBX is a credit and debit card system that enables businesses to access a variety of goods and services in a less competitive marketplace, offering a range of financial benefits not usually found in traditional markets or offered by other card payment systems.\nBBX International has established master franchises in India, Costa Rica, Taiwan, New Zealand, Australia, Singapore and Malaysia, and heads of agreements are now in place with two other countries.\nBBX’s mission is to deliver a GLOBAL CASHLESS PAYMENT PLATFORM that is fair, equitable and highly profitable to all BBX members, and at all times community and socially responsible.\nUsing a currency known as BBX trade dollars BBX allows member businesses to increase sales, create cost savings, and improve the general financial performance of their business by taking advantage of spare or under-utilised capacities, all of which improve their bottom line profitability.\n\nMichael Touma\nManaging Director\nBBX INTERNATIONAL"];
//
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"Helvetica-Bold" size:14]
//                  range:NSMakeRange(0, 14)];
//    
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"Helvetica" size:13]
//                  range:NSMakeRange(15, 156)];
//    
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"Helvetica" size:12]
//                  range:NSMakeRange(157, 1262)];
//    
//    txtAboutUs.attributedText = hogan;
    txtAboutUs.textColor = [UIColor blackColor];
    
    
    [[RequestManager sharedManager]getAboutUsTextWithSectionId:@"1" withCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] withLanguageId:@"247" withCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSLog(@"%@",[resultObject objectForKey:@"text"]);
            txtAboutUs.text = [resultObject objectForKey:@"text"];
            txtAboutUs.textColor = [UIColor blackColor];
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
    [aboutUsView removeFromSuperview];
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
    if(![aboutUsView isDescendantOfView:self.navigationController.view]) {
        aboutUsView=(AboutView*)[[[NSBundle mainBundle] loadNibNamed:@"AboutView" owner:nil options:nil] objectAtIndex:0];
        aboutUsView.frame = kAboutUsFrame;
        aboutUsView.delegate = self;
        [self.navigationController.view addSubview:aboutUsView];

    } else {
        [aboutUsView removeFromSuperview];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view!=aboutUsView && aboutUsView) {
        [aboutUsView removeFromSuperview];
    }
    
}

- (void)selectedViewControllerWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:kTradingTipsViewController]) {
        TradingTipsViewController * objTips = [[TradingTipsViewController alloc]init];
        [self.navigationController pushViewController:objTips animated:YES];
    }
    else if ([identifier isEqualToString:kTradingExampleViewController]) {
        TradingExampleViewController * objExample = [[TradingExampleViewController alloc]init];
        [self.navigationController pushViewController:objExample animated:YES];
    }
    else {
        TestimonialViewController * objTestimonial = [[TestimonialViewController alloc]init];
        [self.navigationController pushViewController:objTestimonial animated:YES];
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
    aboutUsView = nil;
}
@end
