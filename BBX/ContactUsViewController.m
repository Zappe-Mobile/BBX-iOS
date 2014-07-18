//
//  ContactUsViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ContactUsViewController.h"
#import "UINavigationController+Extras.h"
#import "ContactCell.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "Contact.h"
#import "SVProgressHUD.h"
#import "ZPickerView.h"
#import "UIDevice+Extras.h"
#import "HomeViewController.h"
#import "AlternateHomeViewController.h"

@interface ContactUsViewController () <SearchDirectory,UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate>
{
    __weak IBOutlet UIButton * btnCountry;
    
    UITapGestureRecognizer * tapGesture;
}
@property (strong, nonatomic) ZPickerView * containerView;
@end

@implementation ContactUsViewController

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
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    //! Navigation Bar Setup
    self.navigationItem.titleView = [self.navigationController setTitleView:[arrayValue objectAtIndex:[arrayKey indexOfObject:@"Contact"]]];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    //self.navigationItem.rightBarButtonItem = [self setRightBarButton];

    [btnCountry setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRYNAME"] forState:UIControlStateNormal];
    
    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

    arrayCity = [[NSMutableArray alloc]init];
    arrayStreet = [[NSMutableArray alloc]init];
    arrayArea = [[NSMutableArray alloc]init];
    arrayPhone = [[NSMutableArray alloc]init];
    arrayFax = [[NSMutableArray alloc]init];
    arrayEmail = [[NSMutableArray alloc]init];
    
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]getContactDetailsByCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSLog(@"%@",resultObject);
            [DataManager storeContactInfo:[resultObject objectForKey:@"Table1"] DataBlock:^(BOOL success, NSError *error) {
                
                [SVProgressHUD dismiss];
                if (success) {
                    
                    [self loadAllContactData:[DataManager loadAllContactsFromCoreData]];
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

- (void)loadAllContactData:(NSArray *)array
{
    [arrayCity removeAllObjects];
    [arrayStreet removeAllObjects];
    [arrayArea removeAllObjects];
    [arrayPhone removeAllObjects];
    [arrayFax removeAllObjects];
    [arrayEmail removeAllObjects];
    
    for (Contact * Object in array) {
        
        [arrayCity addObject:Object.franchiseName];
        [arrayStreet addObject:Object.franchiseName];
        [arrayArea addObject:Object.address];
        [arrayPhone addObject:Object.phone];
        [arrayFax addObject:Object.fax];
        [arrayEmail addObject:Object.email];
    }
    
    [tblView reloadData];
}

#pragma mark - Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 153;
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
    return [arrayCity count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier] ;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
 
    cell.lblCity.text = [arrayCity objectAtIndex:indexPath.row];
    cell.lblStreet.text = [arrayStreet objectAtIndex:indexPath.row];
    cell.lblArea.text = [arrayArea objectAtIndex:indexPath.row];
    cell.txtPhone.text = [arrayPhone objectAtIndex:indexPath.row];
    cell.lblFax.text = [arrayFax objectAtIndex:indexPath.row];
    cell.lblEmail.text = [arrayEmail objectAtIndex:indexPath.row];
    cell.lblEmail.tag = indexPath.row;
    
    tapGesture = [[UITapGestureRecognizer alloc]init];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [tapGesture addTarget:self action:@selector(openEmailView:)];
    [cell.lblEmail addGestureRecognizer:tapGesture];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (IBAction)selectCountryButtonClicked:(id)sender
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
            [btnCountry setTitle:value forState:UIControlStateNormal];

            
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            [[RequestManager sharedManager]getContactDetailsByCountryId:[[NSUserDefaults standardUserDefaults]objectForKey:@"SELECTEDCOUNTRY"] WithCompletionBlock:^(BOOL result, id resultObject) {
                
                [SVProgressHUD dismiss];
                if (result) {
                    
                    if (resultObject == NULL) {
                        
                        [arrayCity removeAllObjects];
                        [arrayStreet removeAllObjects];
                        [arrayArea removeAllObjects];
                        [arrayPhone removeAllObjects];
                        [arrayFax removeAllObjects];
                        [arrayEmail removeAllObjects];
                        
                        
                        [tblView reloadData];
                        
                    }
                    else {
                        
                        if ([[resultObject objectForKey:@"AllEvents"]isKindOfClass:[NSArray class]]) {
                            
                            [DataManager storeContactInfo:[resultObject objectForKey:@"Table1"] DataBlock:^(BOOL success, NSError *error) {
                               
                                if (success) {
                                    
                                    [self loadAllContactData:[DataManager loadAllContactsFromCoreData]];
                                }
                                else {
                                    
                                }
                            }];
                            
                        }
                        else if ([[resultObject objectForKey:@"Table1"]isKindOfClass:[NSDictionary class]]){
                            
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


- (void)openEmailView:(UIGestureRecognizer *)sender
{
    NSLog(@"%d",sender.view.tag);
    
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *EmailPicker = [[MFMailComposeViewController alloc] init];
        EmailPicker.mailComposeDelegate = self;
        
        [EmailPicker setToRecipients:[NSArray arrayWithObjects:[arrayEmail objectAtIndex:sender.view.tag], nil]];
        [self presentViewController:EmailPicker animated:YES completion:nil];
        
    }

}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString *msg1;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg1 =@"Sending Mail is cancelled";
            break;
        case MFMailComposeResultSaved:
            msg1=@"Sending Mail is Saved";
            break;
        case MFMailComposeResultSent:
            msg1 =@"Your Mail has been sent successfully";
            break;
        case MFMailComposeResultFailed:
            msg1 =@"Message sending failed";
            break;
        default:
            msg1 =@"Your Mail is not Sent";
            break;
    }
    UIAlertView *mailResuletAlert = [[UIAlertView alloc]initWithFrame:CGRectMake(10, 170, 300, 120)];
    mailResuletAlert.message=msg1;
    mailResuletAlert.title=@"Message";
    [mailResuletAlert addButtonWithTitle:@"OK"];
    [mailResuletAlert show];
    [self dismissViewControllerAnimated:YES completion:nil];
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
