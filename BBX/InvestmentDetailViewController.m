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
#import "NSString+HTML.h"

@interface InvestmentDetailViewController ()
{
    __weak IBOutlet UIScrollView * scrollBackground;
    __weak IBOutlet UIImageView * imageInvestment;
    __weak IBOutlet UILabel * lblInvestmentTitle;
    __weak IBOutlet UITextView * txtInvestmentDescription;
    NSDictionary * dictData;
    
    NSString * selDescription;
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
    
    selDescription = [[dictData objectForKey:@"SelDis"]objectForKey:@"text"];
    
    

    //selDescription = [selDescription stringByConvertingHTMLToPlainText];
    
    txtInvestmentDescription.text = selDescription;
    
    txtInvestmentDescription.text = selDescription;
    txtInvestmentDescription.textColor = [UIColor colorWithRed:20.0f/255.0f green:92.0f/255.0f blue:136.0f/255.0f alpha:1.0];
    txtInvestmentDescription.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    UIFont * font = [UIFont fontWithName:@"Helvetica" size:15];
    
    
    CGRect newFrame1 = txtInvestmentDescription.frame;
    newFrame1.size.height = [self frameForText:selDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 2000)].height + 50;
    txtInvestmentDescription.frame = newFrame1;
    
    NSLog(@"%f",[self frameForText:selDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 2000)].height);
    
    
    if ([self frameForText:selDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 2000)].height <= 128.0) {
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
