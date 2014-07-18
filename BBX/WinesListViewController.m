//
//  WinesListViewController.m
//  BBX
//
//  Created by Admin's on 25/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "WinesListViewController.h"
#import "UINavigationController+Extras.h"
#import "WinesPerCategory.h"
#import "DataManager.h"
#import "ProductsPerCategoryCell.h"
#import "UIImageView+AFNetworking.h"
#import "RequestManager.h"
#import "ProductsDetailViewController.h"
#import "SVProgressHUD.h"
#import "WineDetailViewController.h"

@interface WinesListViewController ()
{
    IBOutlet UITableView * tblView;
    
    NSMutableArray * arrayProductSelId;
    NSMutableArray * arrayProductSelTitle;
    NSMutableArray * arrayProductSelImage;
    
    UIImage * imageDownloaded;

}
@end

@implementation WinesListViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Wines List", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    arrayProductSelId = [[NSMutableArray alloc]init];
    arrayProductSelTitle = [[NSMutableArray alloc]init];
    arrayProductSelImage = [[NSMutableArray alloc]init];
    
    for (WinesPerCategory * Object in [DataManager loadAllWinesPerCategoryFromCoreData]) {
        
        NSLog(@"%@",Object);
        [arrayProductSelId addObject:Object.selId];
        [arrayProductSelTitle addObject:Object.selTitle];
        [arrayProductSelImage addObject:Object.sellImage];
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
    return [arrayProductSelTitle count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    ProductsPerCategoryCell *cell = (ProductsPerCategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[ProductsPerCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    cell.lblCategory.text = [arrayProductSelTitle objectAtIndex:indexPath.row];
    
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrayProductSelImage objectAtIndex:indexPath.row]]];
    [cell.imgCategory setImageWithURL:url placeholderImage:[UIImage imageNamed:@"NoImage80.jpg"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]getWineProductDetailBySelId:[arrayProductSelId objectAtIndex:indexPath.row] WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSLog(@"%@",resultObject);
            [SVProgressHUD dismiss];
            WineDetailViewController * objProduct = [[WineDetailViewController alloc]initWithDictionary:[resultObject objectForKey:@"MPProductItemDetails"]];
            [self.navigationController pushViewController:objProduct animated:YES];
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

@end
