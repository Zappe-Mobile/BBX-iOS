//
//  LeisureListViewController.m
//  BBX
//
//  Created by rkhan-mbook on 30/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "LeisureListViewController.h"
#import "UINavigationController+Extras.h"
#import "ProductsPerCategoryCell.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "DataManager.h"
#import "Accomodation.h"
#import "Experiences.h"
#import "GiftPackages.h"
#import "LeisureDetailViewController.h"

@interface LeisureListViewController ()
{
    IBOutlet UITableView * tblView;
    
    NSString * leisureType;
    
    NSMutableArray * arrayLeisureName;
    NSMutableArray * arrayLeisureImage;
    NSMutableArray * arrayLeisureSubHeading;
    NSMutableArray * arrayLeisureDescription;
    NSMutableArray * arrayLeisurePrice;
    NSMutableArray * arrayLeisureAddress;
    NSMutableArray * arrayLeisureCurrency;
}
@end

@implementation LeisureListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithString:(NSString *)lifestyleType
{
    self = [super init];
    if (self) {
        
        leisureType = lifestyleType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //! Navigation Bar Setup
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];

    arrayLeisureName = [[NSMutableArray alloc]init];
    arrayLeisureImage = [[NSMutableArray alloc]init];
    arrayLeisureSubHeading = [[NSMutableArray alloc]init];
    arrayLeisureDescription = [[NSMutableArray alloc]init];
    arrayLeisurePrice = [[NSMutableArray alloc]init];
    arrayLeisureAddress = [[NSMutableArray alloc]init];
    arrayLeisureCurrency = [[NSMutableArray alloc]init];
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    if ([leisureType isEqualToString:@"Accomodation"]) {
        
        self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Accomodation", nil)];
        [self setData:[DataManager loadAllLifestyleAccomodationsFromCoreData] WithType:@"Accomodation"];
    }
    else if ([leisureType isEqualToString:@"Experiences"]) {
        
        self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Experiences", nil)];
        [self setData:[DataManager loadAllLifestyleExperiencesFromCoreData] WithType:@"Experiences"];
    }
    else {
        
        self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Gift Packages", nil)];
        [self setData:[DataManager loadAllLifestyleGiftPackagesFromCoreData] WithType:@"Gift Packages"];
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
    return [arrayLeisureName count];
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
    
    
    cell.lblCategory.text = [arrayLeisureName objectAtIndex:indexPath.row];
    
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arrayLeisureImage objectAtIndex:indexPath.row]]];
    [cell.imgCategory setImageWithURL:url placeholderImage:[UIImage imageNamed:@"NoImage80.jpg"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeisureDetailViewController * leisureDetailObj = [[LeisureDetailViewController alloc]init];
    leisureDetailObj.giftPackageHeading = [arrayLeisureName objectAtIndex:indexPath.row];
    leisureDetailObj.giftPackageSubHeading = [arrayLeisureSubHeading objectAtIndex:indexPath.row];
    leisureDetailObj.giftPackageDescription = [arrayLeisureDescription objectAtIndex:indexPath.row];
    leisureDetailObj.giftPackagePrice = [arrayLeisurePrice objectAtIndex:indexPath.row];
    leisureDetailObj.giftPackageAddress = [arrayLeisureAddress objectAtIndex:indexPath.row];
    leisureDetailObj.giftPackageImage = [arrayLeisureImage objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:leisureDetailObj animated:YES];
}

- (void)setData:(NSArray *)dataArray WithType:(NSString *)type
{
    
    if ([type isEqualToString:@"Accomodation"]) {
        
        for (Accomodation * Object in dataArray) {
            
            NSLog(@"%@",Object);
            
            [arrayLeisureName addObject:Object.giftCardHeading];
            [arrayLeisureImage addObject:Object.imageFirst];
            [arrayLeisureSubHeading addObject:Object.giftCardSubHeading];
            [arrayLeisureDescription addObject:Object.giftCardDetails];
            [arrayLeisurePrice addObject:Object.giftCardAmount];
            [arrayLeisureAddress addObject:Object.giftCardAddress];
        }

    }
    else if ([type isEqualToString:@"Experiences"]) {
        
        for (Experiences * Object in dataArray) {
            
            [arrayLeisureName addObject:Object.giftCardHeading];
            [arrayLeisureImage addObject:Object.imageFirst];
            [arrayLeisureSubHeading addObject:Object.giftCardSubHeading];
            [arrayLeisureDescription addObject:Object.giftCardDetails];
            [arrayLeisurePrice addObject:Object.giftCardAmount];
            [arrayLeisureAddress addObject:Object.giftCardAddress];

        }

    }
    else {
        
        for (GiftPackages * Object in dataArray) {
            
            [arrayLeisureName addObject:Object.giftCardHeading];
            [arrayLeisureImage addObject:Object.imageFirst];
            [arrayLeisureSubHeading addObject:Object.giftCardSubHeading];
            [arrayLeisureDescription addObject:Object.giftCardDetails];
            [arrayLeisurePrice addObject:Object.giftCardAmount];
            [arrayLeisureAddress addObject:Object.giftCardAddress];

        }

      [tblView reloadData];

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
