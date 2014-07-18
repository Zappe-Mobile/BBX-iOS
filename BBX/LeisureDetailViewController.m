//
//  LeisureDetailViewController.m
//  BBX
//
//  Created by rkhan-mbook on 27/06/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "LeisureDetailViewController.h"
#import "Accomodation.h"
#import "UIImageView+AFNetworking.h"
#import "UINavigationController+Extras.h"

@interface LeisureDetailViewController ()
{
    NSManagedObject * dictData;
    
    IBOutlet UIImageView * productImage;
    IBOutlet UILabel * headingLabel;
    IBOutlet UILabel * subHeadingLabel;
    IBOutlet UITextView * descriptionLabel;
    IBOutlet UILabel * priceLabel;
    IBOutlet UITextView * addressLabel;
}
@end

@implementation LeisureDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithDictionary:(NSManagedObject *)dict
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
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Detail"];
    
    headingLabel.text = _giftPackageHeading;
    subHeadingLabel.text = _giftPackageSubHeading;
    descriptionLabel.text = _giftPackageDescription;
    descriptionLabel.textColor = [UIColor colorWithRed:20.0f/255.0f green:92.0f/255.0f blue:136.0f/255.0f alpha:1.0];
    priceLabel.text = _giftPackagePrice;
    addressLabel.text = _giftPackageAddress;
    addressLabel.textColor = [UIColor colorWithRed:20.0f/255.0f green:92.0f/255.0f blue:136.0f/255.0f alpha:1.0];
    [addressLabel sizeToFit];
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_giftPackageImage]];
    [productImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"NoImage80.jpg"]];

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
