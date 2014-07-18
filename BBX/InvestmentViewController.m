//
//  InvestmentViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "InvestmentViewController.h"
#import "UINavigationController+Extras.h"
#import "Reachability.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "InvestmentCategory.h"
#import "WinesCategoryCell.h"
#import "SVProgressHUD.h"
#import "InvestmentDetailViewController.h"
#import "InvestmentSearchViewController.h"

@interface InvestmentViewController ()
{
    IBOutlet UITableView * tblView;
    
    NSMutableArray * arrayCategoryId;
    NSMutableArray * arrayCategoryName;
}
@end

@implementation InvestmentViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Investment", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    
    arrayCategoryId = [[NSMutableArray alloc]init];
    arrayCategoryName = [[NSMutableArray alloc]init];
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getInvestmentAllCategoryWithCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] withLanguageId:@"247" withCompletionBlock:^(BOOL result, id resultObject) {
            
            [SVProgressHUD dismiss];
            if (result) {
                
                NSLog(@"%@",resultObject);
                [DataManager storeInvestmentData:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        
                        [self setCategoryData:[DataManager loadAllInvestmentCategoryDataFromCoreData]];
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
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection.Please Try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

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


#pragma mark - Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    return [arrayCategoryName count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    WinesCategoryCell *cell = (WinesCategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[WinesCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier] ;
        
    }
    
    cell.lblCategory.text = [arrayCategoryName objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getInvestmentDetailWithUsername:[[NSUserDefaults standardUserDefaults]objectForKey:@"USERNAME"] withPassword:[[NSUserDefaults standardUserDefaults]objectForKey:@"PIN"] withInvestmentId:[arrayCategoryId objectAtIndex:indexPath.row] withCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] withLanguageId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"] withCompletionBlock:^(BOOL result, id resultObject) {
            
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


- (void)setCategoryData:(NSArray *)videoArray
{
    for (InvestmentCategory * Object in videoArray) {
        
        [arrayCategoryId addObject:Object.categoryId];
        [arrayCategoryName addObject:Object.categoryText];
    }
    
    
    [tblView reloadData];
}

- (void)labelChangeForLanguage
{
    
}


- (IBAction)investmentSearchClicked:(id)sender
{
    InvestmentSearchViewController * searchObj = [[InvestmentSearchViewController alloc]init];
    [self.navigationController pushViewController:searchObj animated:YES];
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
