//
//  AlternateHomeViewController.m
//  BBX
//
//  Created by Roman Khan on 08/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "AlternateHomeViewController.h"
#import "MyCardViewController.h"
#import "BBXTradingPortalViewController.h"
#import "ProcessBBXTransactionViewController.h"
#import "SearchBBXDirectoryViewController.h"
#import "EventsViewController.h"
#import "ContactUsViewController.h"
#import "MarketPlaceViewController.h"
#import "MyAccountViewController.h"
#import "LeisureViewController.h"
#import "DirectoryViewController.h"
#import "WinesViewController.h"
#import "PayFeeViewController.h"
#import "InvestmentViewController.h"
#import "AccountManagerViewController.h"
#include "InviteFriendViewController.h"
#import "UINavigationController+Extras.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "RequestManager.h"
#import "DataManager.h"

@interface AlternateHomeViewController ()
{
    __weak IBOutlet UIScrollView * scrollHome;
    __weak IBOutlet UIPageControl * pageHome;

    __weak IBOutlet UILabel * lblMyCard;
    __weak IBOutlet UILabel * lblTradingPortal;
    __weak IBOutlet UILabel * lblProcessTransaction;
    __weak IBOutlet UILabel * lblSearchBBXDirectory;
    __weak IBOutlet UILabel * lblEvent;
    __weak IBOutlet UILabel * lblContact;
    
    __weak IBOutlet UILabel * lblProcessBBXTransaction;
    __weak IBOutlet UILabel * lblMarketplace;
    __weak IBOutlet UILabel * lblMyAccount;
    __weak IBOutlet UILabel * lblLesiureLifestyle;
    __weak IBOutlet UILabel * lblDirectory;
    __weak IBOutlet UILabel * lblVOL;
    __weak IBOutlet UILabel * lblPayFee;
    __weak IBOutlet UILabel * lblInvestment;
    __weak IBOutlet UILabel * lblRequestManager;
    
    NSArray * viewArray;
}
@end

@implementation AlternateHomeViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"BBX Home"]]];

    //! Home Screen Icons Localized Text
    lblMyCard.text = NSLocalizedString(@"My Card", nil);
    lblTradingPortal.text = NSLocalizedString(@"Trading Portal", nil);
    lblProcessTransaction.text = NSLocalizedString(@"Process Transaction", nil);
    lblSearchBBXDirectory.text = NSLocalizedString(@"Search BBX Directory", nil);
    lblEvent.text = NSLocalizedString(@"Event", nil);
    lblContact.text = NSLocalizedString(@"Contact", nil);
    
//    NSString * strValue = [NSString stringWithFormat:@"%@-VALUE",[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
//    
//    NSMutableArray * arrayKey = [[[DataManager sharedManager]dictData]objectForKey:@"KEY"];
//    NSMutableArray * arrayValue = [[[DataManager sharedManager]dictData]objectForKey:strValue];
    
//    lblMyCard.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"My Card"]];
//    lblTradingPortal.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Trading Portal"]];
//    lblProcessTransaction.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Process Transaction"]];
//    lblSearchBBXDirectory.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Search BBX Directory"]];
//    lblEvent.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Event"]];
//    lblContact.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Contact"]];

    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];
    
    
//    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];


    
    viewArray = [[NSArray alloc] initWithObjects:[self getTemplateView:@"FirstView" for:self],[self getTemplateView:@"SecondView" for:self],nil];
    
    for (int i = 0; i < [viewArray count]; i++) {

        CGRect frame;
        frame.origin.x = scrollHome.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = scrollHome.frame.size;
        
        i == 0 ? [self setupFirstView] : [self setupSecondView];

    }
    
    //Set the content size of our scrollview
    scrollHome.contentSize = CGSizeMake(scrollHome.frame.size.width * [viewArray count], scrollHome.frame.size.height);
    
    
