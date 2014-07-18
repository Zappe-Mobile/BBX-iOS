//
//  MarketPlaceViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "MarketPlaceViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "MarketPlaceCategories.h"
#import "MarketPlaceProductsViewController.h"
#import "BBXFrameConstants.h"
#import "AboutView.h"
#import "MarketView.h"
#import "MarketPlaceCategoryCell.h"
#import "SVProgressHUD.h"
#import "MarketPlaceLatestProductsViewController.h"
#import "CurrentMemberBuyHistoryViewController.h"
#import "CurrentMemberSellHistoryViewController.h"
#import "MarketPlaceSearchViewController.h"
#import "BBXStringConstants.h"
#import "UIImage+Blur.h"
#import "UIImageView+LBBlurredImage.h"
#import "MarketPlaceCollectionCell.h"
#import "Reachability.h"
#import "MarketPlaceFrontImage.h"
#import "UIImageView+AFNetworking.h"
#import "MarketPlaceImageLinkViewController.h"


@interface MarketPlaceViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIImageView * imgBackground;
    __weak IBOutlet UISearchBar * searchMarket;
    __weak IBOutlet UICollectionView * categoryCollectionView;
    UICollectionViewFlowLayout * flowLayout;
    
    __weak IBOutlet UIImageView * imageFrontOne;
    __weak IBOutlet UIImageView * imageFrontTwo;
    __weak IBOutlet UIImageView * imageFrontThree;
    __weak IBOutlet UIImageView * imageFrontFour;
    
    NSMutableArray * arrayCategoryId;
    NSMutableArray * arrayCategoryName;
    
    AboutView * aboutUsView;
    MarketView * marketView;
    
    
    NSMutableArray * arrayFrontImageLink;
    
    UITapGestureRecognizer * tapGestureImageOne;
    UITapGestureRecognizer * tapGestureImageTwo;
    UITapGestureRecognizer * tapGestureImageThree;
    UITapGestureRecognizer * tapGestureImageFour;
    
}
@end

