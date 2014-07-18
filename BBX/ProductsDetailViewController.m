//
//  ProductsDetailViewController.m
//  BBX
//
//  Created by Roman Khan on 11/05/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ProductsDetailViewController.h"
#import "UINavigationController+Extras.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+HTML.h"
#import "RequestManager.h"
#import "Reachability.h"
#import "SVProgressHUD.h"

@interface ProductsDetailViewController ()
{
    NSDictionary * dictProduct;
    
    NSString * currency;
    NSString * latestBidAmount;
    NSString * location;
    NSString * selCatId;
    NSString * selDateExpire;
    NSString * selDatePosted;
    NSString * selDescription;
    NSString * selEnteredByMemId;
    NSString * selId;
    NSString * selMemId;
    NSString * selNoOfViews;
    NSString * selPricePerQuantityCash;
    NSString * selPricePerQuantityTrade;
    NSString * selQuantity;
    NSString * selStaIdType;
    NSString * selTitle;
    NSString * sellImage;
    NSString * sellStatus;
    
    __weak IBOutlet UIScrollView * scrollBackground;
    __weak IBOutlet UIImageView * imgProduct;
    __weak IBOutlet UILabel * lblProductName;
    __weak IBOutlet UITextView * txtProductDesc;
    __weak IBOutlet UILabel * lblQuantity;
    __weak IBOutlet UILabel * lblDatePosted;
    __weak IBOutlet UILabel * lblDateExpired;
    __weak IBOutlet UILabel * lblStatus;
    __weak IBOutlet UILabel * lblLocation;
}
@end

@implementation ProductsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        dictProduct = dict;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //! Navigation Bar Setup
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Product Detail", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];


    NSLog(@"%@",dictProduct);
    
    currency = [[dictProduct objectForKey:@"Currency"]objectForKey:@"text"];
    latestBidAmount = [[dictProduct objectForKey:@"LastBidAmount"]objectForKey:@"text"];
    location = [[dictProduct objectForKey:@"Location"]objectForKey:@"text"];
    selCatId = [[dictProduct objectForKey:@"SelCatID"]objectForKey:@"text"];
    selDateExpire = [[dictProduct objectForKey:@"SelDateExpire"]objectForKey:@"text"];
    selDatePosted = [[dictProduct objectForKey:@"SelDatePosted"]objectForKey:@"text"];
    selDescription = [[dictProduct objectForKey:@"SelDis"]objectForKey:@"text"];
    selEnteredByMemId = [[dictProduct objectForKey:@"SelEnteredByMemID"]objectForKey:@"text"];
    selId = [[dictProduct objectForKey:@"SelID"]objectForKey:@"text"];
    selMemId = [[dictProduct objectForKey:@"SelMemID"]objectForKey:@"text"];
    selNoOfViews = [[dictProduct objectForKey:@"SelNoOfViews"]objectForKey:@"text"];
    selPricePerQuantityCash = [[dictProduct objectForKey:@"SelPricePerQuantityCash"]objectForKey:@"text"];
    selPricePerQuantityTrade = [[dictProduct objectForKey:@"SelPricePerQuantityTrade"]objectForKey:@"text"];
    selQuantity = [[dictProduct objectForKey:@"SelQuantity"]objectForKey:@"text"];
    selStaIdType = [[dictProduct objectForKey:@"SelStaIDType"]objectForKey:@"text"];
    selTitle = [[dictProduct objectForKey:@"SelTitle"]objectForKey:@"text"];
    sellImage = [[dictProduct objectForKey:@"SellImage"]objectForKey:@"text"];
    sellStatus = [[dictProduct objectForKey:@"SellStatus"]objectForKey:@"text"];
    
    NSURL * url = [NSURL URLWithString:sellImage];
    [imgProduct setImageWithURL:url placeholderImage:[UIImage imageNamed:@"NoImage80.jpg"]];
    
    NSLog(@"%@---%@----%@-----%@",sellStatus,selStaIdType,location,latestBidAmount);
    
    lblProductName.text = selTitle;
    [lblProductName sizeToFit];
    
    lblLocation.text = location;
    [lblLocation sizeToFit];
    
    lblStatus.text = sellStatus;
    [lblStatus sizeToFit];
    

    
    selDescription = [selDescription stringByConvertingHTMLToPlainText];
    txtProductDesc.text = selDescription;
    txtProductDesc.textColor = [UIColor colorWithRed:20.0f/255.0f green:92.0f/255.0f blue:136.0f/255.0f alpha:1.0];
    txtProductDesc.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    scrollBackground.contentSize = CGSizeMake(320, 2000);
    
    UIFont * font = [UIFont fontWithName:@"Helvetica" size:15];
    
    
    CGRect newFrame1 = txtProductDesc.frame;
    newFrame1.size.height = [self frameForText:selDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 2000)].height + 50;
    txtProductDesc.frame = newFrame1;
    
    NSLog(@"%f",[self frameForText:selDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 2000)].height);
    
    
    if ([self frameForText:selDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 2000)].height <= 455.0) {
        scrollBackground.contentSize = CGSizeMake(320, 455);

    }
    else {
        scrollBackground.contentSize = CGSizeMake(320, 455+[self frameForText:selDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 2000)].height);
    }
    
    //txtProductDesc.frame = CGRectMake(20, 312, 280, 200);
    
    
//    CGSize size;
//    
//    size = [selDescription sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15] constrainedToSize:CGSizeMake(280,CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//
//    CGRect newFrame1 = txtProductDesc.frame;
//    newFrame1.size = size;
//    newFrame1.origin.x =  txtProductDesc.frame.origin.x;
    
    

    
    NSRange range = [selDatePosted rangeOfString:@"T"];
    NSRange range1 = [selDateExpire rangeOfString:@"T"];
    
    NSString *newString = [selDatePosted substringToIndex:range.location];
    NSString *newString1 = [selDateExpire substringToIndex:range1.location];
    
    lblQuantity.text = selQuantity;
    lblDatePosted.text = newString;
    lblDateExpired.text = newString1;
    
}

-(CGSize)frameForText:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size{
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];
    CGRect frame = [text boundingRectWithSize:size
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:attributesDictionary
                                      context:nil];
    
    // This contains both height and width, but we really care about height.
    return frame.size;
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


- (void)labelChangeForLanguage
{
    
}

- (IBAction)bidNowButtonClicked:(id)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]marketPlaceProductBidNowWithQuantity:@"1" withSellId:selId withBidAmount:@"100" withCompletionBlock:^(BOOL result, id resultObject) {
            
            [SVProgressHUD dismiss];
            if (result) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[resultObject objectForKey:@"text"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                [alert show];

            }
            else {
                
            }
        }];
    }
}

- (IBAction)buyNowButtonClicked:(id)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]marketPlaceProductBuyNowWithQuantity:@"1" withSellId:selId withCompletionBlock:^(BOOL result, id resultObject) {
            
            [SVProgressHUD dismiss];
            if (result) {
                NSLog(@"%@",resultObject);
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[resultObject objectForKey:@"text"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                [alert show];
            }
            else {
                
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    dictProduct = nil;
    
    currency = nil;
    latestBidAmount = nil;
    location = nil;
    selCatId = nil;
    selDateExpire = nil;
    selDatePosted = nil;
    selDescription = nil;
    selEnteredByMemId = nil;
    selId = nil;
    selMemId = nil;
    selNoOfViews = nil;
    selPricePerQuantityCash = nil;
    selPricePerQuantityTrade = nil;
    selQuantity = nil;
    selStaIdType = nil;
    selTitle = nil;
    sellImage = nil;
    sellStatus = nil;

}
@end