//    [[RequestManager sharedManager]getLabelsByLanguageId:@"247" withCompletionBlock:^(BOOL result, id resultObject) {
//       
//        if (result) {
//            
//            NSLog(@"%@",resultObject);
//        }
//        else {
//            
//        }
//    }];
    
    [self labelChangeForLanguage];
}

/**
 *  Setting Up First View
 */
- (void)setupFirstView
{
    viewFirst = [self getTemplateView:@"FirstView" for:self];
    [viewFirst setAlpha:0];
    
    CGRect rect = viewFirst.frame;
    rect.origin.x = rect.origin.x;
    rect.origin.y = rect.origin.y;
    [viewFirst setFrame:rect];
    
    [scrollHome addSubview:viewFirst];
    
    [UIView beginAnimations:nil context:NULL];
    
    [viewFirst setUserInteractionEnabled:YES];
    
    [UIView setAnimationDuration:.5];
    
    [viewFirst setAlpha:1];
    
    [UIView commitAnimations];

}

/**
 *  Setting Up Second View
 */
- (void)setupSecondView
{
    viewSecond = [self getTemplateView:@"SecondView" for:self];
    [viewSecond setAlpha:0];
    
    CGRect rect = viewSecond.frame;
    rect.origin.x = rect.origin.x+320;
    rect.origin.y = rect.origin.y;
    [viewSecond setFrame:rect];
    
    [scrollHome addSubview:viewSecond];
    
    [UIView beginAnimations:nil context:NULL];
    
    [viewSecond setUserInteractionEnabled:YES];
    
    [UIView setAnimationDuration:.5];
    
    [viewSecond setAlpha:1];
    
    [UIView commitAnimations];

}

/**
 *  MyCard Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnMyCardClicked:(id)sender
{
    
    if ([[DataManager loadActiveCardDataFromCoreData]count]>0) {
        
        MyCardViewController * objCard = [[MyCardViewController alloc]init];
        [self.navigationController pushViewController:objCard animated:YES];

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
                            
                            MyCardViewController * objCard = [[MyCardViewController alloc]init];
                            [self.navigationController pushViewController:objCard animated:YES];
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

}

/**
 *  BBX Trading Portal Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnBBXTradingPortalClicked:(id)sender
{
    BBXTradingPortalViewController * objPortal = [[BBXTradingPortalViewController alloc]init];
    [self.navigationController pushViewController:objPortal animated:YES];
}

/**
 *  Process BBX Transaction Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnProcessBBXTransactionClicked:(id)sender
{
    ProcessBBXTransactionViewController * objTransaction = [[ProcessBBXTransactionViewController alloc]init];
    [self.navigationController pushViewController:objTransaction animated:YES];
}

/**
 *  Search BBX Directory Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnSearchBBXDirectoryClicked:(id)sender
{
    SearchBBXDirectoryViewController * objSearch = [[SearchBBXDirectoryViewController alloc]init];
    [self.navigationController pushViewController:objSearch animated:YES];
}

/**
 *  Event Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnEventClicked:(id)sender
{
    EventsViewController * objEvent = [[EventsViewController alloc]init];
    [self.navigationController pushViewController:objEvent animated:YES];
}

/**
 *  Contact Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnContactClicked:(id)sender
{
    ContactUsViewController * objContact = [[ContactUsViewController alloc]init];
    [self.navigationController pushViewController:objContact animated:YES];
}

/**
 *  Process BBX Transaction Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnProcessTransactionClicked:(id)sender
{
    ProcessBBXTransactionViewController * objTransaction = [[ProcessBBXTransactionViewController alloc]init];
    [self.navigationController pushViewController:objTransaction animated:YES];
}

/**
 *  Marketplace Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnMarketplaceClicked:(id)sender
{
    MarketPlaceViewController * objMarket = [[MarketPlaceViewController alloc]init];
    [self.navigationController pushViewController:objMarket animated:YES];
}

/**
 *  MyAccount Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnMyAccountClicked:(id)sender
{
    MyAccountViewController * objAccount = [[MyAccountViewController alloc]init];
    [self.navigationController pushViewController:objAccount animated:YES];
}

/**
 *  Leisure Lifestyle Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnLeisureLifestyleClicked:(id)sender
{
    LeisureViewController * objLeisure = [[LeisureViewController alloc]init];
    [self.navigationController pushViewController:objLeisure animated:YES];
}

/**
 *  Directory Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnDirectoryClicked:(id)sender
{
    DirectoryViewController * objDirectory = [[DirectoryViewController alloc]init];
    [self.navigationController pushViewController:objDirectory animated:YES];
}

/**
 *  VOL Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnVOLClicked:(id)sender
{
    WinesViewController * objVOL = [[WinesViewController alloc]init];
    [self.navigationController pushViewController:objVOL animated:YES];
}

/**
 *  Pay Fee Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnPayFeeClicked:(id)sender
{
    PayFeeViewController * objFee = [[PayFeeViewController alloc]init];
    [self.navigationController pushViewController:objFee animated:YES];
}

/**
 *  Investment Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnInvestmentClicked:(id)sender
{
    InvestmentViewController * objInvestment = [[InvestmentViewController alloc]init];
    [self.navigationController pushViewController:objInvestment animated:YES];
}

/**
 *  Request Your Account Manager Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)btnRequestAccountManagerClicked:(id)sender
{
    AccountManagerViewController * objManager = [[AccountManagerViewController alloc]init];
    [self.navigationController pushViewController:objManager animated:YES];
}

- (IBAction)btnInviteFriendClicked:(id)sender
{
    InviteFriendViewController * objInvite = [[InviteFriendViewController alloc]init];
    [self.navigationController pushViewController:objInvite animated:YES];
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

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollHome.frame.size.width;
    int page = floor((scrollHome.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageHome.currentPage = page;
}

/**
 *  Setting Labels
 */
