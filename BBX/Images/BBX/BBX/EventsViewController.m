//
//  EventsViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "EventsViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "Events.h"
#import "EventsCell.h"
#import "SVProgressHUD.h"
#import "ZPickerView.h"
#import "SearchBBXDirectoryViewController.h"
#import "UIDevice+Extras.h"
#import "HomeViewController.h"
#import "AlternateHomeViewController.h"

@interface EventsViewController () <SearchDirectory>
{
    __weak IBOutlet UITableView * tblView;
    __weak IBOutlet UIButton * btnEvent;
    
    NSMutableArray * arrayEventsTitle;
    NSMutableArray * arrayEventsDescription;
    NSMutableArray * arrayEventsVenueName;
    NSMutableArray * arrayEventsVenueAddress;
    NSMutableArray * arrayEventsDateTime;
    NSMutableArray * arrayEventsContactInfo;
    NSMutableArray * arrayEventsCostDetails;
    NSMutableArray * arrayEventsType;
}
@property (strong, nonatomic) ZPickerView * containerView;
@end

@implementation EventsViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"EVENT"]]];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    self.navigationItem.rightBarButtonItem = [self setRightBarButton];
    
    [btnEvent setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRYNAME"] forState:UIControlStateNormal];

    
    arrayEventsTitle = [[NSMutableArray alloc]init];
    arrayEventsDescription = [[NSMutableArray alloc]init];
    arrayEventsVenueName = [[NSMutableArray alloc]init];
    arrayEventsVenueAddress = [[NSMutableArray alloc]init];
    arrayEventsDateTime = [[NSMutableArray alloc]init];
    arrayEventsContactInfo = [[NSMutableArray alloc]init];
    arrayEventsCostDetails = [[NSMutableArray alloc]init];
    arrayEventsType = [[NSMutableArray alloc]init];
    
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]getEventsDetailsByCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] WithCompletionBlock:^(BOOL result, id resultObject) {
        
        [SVProgressHUD dismiss];
        if (result) {
            
            if ([[resultObject objectForKey:@"AllEvents"] count] == 0) {
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Events !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
            if ([[resultObject objectForKey:@"AllEvents"]isKindOfClass:[NSArray class]]) {

                [DataManager storeAllEvents:[resultObject objectForKey:@"AllEvents"] dataDictionary:nil DataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        [SVProgressHUD dismiss];
                        [self setEventsData:[DataManager loadAllEventsFromCoreData]];
                    }
                    else {
                        [SVProgressHUD dismiss];
                    }
                }];

            }
            else {
                
                
            }
            }
            
        }
        else {
           [SVProgressHUD dismiss];
        }
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
    
}


