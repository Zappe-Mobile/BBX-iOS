//
//  ServicesViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ServicesViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "ProductCategory.h"
#import "WinesCategoryCell.h"
#import "SVProgressHUD.h"

@interface ServicesViewController ()
{
    __weak IBOutlet UIButton * accomodationButton;
    __weak IBOutlet UIButton * hotelButton;
    __weak IBOutlet UIButton * restaurantButton;
    __weak IBOutlet UIButton * petrolStationButton;
    __weak IBOutlet UIButton * carServiceButton;
    
    __weak IBOutlet UITableView * tblView;
    
    NSMutableArray * arrayProductId;
    NSMutableArray * arrayProductName;
}
@end

@implementation ServicesViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"BBX Services"]]];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    //self.navigationItem.rightBarButtonItem = [self setRightBarButton];
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    arrayProductId = [[NSMutableArray alloc]init];
    arrayProductName = [[NSMutableArray alloc]init];
    
    viewBorder.layer.cornerRadius = 5.0;
    viewBorder.layer.borderWidth = 1.0;
    viewBorder.layer.borderColor = [UIColor colorWithRed:41.0f/255.0f green:149.0f/255.0f blue:229.0f/255.0f alpha:1.0].CGColor;
    
    viewBase.layer.cornerRadius = 5.0;
    
    accomodationButton.layer.cornerRadius = 5.0;
    hotelButton.layer.cornerRadius = 5.0;
    restaurantButton.layer.cornerRadius = 5.0;
    petrolStationButton.layer.cornerRadius = 5.0;
    carServiceButton.layer.cornerRadius = 5.0;
    
    
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]getProductCategoryByCountryId:@"5" WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            [SVProgressHUD dismiss];
            [DataManager storeProductCategories:[resultObject objectForKey:@"ActiveSicCodes"] DataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                    [self setData:[DataManager loadAllProductCategoriesFromCoreData]];
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
    return [arrayProductId count];
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
    
    cell.lblCategory.text = [arrayProductName objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setData:(NSArray *)dataArray
{
    for (ProductCategory * Object in dataArray) {
            
            [arrayProductId addObject:Object.categoryId];
            [arrayProductName addObject:Object.categoryName];
    }
    
    [tblView reloadData];
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
