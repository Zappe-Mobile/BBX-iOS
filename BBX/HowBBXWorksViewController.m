//
//  HowBBXWorksViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "HowBBXWorksViewController.h"
#import "UINavigationController+Extras.h"
#import "BBXWorksCell.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "Videos.h"
#import "Reachability.h"

@interface HowBBXWorksViewController ()
{
    __weak IBOutlet UITableView * tblView;
    __weak IBOutlet UIView * viewBackground;
    
    NSMutableArray * arrayTitle;
    NSMutableArray * arrayLink;
}
@end

@implementation HowBBXWorksViewController

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
    
    
    //! Navigation Bar Setup
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"How BBX Works"]]];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    //self.navigationItem.rightBarButtonItem = [self setRightBarButton];
    
    arrayTitle = [[NSMutableArray alloc]init];
    arrayLink = [[NSMutableArray alloc]init];
    
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        [[RequestManager sharedManager]getVideosWithCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] withCompletionBlock:^(BOOL result, id resultObject) {
            
            if (result) {
                
                NSLog(@"%@",resultObject);
                [DataManager storeVideoData:[resultObject objectForKey:@"Table1"] DataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        
                        [self setVideoData:[DataManager loadAllVideoDataFromCoreData]];
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
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Internet Connection not available.Please Try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
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
    return 70;
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
    return [arrayTitle count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    BBXWorksCell *cell = (BBXWorksCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[BBXWorksCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier] ;
        
    }
    
    cell.lblTitle.text = [arrayTitle objectAtIndex:indexPath.row];
    
    NSString *videoHTML = [NSString stringWithFormat:@"\
                           <html>\
                           <head>\
                           <style type=\"text/css\">\
                           iframe {position:absolute; top:50%%; margin-top:-130px;}\
                           body {background-color:#000; margin:0;}\
                           </style>\
                           </head>\
                           <body>\
                           <iframe width=\"100%%\" height=\"240px\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                           </body>\
                           </html>", [arrayLink objectAtIndex:indexPath.row]];
    
    [cell.webVideo loadHTMLString:videoHTML baseURL:nil];

    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)setVideoData:(NSArray *)videoArray
{
    for (Videos * Object in videoArray) {
        
        [arrayTitle addObject:Object.title];
        NSString * str = [Object.link stringByReplacingOccurrencesOfString:@"youtu.be/" withString:@"youtube.com/embed/"];
        [arrayLink addObject:str];
    }
    
    
    
    NSLog(@"%@",arrayLink);

    
    [tblView reloadData];
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
