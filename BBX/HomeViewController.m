//
//  HomeViewController.m
//  BBX
//
//  Created by Roman Khan on 02/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "HomeViewController.h"
#import "AboutUsViewController.h"
#import "ServicesViewController.h"
#import "ContactUsViewController.h"
#import "EnquiryViewController.h"
#import "HowBBXWorksViewController.h"
#import "EventsViewController.h"
#import "TradeViewController.h"
#import "RewardsViewController.h"
#import "JoinBBXViewController.h"
#import "AppDelegate.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "Labels.h"

@interface HomeViewController ()
{
    __weak IBOutlet UILabel * lblLogin;
    __weak IBOutlet UILabel * lblAbout;
    __weak IBOutlet UILabel * lblServices;
    __weak IBOutlet UILabel * lblContact;
    __weak IBOutlet UILabel * lblInquiry;
    __weak IBOutlet UILabel * lblHowBBXWorks;
    __weak IBOutlet UILabel * lblEvents;
    __weak IBOutlet UILabel * lblTrade;
    __weak IBOutlet UILabel * lblRewards;
    
}

@end

@implementation HomeViewController

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
    
    
    if ([arrayKey count] > 0 && [arrayValue count]>0) {
        
        [self labelChangeForLanguage];
    }
    else {
        
        //! Navigation Bar Setup
        self.navigationItem.titleView = [self.navigationController setTitleView:@"Login"];
        
        //! Home Screen Icons Localized Text
        lblLogin.text = NSLocalizedString(@"Login", nil);
        lblAbout.text = NSLocalizedString(@"About Us", nil);
        lblServices.text = NSLocalizedString(@"Services", nil);
        lblContact.text = NSLocalizedString(@"Contact", nil);
        lblInquiry.text = NSLocalizedString(@"Inquiry", nil);
        lblHowBBXWorks.text = NSLocalizedString(@"How BBX Works", nil);
        lblEvents.text = NSLocalizedString(@"Events", nil);
        lblTrade.text = NSLocalizedString(@"Trade", nil);
        lblRewards.text = NSLocalizedString(@"Rewards", nil);

    }
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    
    
    [[RequestManager sharedManager]getActiveCountryListWithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            [DataManager storeCountryData:[resultObject objectForKey:@"Table1"] DataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                    [[RequestManager sharedManager]getActiveLanguageListWithCompletionBlock:^(BOOL result, id resultObject) {
                        
                        if (result) {
                            
                            [DataManager storeLanguageData:[resultObject objectForKey:@"Table1"] DataBlock:^(BOOL success, NSError *error) {
                                
                                if (success) {
                                    
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
                    
                }
            }];
        }
        else {
            
        }
    }];
    
    
    [[RequestManager sharedManager]getLabelsByLanguageId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"] withCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            [DataManager storeLabelData:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                    NSLog(@"%@",[resultObject objectForKey:@"SellItem"]);
                    [self storeLabelData:[DataManager loadAllLabelDataFromCoreData]];
                }
                else {
                    
                }
            }];
        }
        else {
            
        }
    }];
    
    
}

/**
 *  Login Functionality
 *
 *  @param sender sender object
 */
- (IBAction)btnLoginClicked:(id)sender
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setController:@"1"];
}

/**
 *  Navigate to AboutUs Page
 *
 *  @param sender sender object
 */
- (IBAction)btnAboutUsClicked:(id)sender
{
    AboutUsViewController * objAbout = [[AboutUsViewController alloc]init];
    [self.navigationController pushViewController:objAbout animated:YES];
}

/**
 *  Navigate to Services Page
 *
 *  @param sender sender object
 */
- (IBAction)btnServicesClicked:(id)sender
{
    ServicesViewController * objServices = [[ServicesViewController alloc]init];
    [self.navigationController pushViewController:objServices animated:YES];
}

/**
 *  Navigate to Contact Us Page
 *
 *  @param sender sender object
 */
