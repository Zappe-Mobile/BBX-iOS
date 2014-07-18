//
//  VOLViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "WinesViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "WinesCategory.h"
#import "WinesCategoryCell.h"
#import "WinesListViewController.h"
#import "SVProgressHUD.h"

@interface WinesViewController ()
{
    NSMutableArray * arrayCategoryId;
    NSMutableArray * arrayCategoryName;
    
    IBOutlet UITableView * tblView;
}
@end

@implementation WinesViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"VOL", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    arrayCategoryId = [[NSMutableArray alloc]init];
    arrayCategoryName = [[NSMutableArray alloc]init];
    
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]getAllWinesCategoriesWithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            [DataManager storeWinesCategories:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
               
                if (success) {
                    
                    [SVProgressHUD dismiss];
                    [self setDataInTable:[DataManager loadAllWinesCategoryFromCoreData]];
                }
                else {
                    [SVProgressHUD dismiss];

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

- (void)setDataInTable:(NSArray *)array
{
    NSLog(@"%@",array);
    
    for (WinesCategory * Object in array) {
        
        [arrayCategoryId addObject:Object.categoryId];
        [arrayCategoryName addObject:Object.categoryName];
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
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]getAllWinesByCategory:[arrayCategoryId objectAtIndex:indexPath.row] WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSLog(@"%@",resultObject);
            if ([[resultObject objectForKey:@"SellItem"]isKindOfClass:[NSArray class]]) {
                //! Type Array
                [DataManager storeWinesPerCategories:[resultObject objectForKey:@"SellItem"] dataDictionary:nil DataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        [SVProgressHUD dismiss];
                        
                        WinesListViewController * objWinesList = [[WinesListViewController alloc]init];
                        [self.navigationController pushViewController:objWinesList animated:YES];
                    }
                    else {
                        [SVProgressHUD dismiss];
                    }
                }];

            }
            else {
                //! Type Dictionary
                [DataManager storeWinesPerCategories:nil dataDictionary:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        [SVProgressHUD dismiss];
                        
                        WinesListViewController * objWinesList = [[WinesListViewController alloc]init];
                        [self.navigationController pushViewController:objWinesList animated:YES];
                    }
                    else {
                        [SVProgressHUD dismiss];
                    }
                }];

            }
        }
        else {
            [SVProgressHUD dismiss];
        }
        
    }];
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
