//
//  TradingExampleViewController.m
//  BBX
//
//  Created by Roman Khan on 14/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "TradingExampleViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"

@interface TradingExampleViewController ()
{
    __weak IBOutlet UIView * viewBackground;
    __weak IBOutlet UITextView * txtExample;
}
@end

@implementation TradingExampleViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"BBX Trading Example"]]];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

//    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Trading is simple at BBX1. Say the florist wants to buy $1000 worth of restaurant meals.2. The florist presents the restaurant with the florist BBX card.3. The restaurant uses BBX IPOS or Webpos or AutoBroker or Phones BBX for credit   clearance-authorisation.4. BBX credits the restaurant BBX account with $1000 and debits the florist BBX account for $1000.5. The restaurant buys $800 of carpentry from a BBX member.6. The restaurant will be debited $800 and the carpenter is credited with $800.7. The carpenter may then buy from the florist or any BBX memberThe process is simple and the BBX dollars you spend are guaranteed to return to your business."];
//    
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"Helvetica" size:16]
//                  range:NSMakeRange(0, 14)];
//    
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"Helvetica" size:12]
//                  range:NSMakeRange(15, 156)];
//    
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"Helvetica" size:11]
//                  range:NSMakeRange(157, 100)];
//    
//    txtExample.attributedText = hogan;
//    txtExample.textColor = [UIColor whiteColor];


    [[RequestManager sharedManager]getAboutUsTextWithSectionId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] withCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] withLanguageId:@"247" withCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSLog(@"%@",[resultObject objectForKey:@"text"]);
            txtExample.text = [resultObject objectForKey:@"text"];
            txtExample.textColor = [UIColor whiteColor];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    viewBackground = nil;
    txtExample = nil;
}
@end