@implementation MarketPlaceViewController

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
    
    arrayFrontImageLink = [[NSMutableArray alloc]init];
    
    tapGestureImageOne = [[UITapGestureRecognizer alloc]init];
    tapGestureImageOne.numberOfTapsRequired = 1;
    tapGestureImageOne.delegate = self;
    [tapGestureImageOne addTarget:self action:@selector(tapOnImageOne:)];
    [imageFrontOne addGestureRecognizer:tapGestureImageOne];
    
    tapGestureImageTwo = [[UITapGestureRecognizer alloc]init];
    tapGestureImageTwo.numberOfTapsRequired = 1;
    tapGestureImageTwo.delegate = self;
    [tapGestureImageTwo addTarget:self action:@selector(tapOnImageTwo:)];
    [imageFrontTwo addGestureRecognizer:tapGestureImageTwo];

    tapGestureImageThree = [[UITapGestureRecognizer alloc]init];
    tapGestureImageThree.numberOfTapsRequired = 1;
    tapGestureImageThree.delegate = self;
    [tapGestureImageThree addTarget:self action:@selector(tapOnImageThree:)];
    [imageFrontThree addGestureRecognizer:tapGestureImageThree];

    tapGestureImageFour = [[UITapGestureRecognizer alloc]init];
    tapGestureImageFour.numberOfTapsRequired = 1;
    tapGestureImageFour.delegate = self;
    [tapGestureImageFour addTarget:self action:@selector(tapOnImageFour:)];
    [imageFrontFour addGestureRecognizer:tapGestureImageFour];

 
    
    //! Navigation Bar Setup
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"BBX Marketplace"]]];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    //self.navigationItem.rightBarButtonItem = [self setRightBarButton];
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    
    categoryCollectionView.backgroundColor = [UIColor clearColor];
    categoryCollectionView.delegate = self;
    categoryCollectionView.dataSource = self;
    
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [categoryCollectionView setCollectionViewLayout:flowLayout];
    
    [categoryCollectionView registerNib:[UINib nibWithNibName:@"MarketPlaceCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MarketPlaceCollectionCell"];

    
    arrayCategoryId = [[NSMutableArray alloc]init];
    arrayCategoryName = [[NSMutableArray alloc]init];
    
    
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getAllMarketplaceCategoriesWithCompletionBlock:^(BOOL result, id resultObject) {
        
            if (result) {
            
                [DataManager storeMarketplaceCategories:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                
                    if (success) {
                        [SVProgressHUD dismiss];
                        [self setDataInTable:[DataManager loadAllMarketPlaceCategoriesFromCoreData]];
                        [[RequestManager sharedManager]getMarketPlaceFrontImageWithCompletionBlock:^(BOOL result, id resultObject) {
                            
                            if (result) {
                                NSLog(@"%@",resultObject);
                                [DataManager storeMarketplaceFrontImage:[resultObject objectForKey:@"Table1"] DataBlock:^(BOOL success, NSError *error) {
                                    
                                    if (success) {
                                        
                                        [self setFrontImages:[DataManager loadallMarketplaceFrontImagesFromCoreData]];
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
                        [SVProgressHUD dismiss];
                    }
                }];
            }
            else {
                [SVProgressHUD dismiss];
            }
        }];
    }
    else {
       
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [imgBackground setImageToBlur:[UIImage imageNamed:@"background_iPhone"] blurRadius:20.0 completionBlock:^{
        
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
    if(![marketView isDescendantOfView:self.navigationController.view]) {
        marketView=(MarketView*)[[[NSBundle mainBundle] loadNibNamed:@"MarketView" owner:nil options:nil] objectAtIndex:0];
        marketView.frame = kMarketViewFrame;
        marketView.delegate = self;
        [self.navigationController.view addSubview:marketView];
        
    } else {
        [marketView removeFromSuperview];
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view!=marketView && marketView) {
        [marketView removeFromSuperview];
        
    }
    [searchMarket resignFirstResponder];
}


- (void)setDataInTable:(NSArray *)array
{
    NSLog(@"%@",array);
    
    for (MarketPlaceCategories * Object in array) {
        
        [arrayCategoryId addObject:Object.categoryId];
        [arrayCategoryName addObject:Object.categoryName];
    }
    
    [categoryCollectionView reloadData];
}


#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [arrayCategoryId count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *collectionViewCell = nil;
    
    MarketPlaceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MarketPlaceCollectionCell" forIndexPath:indexPath];
            
    cell.categoryNameLabel.text = [arrayCategoryName objectAtIndex:indexPath.row];
            collectionViewCell = cell;
            
    
    
    return collectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    size = CGSizeMake(110, 40);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {

        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getAllMarketplaceProductsForCategoryId:[arrayCategoryId objectAtIndex:indexPath.row] WithCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] WithPageNumber:@"1" WithPageLimit:@"40" WithCompletionBlock:^(BOOL result, id resultObject) {
        
            if (result) {
            
                NSLog(@"%@",resultObject);
                if ([[resultObject objectForKey:@"SellItem"]isKindOfClass:[NSArray class]]) {
                    //! Type Array
                    [DataManager storeMarketPlaceProductsForCategories:[resultObject objectForKey:@"SellItem"] dataDictionary:nil DataBlock:^(BOOL success, NSError *error) {
                        
                        [SVProgressHUD dismiss];
                        if (success) {
                            
                            MarketPlaceProductsViewController * objMarket = [[MarketPlaceProductsViewController alloc]init];
                            [self.navigationController pushViewController:objMarket animated:YES];
                            
                        }
                        else {
                            
                        }
                    }];

                }
                else {
                    //! Type Dictionary
                    [DataManager storeMarketPlaceProductsForCategories:nil dataDictionary:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                        
                        [SVProgressHUD dismiss];
                        if (success) {
                            
                            MarketPlaceProductsViewController * objMarket = [[MarketPlaceProductsViewController alloc]init];
                            [self.navigationController pushViewController:objMarket animated:YES];
                            
                        }
                        else {
                            
                        }
                    }];

                }
            }
            else {
            
            }
        }];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];

    }
}


- (void)selectedViewControllerWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:kMarketPlaceLatestProductsViewController]) {
        MarketPlaceLatestProductsViewController * objTips = [[MarketPlaceLatestProductsViewController alloc]init];
        [self.navigationController pushViewController:objTips animated:YES];
    }
    else if ([identifier isEqualToString:kCurrentMemberBuyHistoryViewController]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getMarketplaceCurrentMemberBuyHistoryWithUsername:@"" WithPassword:@"" WithMemberId:@"" WithCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] WithPageNumber:@"1" WithPageLimit:@"100" WithCompletionBlock:^(BOOL result, id resultObject) {
            
            if (result) {
                NSLog(@"%@",[resultObject objectForKey:@"SellItem"]);
                [DataManager storeCurrentMemberBuyHistory:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        [SVProgressHUD dismiss];
                        CurrentMemberBuyHistoryViewController * objBuy = [[CurrentMemberBuyHistoryViewController alloc]init];
                        [self.navigationController pushViewController:objBuy animated:YES];

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
    else if ([identifier isEqualToString:kCurrentMemberSellHistoryViewController]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getMarketplaceCurrentMemberSellHistoryWithUsername:@"" WithPassword:@"" WithMemberId:@"" WithCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] WithPageNumber:@"1" WithPageLimit:@"100" WithCompletionBlock:^(BOOL result, id resultObject) {
            
            if (result) {
                NSLog(@"%@",resultObject);
                [DataManager storeCurrentMemberSellHistory:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        [SVProgressHUD dismiss];
                        CurrentMemberSellHistoryViewController * objSell = [[CurrentMemberSellHistoryViewController alloc]init];
                        [self.navigationController pushViewController:objSell animated:YES];

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
    else {
        
        [searchMarket becomeFirstResponder];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchMarket resignFirstResponder];
    
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {

        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]searchMarketplaceWithSearchString:searchBar.text WithCompletionBlock:^(BOOL result, id resultObject) {
        
            if (result) {
                NSLog(@"%@",resultObject);
                [DataManager storeMarketPlaceSearchProducts:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                
                    if (success) {
                        [SVProgressHUD dismiss];
                        MarketPlaceSearchViewController * objSearch = [[MarketPlaceSearchViewController alloc]init];
                        [self.navigationController pushViewController:objSearch animated:YES];

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
    else {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];

    }
}


/**
 *  My Sale Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)mySaleButtonClicked:(id)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {

        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getMarketplaceCurrentMemberSellHistoryWithUsername:@"" WithPassword:@"" WithMemberId:@"" WithCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] WithPageNumber:@"1" WithPageLimit:@"100" WithCompletionBlock:^(BOOL result, id resultObject) {
        
            if (result) {
                NSLog(@"%@",resultObject);
                [DataManager storeCurrentMemberSellHistory:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                
                    if (success) {
                        [SVProgressHUD dismiss];
                        CurrentMemberSellHistoryViewController * objSell = [[CurrentMemberSellHistoryViewController alloc]init];
                        [self.navigationController pushViewController:objSell animated:YES];
                    
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
    else {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];

    }

}

/**
 *  My Buys Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)myBuysButtonClicked:(id)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {

        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getMarketplaceCurrentMemberBuyHistoryWithUsername:@"" WithPassword:@"" WithMemberId:@"" WithCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] WithPageNumber:@"1" WithPageLimit:@"100" WithCompletionBlock:^(BOOL result, id resultObject) {
        
            if (result) {
                NSLog(@"%@",[resultObject objectForKey:@"SellItem"]);
                [DataManager storeCurrentMemberBuyHistory:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                
                    if (success) {
                        [SVProgressHUD dismiss];
                        CurrentMemberBuyHistoryViewController * objBuy = [[CurrentMemberBuyHistoryViewController alloc]init];
                        [self.navigationController pushViewController:objBuy animated:YES];
                    
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
    else {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];

    }

}

/**
 *  Latest Listing Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)latestListingButtonClicked:(id)sender
{
    MarketPlaceLatestProductsViewController * objTips = [[MarketPlaceLatestProductsViewController alloc]init];
    [self.navigationController pushViewController:objTips animated:YES];

}

/**
 *  Start Selling Functionality
 *
 *  @param sender Button Object
 */
- (IBAction)startSellingButtonClicked:(id)sender
{
    //! Yet to be Implemented
}

- (void)labelChangeForLanguage
{
    NSString * strValue = [NSString stringWithFormat:@"%@-VALUE",[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDLANGUAGE"]];
    
    NSMutableArray * arrayKey = [[[DataManager sharedManager]dictData]objectForKey:@"KEY"];
    NSMutableArray * arrayValue = [[[DataManager sharedManager]dictData]objectForKey:strValue];
    
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"BBX Marketplace"]]];
}


- (void)setFrontImages:(NSArray *)array
{
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"imageOrder" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
    
    for (MarketPlaceFrontImage * Object in sortedArray) {
        
        [arrayFrontImageLink addObject:Object.imageLink];
    }
    
    NSLog(@"%@",arrayFrontImageLink);
    
    [imageFrontOne setImageWithURL:[NSURL URLWithString:[arrayFrontImageLink objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"NoImage80.jpg"]];
    
    [imageFrontTwo setImageWithURL:[NSURL URLWithString:[arrayFrontImageLink objectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"NoImage80.jpg"]];

    [imageFrontThree setImageWithURL:[NSURL URLWithString:[arrayFrontImageLink objectAtIndex:2]] placeholderImage:[UIImage imageNamed:@"NoImage80.jpg"]];

    [imageFrontFour setImageWithURL:[NSURL URLWithString:[arrayFrontImageLink objectAtIndex:3]] placeholderImage:[UIImage imageNamed:@"NoImage80.jpg"]];


}

- (void)tapOnImageOne:(UIGestureRecognizer *)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getMarketplaceDetailForImageLinkOneWithCompletionBlock:^(BOOL result, id resultObject) {
            
            [SVProgressHUD dismiss];
            if (result) {
                
                NSLog(@"%@",resultObject);
                [DataManager storeMarketplaceFrontImageListing:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        
                        MarketPlaceImageLinkViewController * linkObj = [[MarketPlaceImageLinkViewController alloc]init];
                        [self.navigationController pushViewController:linkObj animated:YES];
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
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];

    }
}

- (void)tapOnImageTwo:(UIGestureRecognizer *)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getMarketplaceDetailForImageLinkTwoWithCompletionBlock:^(BOOL result, id resultObject) {
            
            [SVProgressHUD dismiss];
            if (result) {
                
                [DataManager storeMarketplaceFrontImageListing:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        
                        MarketPlaceImageLinkViewController * linkObj = [[MarketPlaceImageLinkViewController alloc]init];
                        [self.navigationController pushViewController:linkObj animated:YES];

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
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];
        
 
    }
}

- (void)tapOnImageThree:(UIGestureRecognizer *)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getMarketplaceDetailForImageLinkThreeWithCompletionBlock:^(BOOL result, id resultObject) {
            
            [SVProgressHUD dismiss];
            if (result) {
                
                [DataManager storeMarketplaceFrontImageListing:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        
                        MarketPlaceImageLinkViewController * linkObj = [[MarketPlaceImageLinkViewController alloc]init];
                        [self.navigationController pushViewController:linkObj animated:YES];

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
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];

    }
}

- (void)tapOnImageFour:(UIGestureRecognizer *)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]getMarketplaceDetailForImageLinkFourWithCompletionBlock:^(BOOL result, id resultObject) {
            
            [SVProgressHUD dismiss];
            if (result) {
                
                [DataManager storeMarketplaceFrontImageListing:[resultObject objectForKey:@"SellItem"] DataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        
                        MarketPlaceImageLinkViewController * linkObj = [[MarketPlaceImageLinkViewController alloc]init];
                        [self.navigationController pushViewController:linkObj animated:YES];

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
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];

    }
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
