//
//  PayFeeViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "PayFeeViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "ZPickerView.h"
#import "UIDevice+Extras.h"
#import "Reachability.h"
#import "SVProgressHUD.h"

@interface PayFeeViewController ()
{
    __weak IBOutlet UITextField * txtCreditCardNo;
    __weak IBOutlet UIButton * btnCardExpiryMonth;
    __weak IBOutlet UIButton * btnCardExpiryYear;
    __weak IBOutlet UITextField * txtCardSecurityCode;
    __weak IBOutlet UITextField * txtCardAmount;
    
    NSString * selectedMonth;
    NSString * selectedYear;
}
@property (strong, nonatomic) ZPickerView * containerView;
@end

@implementation PayFeeViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"Pay Fee", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];

    //! Notification Listener for Language Change
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(labelChangeForLanguage)
                                                name:@"LANGUAGECHANGE"
                                              object:nil];

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


- (IBAction)selectMonthClicked:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:PayFeePickerTypeMonth withManagedObject:nil withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}

- (IBAction)selectYearClicked:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:PayFeePickerTypeYear withManagedObject:nil withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}

- (void)setSelectedValue:(NSString *)value WithSelectedId:(NSString *)selectedId WithPickerType:(DirectoryPickerType)pickerType
{
    switch (pickerType) {
        case PayFeePickerTypeMonth:
        {
            selectedMonth = selectedId;
            [btnCardExpiryMonth setTitle:value forState:UIControlStateNormal];
        }
            break;
        case PayFeePickerTypeYear:
        {
            selectedYear = selectedId;
            [btnCardExpiryYear setTitle:value forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}


- (IBAction)payFeeClicked:(id)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        if ([txtCreditCardNo.text length]>0 && [txtCardAmount.text length]>0 && [txtCardSecurityCode.text length]>0) {
            
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            NSString * cardExpiry = [NSString stringWithFormat:@"%@/%@",selectedMonth,selectedYear];
            [[RequestManager sharedManager]processPayFeeWithCreditCardNumber:txtCreditCardNo.text withCreditCardExpiryDate:cardExpiry withCreditCardSecurityCode:txtCardSecurityCode.text withPaymentAmount:txtCardAmount.text withCompletionBlock:^(BOOL result, id resultObject) {
                
                [SVProgressHUD dismiss];
                if (result) {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[resultObject objectForKey:@"text"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                    [alert show];
                    
                    txtCreditCardNo.text = @"";
                    [btnCardExpiryMonth setTitle:@"Month" forState:UIControlStateNormal];
                    [btnCardExpiryYear setTitle:@"Year" forState:UIControlStateNormal];
                    txtCardSecurityCode.text = @"";
                    txtCardAmount.text = @"";
                    
                }
                else {
                    
                }
            }];

        }
        else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please fill all Data" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [alert show];

            
        }

    }
    else {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Internet Connection.Please Try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [alert show];
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
