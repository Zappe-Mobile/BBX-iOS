//
//  InvestmentDetailViewController.m
//  BBX
//
//  Created by rkhan-mbook on 27/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "InvestmentDetailViewController.h"
#import "UINavigationController+Extras.h"
#import "UIImageView+AFNetworking.h"

@interface InvestmentDetailViewController ()
{
    __weak IBOutlet UIScrollView * scrollBackground;
    __weak IBOutlet UIImageView * imageInvestment;
    __weak IBOutlet UILabel * lblInvestmentTitle;
    __weak IBOutlet UITextView * txtInvestmentDescription;
    NSDictionary * dictData;
}
@end

@implementation InvestmentDetailViewController

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
        
        dictData = dict;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //! Navigation Bar Setup
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Investment Detail", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    NSLog(@"%@",dictData);
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dictData objectForKey:@"SellImage"]objectForKey:@"text"]]];
    [imageInvestment setImageWithURL:url placeholderImage:[UIImage imageNamed:@"NoImage80.jpg"]];

    lblInvestmentTitle.text = [[dictData objectForKey:@"SelTitle"]objectForKey:@"text"];
    [lblInvestmentTitle sizeToFit];
    
    txtInvestmentDescription.text = [[dictData objectForKey:@"SelDis"]objectForKey:@"text"];

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
