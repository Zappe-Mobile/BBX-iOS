//
//  InvestmentSearchResultsViewController.m
//  BBX
//
//  Created by rkhan-mbook on 29/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "InvestmentSearchResultsViewController.h"
#import "UINavigationController+Extras.h"
#import "LatestListingCell.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "FrontImageDetail.h"
#import "UIImageView+AFNetworking.h"
#import "ProductsDetailViewController.h"
#import "InvestmentSearch.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "RequestManager.h"
#import "InvestmentDetailViewController.h"

@interface InvestmentSearchResultsViewController ()
{
    __weak IBOutlet UITableView * tblView;
    
    NSMutableArray * arrayProductsId;
    NSMutableArray * arrayProductsTitle;
    NSMutableArray * arrayProductsImage;

}
@end

@implementation InvestmentSearchResultsViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Investment Search Results", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];
    
    
    arrayProductsId = [[NSMutableArray alloc]init];
    arrayProductsTitle = [[NSMutableArray alloc]init];
    arrayProductsImage = [[NSMutableArray alloc]init];
    
    
    [self setupData:[DataManager loadInvestmentSearchFromCoreData]];

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


- (void)setupData:(NSArray *)array
{
    for (InvestmentSearch * Object in array) {
        
        [arrayProductsId addObject:Object.selId];
        [arrayProductsTitle addObject:Object.selTitle];
        //[arrayProductsImage addObject:Object.image];
    }
    
    [tblView reloadData];
}


#pragma mark - Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayProductsTitle count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    LatestListingCell *cell = (LatestListingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[LatestListingCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.lblCategory.text = [arrayProductsTitle objectAtIndex:indexPath.row];
    cell.imgCategory.image = [UIImage imageNamed:@"NoImage80.jpg"];
    
//    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrayProductsImage objectAtIndex:indexPath.row]]];
//    [cell.imgCategory setImageWithURL:url placeholderImage:[UIImage imageNamed:@"NoImage80.jpg"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getInvestmentDetailWithUsername:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"] withPassword:[[NSUserDefaults standardUserDefaults]objectForKey:@"PIN"] withInvestmentId:[arrayProductsId objectAtIndex:indexPath.row] withCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] withLanguageId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"] withCompletionBlock:^(BOOL result, id resultObject) {
            
            [SVProgressHUD dismiss];
            if (result) {
                
                NSLog(@"%@",resultObject);
                InvestmentDetailViewController * detailObj = [[InvestmentDetailViewController alloc]initWithDictionary:[resultObject objectForKey:@"MPProductItemDetails"]];
                [self.navigationController pushViewController:detailObj animated:YES];
            }
            else {
                
            }
        }];
        
    }
    else {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection.Please Try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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

@end