- (IBAction)btnContactUsClicked:(id)sender
{
    ContactUsViewController * objContact = [[ContactUsViewController alloc]init];
    [self.navigationController pushViewController:objContact animated:YES];
}

/**
 *  Navigate to Enquiry Page
 *
 *  @param sender sender object
 */
- (IBAction)btnInquiryClicked:(id)sender
{
    EnquiryViewController * objEnquiry = [[EnquiryViewController alloc]init];
    [self.navigationController pushViewController:objEnquiry animated:YES];
}

/**
 *  Navigate to How BBX Works Page
 *
 *  @param sender sender object
 */
- (IBAction)btnHowBBXWorks:(id)sender
{
    HowBBXWorksViewController * objHow = [[HowBBXWorksViewController alloc]init];
    [self.navigationController pushViewController:objHow animated:YES];
}

/**
 *  Navigate to Events Page
 *
 *  @param sender sender object
 */
- (IBAction)btnEventsClicked:(id)sender
{
    EventsViewController * objEvents = [[EventsViewController alloc]init];
    [self.navigationController pushViewController:objEvents animated:YES];
}

/**
 *  Navigate to Trade Page
 *
 *  @param sender sender object
 */
- (IBAction)btnTradeClicked:(id)sender
{
    TradeViewController * objTrade = [[TradeViewController alloc]init];
    [self.navigationController pushViewController:objTrade animated:YES];
}

/**
 *  Navigate to Rewards Page
 *
 *  @param sender sender object
 */
- (IBAction)btnRewardsClicked:(id)sender
{
    RewardsViewController * objRewards = [[RewardsViewController alloc]init];
    [self.navigationController pushViewController:objRewards animated:YES];
}

/**
 *  Navigate to Join BBX Screen
 *
 *  @param sender sender object
 */
- (IBAction)btnJoinBBXClicked:(id)sender
{
    JoinBBXViewController * objJoin = [[JoinBBXViewController alloc]init];
    [self.navigationController pushViewController:objJoin animated:YES];
}

- (void)labelChangeForLanguage
{
    NSString * strValue = [NSString stringWithFormat:@"%@-VALUE",[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];

    NSMutableArray * arrayKey = [[[DataManager sharedManager]dictData]objectForKey:@"KEY"];
    NSMutableArray * arrayValue = [[[DataManager sharedManager]dictData]objectForKey:strValue];
    
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"BBX Home"]]];

    lblAbout.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"About BBX"]];
    lblLogin.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Login"]];
    lblServices.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"BBX Services"]];
    lblContact.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Contact"]];
    lblInquiry.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Inquiry"]];
    lblHowBBXWorks.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"How BBX Works"]];
    lblEvents.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"EVENT"]];
    lblTrade.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Trade"]];
    //lblRewards.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Rewards"]];

}

- (void)storeLabelData:(NSArray *)dataArray
{
    NSMutableArray * arrayKey = [[NSMutableArray alloc]init];
    NSMutableArray * arrayValue = [[NSMutableArray alloc]init];
    
    for (Labels * Object in dataArray) {
        
        [arrayKey addObject:Object.keyText];
        [arrayValue addObject:Object.valueText];
    }
    
    NSString * strValue = [NSString stringWithFormat:@"%@-VALUE",[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSLog(@"%@",arrayKey);
    
    
    [[DataManager sharedManager].dictData setObject:arrayKey forKey:@"KEY"];
    [[DataManager sharedManager].dictData setObject:arrayValue forKey:strValue];
    
    
    NSLog(@"%@",[[DataManager sharedManager]dictData]);
    
    [self labelChangeForLanguage];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    lblLogin = nil;
    lblAbout = nil;
    lblServices = nil;
    lblContact = nil;
    lblInquiry = nil;
    lblHowBBXWorks = nil;
    lblEvents = nil;
    lblTrade = nil;
    lblRewards = nil;
}

@end