#pragma mark - Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
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
    return [arrayEventsTitle count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    EventsCell *cell = (EventsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[EventsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier] ;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.lblEventTitle.text = [arrayEventsTitle objectAtIndex:indexPath.row];
    cell.lblVenueName.text = [arrayEventsVenueName objectAtIndex:indexPath.row];
    cell.lblVenueAddress.text = [arrayEventsVenueAddress objectAtIndex:indexPath.row];
    cell.lblDateTime.text = [arrayEventsDateTime objectAtIndex:indexPath.row];
    cell.lblContactInfo.text = [arrayEventsContactInfo objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)setEventsData:(NSArray *)eventsArray
{
    
    [arrayEventsTitle removeAllObjects];
    [arrayEventsDescription removeAllObjects];
    [arrayEventsVenueName removeAllObjects];
    [arrayEventsVenueAddress removeAllObjects];
    [arrayEventsDateTime removeAllObjects];
    [arrayEventsCostDetails removeAllObjects];
    [arrayEventsContactInfo removeAllObjects];
    [arrayEventsType removeAllObjects];
    
    for (Events * Object in eventsArray) {
        
        [arrayEventsTitle addObject:Object.eventTitle];
        [arrayEventsDescription addObject:Object.eventDescription];
        [arrayEventsVenueName addObject:Object.eventVenueName];
        [arrayEventsVenueAddress addObject:Object.eventVenueAddress];
        [arrayEventsDateTime addObject:Object.eventDateTime];
        [arrayEventsCostDetails addObject:Object.eventCostDetails];
        [arrayEventsContactInfo addObject:Object.eventContactInfo];
        [arrayEventsType addObject:Object.eventType];
    }
    
    
    NSLog(@"%@",arrayEventsDescription);
    NSLog(@"%@",arrayEventsVenueName);
    NSLog(@"%@",arrayEventsVenueAddress);
    NSLog(@"%@",arrayEventsDateTime);
    NSLog(@"%@",arrayEventsCostDetails);
    NSLog(@"%@",arrayEventsContactInfo);
    NSLog(@"%@",arrayEventsType);
    
    [tblView reloadData];
}


- (IBAction)selectCountryButton:(id)sender
{
    NSUInteger numberOfViewControllersOnStack = [self.navigationController.viewControllers count];
    UIViewController *parentViewController = self.navigationController.viewControllers[numberOfViewControllersOnStack - 2];
    //    Class parentVCClass = [parentViewController class];
    //    NSString *className = NSStringFromClass(parentVCClass);
    //    NSLog(@"%@",className);
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        if ([parentViewController isKindOfClass:[HomeViewController class]]) {
            _containerView.frame = CGRectMake(0, 0, 320, 568);
        }
        else {
            _containerView.frame = CGRectMake(0, 0, 320, 528);
        }
        
    }
    else {
        if ([parentViewController isKindOfClass:[HomeViewController class]])
        {
            _containerView.frame = CGRectMake(0, 0, 320, 480);
        }
        else {
            _containerView.frame = CGRectMake(0, 0, 320, 440);
        }
    }
    [_containerView loadDataForPickerType:DirectoryPickerTypeCountry withManagedObject:nil withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}

- (void)setSelectedValue:(NSString *)value WithSelectedId:(NSString *)selectedId WithPickerType:(DirectoryPickerType)pickerType
{
    switch (pickerType) {
        case DirectoryPickerTypeCountry:
        {
            [btnEvent setTitle:value forState:UIControlStateNormal];
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            [[RequestManager sharedManager]getEventsDetailsByCountryId:selectedId WithCompletionBlock:^(BOOL result, id resultObject) {
                
                if (result) {
                    [SVProgressHUD dismiss];
                    
                    NSLog(@"%@",resultObject);
                    if (resultObject == NULL) {
                        
                        [arrayEventsTitle removeAllObjects];
                        [arrayEventsDescription removeAllObjects];
                        [arrayEventsVenueName removeAllObjects];
                        [arrayEventsVenueAddress removeAllObjects];
                        [arrayEventsDateTime removeAllObjects];
                        [arrayEventsCostDetails removeAllObjects];
                        [arrayEventsContactInfo removeAllObjects];
                        [arrayEventsType removeAllObjects];
                        
                        
                        [tblView reloadData];

                    }
                    else {
                        
                        if ([[resultObject objectForKey:@"AllEvents"]isKindOfClass:[NSArray class]]) {
                            
                            [DataManager storeAllEvents:[resultObject objectForKey:@"AllEvents"] dataDictionary:nil DataBlock:^(BOOL success, NSError *error) {
                                
                                if (success) {
                                    [SVProgressHUD dismiss];
                                    [self setEventsData:[DataManager loadAllEventsFromCoreData]];
                                }
                                else {
                                    [SVProgressHUD dismiss];
                                }
                            }];
                            
                        }
                        else if ([[resultObject objectForKey:@"AllEvents"]isKindOfClass:[NSDictionary class]]){
                            
                            NSLog(@"Dictionary");
                            NSLog(@"%@",[resultObject objectForKey:@"AllEvents"]);
                            [DataManager storeAllEvents:nil dataDictionary:[resultObject objectForKey:@"AllEvents"] DataBlock:^(BOOL success, NSError *error) {
                                
                                if (success) {
                                    [SVProgressHUD dismiss];
                                    [self setEventsData:[DataManager loadAllEventsFromCoreData]];
                                }
                                else {
                                    [SVProgressHUD dismiss];
                                }
                            }];
                        }

                    }
                    
                   
                }
                else {
                    [SVProgressHUD dismiss];
                }
            }];

        }
            break;
        default:
            break;
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

- (void)dealloc
{
    
}
@end
