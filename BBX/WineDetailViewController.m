//
//  WineDetailViewController.m
//  BBX
//
//  Created by Roman Khan on 7/18/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "WineDetailViewController.h"
#import "UINavigationController+Extras.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+HTML.h"

@interface WineDetailViewController ()
{
    __weak IBOutlet UIScrollView * scrollBackground;
    __weak IBOutlet UIImageView * imgWine;
    __weak IBOutlet UILabel * lblWineName;
    __weak IBOutlet UILabel * lblWinePrice;
    __weak IBOutlet UILabel * lblWineStatus;
    __weak IBOutlet UILabel * lblWineQuantity;
    __weak IBOutlet UITextView * txtWineDescription;
    
    NSDictionary * dictProduct;
    
    NSString * currency;
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

}
@end

@implementation WineDetailViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Wine Detail", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];

    
    currency = [[dictProduct objectForKey:@"Currency"]objectForKey:@"text"];
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
    [imgWine setImageWithURL:url placeholderImage:[UIImage imageNamed:@"NoImage80.jpg"]];
    
    lblWineName.text = selTitle;
    
    lblWinePrice.text = [NSString stringWithFormat:@"%@ %@",currency,selPricePerQuantityTrade];
    
    lblWineStatus.text = sellStatus;
    
    lblWineQuantity.text = selQuantity;
    
    selDescription = [selDescription stringByConvertingHTMLToPlainText];
    txtWineDescription.text = selDescription;
    txtWineDescription.textColor = [UIColor colorWithRed:20.0f/255.0f green:92.0f/255.0f blue:136.0f/255.0f alpha:1.0];
    txtWineDescription.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    UIFont * font = [UIFont fontWithName:@"Helvetica" size:15];
    
    
    CGRect newFrame1 = txtWineDescription.frame;
    newFrame1.size.height = [self frameForText:selDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 2000)].height + 50;
    txtWineDescription.frame = newFrame1;
    
    NSLog(@"%f",[self frameForText:selDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 2000)].height);
    
    
    if ([self frameForText:selDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 2000)].height <= 90.0) {
        scrollBackground.contentSize = CGSizeMake(320, 367);
        
    }
    else {
        scrollBackground.contentSize = CGSizeMake(320, 367+[self frameForText:selDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 2000)].height);
    }


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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
