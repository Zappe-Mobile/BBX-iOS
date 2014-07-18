//
//  RewardsViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "RewardsViewController.h"
#import "UINavigationController+Extras.h"
#import "RewardsCell.h"
#import "RequestManager.h"

@interface RewardsViewController ()
{
    __weak IBOutlet UIView * viewBackground;
    __weak IBOutlet UITextView * txtRewards;
    __weak IBOutlet UITableView * tblView;
    
    NSMutableArray * arrayProductName;
    NSMutableArray * arrayProductDescription;
}
@end

@implementation RewardsViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Rewards", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    //self.navigationItem.rightBarButtonItem = [self setRightBarButton];
    
    arrayProductName = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",nil];
    arrayProductDescription = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",nil];

    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    
    [[RequestManager sharedManager]getAboutUsTextWithSectionId:@"6" withCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] withLanguageId:@"247" withCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSLog(@"%@",[resultObject objectForKey:@"text"]);
            txtRewards.text = [resultObject objectForKey:@"text"];
            txtRewards.textColor = [UIColor blackColor];
        }
        else {
            
        }
    }];

    
//    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"BBX Rewards Program: Rewarding you as a BBX Member!\n\nBBX Rewards is just one more reason why BBX members have a permanent smile on their faces!Best of all you don't have to do anything different or extra - simply use the BBX system to increase your sales and cash flow and you'll be able to earn reward points that you can redeem against a wide range of sought after consumer goods"];
//    
//    [hogan addAttribute:NSFontAttributeName
//                  value:[UIFont fontWithName:@"Helvetica" size:13]
//                  range:NSMakeRange(0, 381)];
//    
//    
//    txtRewards.attributedText = hogan;
//    txtRewards.textColor = [UIColor whiteColor];
    
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
    
}

#pragma mark - Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    return [arrayProductName count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    RewardsCell *cell = (RewardsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[RewardsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier] ;
        
    }
    
    cell.lblProductName.text = [arrayProductName objectAtIndex:indexPath.row];
    cell.lblProductDescription.text = [arrayProductDescription objectAtIndex:indexPath.row];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