- (void)labelChangeForLanguage
{
    NSString * strValue = [NSString stringWithFormat:@"%@-VALUE",[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSMutableArray * arrayKey = [[[DataManager sharedManager]dictData]objectForKey:@"KEY"];
    NSMutableArray * arrayValue = [[[DataManager sharedManager]dictData]objectForKey:strValue];
    
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"BBX Home"]]];
    
    lblMyCard.text = @"My Card";
    lblTradingPortal.text = @"Trading Portal";
    lblProcessTransaction.text = @"Process BBX Transaction";
    lblSearchBBXDirectory.text = [NSString stringWithFormat:@"%@ %@",[arrayValue objectAtIndex:[arrayKey indexOfObject:@"Search"]],[arrayValue objectAtIndex:[arrayKey indexOfObject:@"BBX Directory"]]];
    lblEvent.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"EVENT"]];
    lblContact.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Contact"]];
    
    lblProcessBBXTransaction.text = @"Process BBX Transaction";
    lblMarketplace.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"BBX Marketplace"]];
    lblMyAccount.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Account"]];
    lblLesiureLifestyle.text = @"Leisure Lifestyle";
    lblDirectory.text = [NSString stringWithFormat:@"%@ %@",[arrayValue objectAtIndex:[arrayKey indexOfObject:@"Search"]],[arrayValue objectAtIndex:[arrayKey indexOfObject:@"BBX Directory"]]];
    lblVOL.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"VOL"]];
    lblPayFee.text = @"Pay Fee";
    lblInvestment.text = [arrayValue objectAtIndex:[arrayKey indexOfObject:@"Investment"]];
    lblRequestManager.text = @"Request Your Account Mgr";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    scrollHome = nil;
    pageHome = nil;
    
    lblMyCard = nil;
    lblTradingPortal = nil;
    lblProcessTransaction = nil;
    lblSearchBBXDirectory = nil;
    lblEvent = nil;
    lblContact = nil;
    
    lblProcessBBXTransaction = nil;
    lblMarketplace = nil;
    lblMyAccount = nil;
    lblLesiureLifestyle = nil;
    lblDirectory = nil;
    lblVOL = nil;
    lblPayFee = nil;
    lblInvestment = nil;
    lblRequestManager = nil;

}
@end
