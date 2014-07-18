//
//  TradingTipsViewController.m
//  BBX
//
//  Created by Roman Khan on 14/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "TradingTipsViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"

@interface TradingTipsViewController ()
{
    __weak IBOutlet UIView * viewBackground;
    __weak IBOutlet UITextView * txtTrading;
}
@end

@implementation TradingTipsViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Trading Tips", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];

    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

//    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Treat a trade client as you would an \"A\" class cash client\n\nDue to the closed community that exists, a good buying experience will lead to a satisfied buyer, which will lead to additional cash referral business!The trade buyer is usually a business owner, just like you As such, a lot of opportunities can be opened within your community.The best marketing your business can create is having the customer actually experience your product/service.Put the shoe on the other foot. How do you like to be treated when you are the buyer?\n\nTrade within the network's trading rules!\n\nLike any community or group where rules exist, there will be 80% of the population who live within the rules/laws and 20% who don't.Do your part by being in the majority and take action against those who are not! (Contact your BBX office for a remedy, don't take it out on the next innocent trader - see Code 1!)\n\nTreat a trade transaction like a normal cash transaction\n\nAs a sellerAlways obtain an authorisation. Deliver your business goods/services as per Code 1. Sell goods and services on full trade (inclusive of GST) and at prevailing prices, as stipulated by the BBXTrading & Pricing Policy (see the latest Trade Directory for details or ask your local office). Trade subject to sensible business practices.As a buyer Obtain quotes, cash and trade, to provide yourself with information, so as to make an intelligent purchasing decision. Feel free to bargain with a seller if you deem the price is too high. Always communicate with your account manager. Goods and services come and go, so first to know will have first opportunity to buy. See also Code 4.\n\nEducate yourself so as to best utilise your trading network!\n\nAttend trade nights, Member functions, education seminars and networking events.A classic example is understanding that most businesses in BBX will derive more business due to its \"closed\" environment.It follows then that you need to focus on spending opportunities rather than selling, for the majority of businesses. This is usually a contradiction with the broader economy\nUnderstand the Cost of doing BBX Business \nThis is called \"Cost of Trade Dollar\" or \"COT\".Trade customers place the same importance as cash customers on things such as service, warranty, reliability, etc.However, when buying, Trade customers buy on COST rather than PRICE.When you earn a trade dollar in your business, what is the cost to earn that extra dollar? That is, what EXTRA costs do you incur, disregarding those existing overheads (rent, wages, insurance, electricity, etc.) that are paid from cashflow regardless of turnover.Example.If you required $100 of business cards, would you prefer 1. pay $100 cash that actually cost you $100 or 2. pay with your own goods or services the value of $100 dollars at retail price ? option 2 the goods may have only cost you $50 too purchase there for giving you a buying discount of $50.00.Do you know the cost of your trade dollar? If not, your local BBX office will help calculate your COT."];
//    
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"Helvetica" size:15]
//                  range:NSMakeRange(0, 24)];
//    
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"Helvetica" size:13]
//                  range:NSMakeRange(40, 156)];
//    
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"Helvetica" size:12]
//                  range:NSMakeRange(157, 1262)];
//    
//    txtTrading.attributedText = hogan;
//    txtTrading.textColor = [UIColor whiteColor];
    
    [[RequestManager sharedManager]getAboutUsTextWithSectionId:@"2" withCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] withLanguageId:@"247" withCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSLog(@"%@",[resultObject objectForKey:@"text"]);
            txtTrading.text = [resultObject objectForKey:@"text"];
            txtTrading.textColor = [UIColor whiteColor];
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
    txtTrading = nil;
}
@end
