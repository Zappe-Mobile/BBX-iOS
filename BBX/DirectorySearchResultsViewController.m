//
//  DirectorySearchResultsViewController.m
//  BBX
//
//  Created by Admin's on 03/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "DirectorySearchResultsViewController.h"
#import "UINavigationController+Extras.h"
#import "DataManager.h"
#import "ProductsPerCategoryCell.h"
#import "UIImageView+AFNetworking.h"
#import "Directory.h"
#import "SVProgressHUD.h"
#import "RequestManager.h"
#import "ProductsDetailViewController.h"

@interface DirectorySearchResultsViewController ()
{
    IBOutlet UITableView * tblDirectory;
    
    NSMutableArray * arrayDirectoryResultsDescription;
    NSMutableArray * arrayDirectoryResultsId;
    NSMutableArray * arrayDirectoryResultsCompany;
    NSMutableArray * arrayDirectoryResultsContactPerson;
    NSMutableArray * arrayDirectoryResultsImages;
    NSMutableArray * arrayDirectoryResultsPrcId;
    
}
@end

@implementation DirectorySearchResultsViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Search BBX Directory", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    arrayDirectoryResultsDescription = [[NSMutableArray alloc]init];
    arrayDirectoryResultsId = [[NSMutableArray alloc]init];
    arrayDirectoryResultsCompany = [[NSMutableArray alloc]init];
    arrayDirectoryResultsContactPerson = [[NSMutableArray alloc]init];
    arrayDirectoryResultsImages = [[NSMutableArray alloc]init];
    arrayDirectoryResultsPrcId = [[NSMutableArray alloc]init];
    
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    for (Directory * Object in [DataManager loadAllDirectoryResultsFromCoreData]) {
        
        [arrayDirectoryResultsDescription addObject:Object.directoryText];
        [arrayDirectoryResultsId addObject:Object.directoryId];
        [arrayDirectoryResultsCompany addObject:Object.directoryCompany];
        [arrayDirectoryResultsContactPerson addObject:Object.directoryContactPerson];
        [arrayDirectoryResultsImages addObject:Object.directoryPrcImage];
        [arrayDirectoryResultsPrcId addObject:Object.directoryPrcId];
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
    return [arrayDirectoryResultsId count];
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
    
    
    cell.lblCategory.text = [arrayDirectoryResultsCompany objectAtIndex:indexPath.row];
    
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrayDirectoryResultsImages objectAtIndex:indexPath.row]]];
    [cell.imgCategory setImageWithURL:url placeholderImage:[UIImage imageNamed:@"NoImage80.jpg"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]getDirectorySearchDetailWithDirectoryId:[arrayDirectoryResultsId objectAtIndex:indexPath.row] withUsername:@"" withPassword:@"" withCompletionBlock:^(BOOL result, id resultObject) {
        
        [SVProgressHUD dismiss];
        if (result) {
            
            NSLog(@"%@",resultObject);
        }
        else {
            
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
    arrayDirectoryResultsDescription = nil;
    arrayDirectoryResultsId = nil;
    arrayDirectoryResultsCompany = nil;
    arrayDirectoryResultsContactPerson = nil;
    arrayDirectoryResultsImages = nil;

}

@end
