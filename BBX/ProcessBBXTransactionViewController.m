//
//  BBXTransactionViewController.m
//  BBX
//
//  Created by Roman Khan on 04/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ProcessBBXTransactionViewController.h"
#import "UINavigationController+Extras.h"
#import "ProcessTransactionView.h"
#import "BBXStringConstants.h"
#import "BBXFrameConstants.h"
#import "ViewTransactionViewController.h"
#import "ViewPaymentViewController.h"
#import "UIDevice+Extras.h"
#import "ZPickerView.h"
#import "RequestManager.h"
#import "SVProgressHUD.h"

@interface ProcessBBXTransactionViewController ()
{
    ProcessTransactionView * processTransactionView;
    
    __weak IBOutlet UIButton * btnIAm;
    __weak IBOutlet UITextField * txtBuyer;
    __weak IBOutlet UITextField * txtAmount;
    __weak IBOutlet UITextView * txtDescription;
    
    NSString * selectedValue;
}
@property (strong, nonatomic) ZPickerView * containerView;
@end

@implementation ProcessBBXTransactionViewController

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
    self.navigationItem.titleView = [self.navigationController setTitleView:NSLocalizedString(@"BBX Transaction", nil)];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    //self.navigationItem.rightBarButtonItem = [self setRightBarButton];

    
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
    [processTransactionView removeFromSuperview];
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
    if(![processTransactionView isDescendantOfView:self.navigationController.view]) {
        processTransactionView=(ProcessTransactionView*)[[[NSBundle mainBundle] loadNibNamed:@"ProcessTransactionView" owner:nil options:nil] objectAtIndex:0];
        processTransactionView.frame = kProcessTransactionFrame;
        processTransactionView.delegate = self;
        [self.navigationController.view addSubview:processTransactionView];
        
    } else {
        [processTransactionView removeFromSuperview];
    }
}

- (void)selectedViewControllerWithIdentifier:(NSString *)identifier
{
    if ([identifier isEqualToString:kViewTransactionViewController]) {
        ViewTransactionViewController * objTransaction = [[ViewTransactionViewController alloc]init];
        [self.navigationController pushViewController:objTransaction animated:YES];
    }
    else {
        ViewPaymentViewController * objPayment = [[ViewPaymentViewController alloc]init];
        [self.navigationController pushViewController:objPayment animated:YES];
    }
}

- (void)labelChangeForLanguage
{
    
}

- (IBAction)btnIAmClicked:(id)sender
{
    _containerView = [[NSBundle mainBundle] loadNibNamed:@"ZPickerView" owner:self options:nil][0];
    if ([[UIDevice currentDevice]isIPhone5]) {
        _containerView.frame = CGRectMake(0, 0, 320, 528);
    }
    else {
        _containerView.frame = CGRectMake(0, 0, 320, 440);
    }
    [_containerView loadDataForPickerType:TransactionPickerTypeCategory withManagedObject:nil withViewController:self];
    _containerView.delegate = self;
    [self.view addSubview:_containerView];

}


- (IBAction)processTransactionButtonClicked:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]processBBXTransactionWithUsername:@"" WithPassword:@"" WithLanguageId:@"" WithBuyerId:txtBuyer.text WithOtherMemberBuyer:@"NO" WithTransactionAmount:txtAmount.text WithTransactionDescription:txtDescription.text WithCompletionBlock:^(BOOL result, id resultObject) {
        
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

- (void)setSelectedValue:(NSString *)value WithSelectedId:(NSString *)selectedId WithPickerType:(DirectoryPickerType)pickerType
{
    switch (pickerType) {
        case TransactionPickerTypeCategory:
        {
            selectedValue = value;
            [btnIAm setTitle:value forState:UIControlStateNormal];
            txtBuyer.placeholder = [value isEqualToString:@"Seller"] ? @"Buyer" : @"Seller";
        }
            break;
        default:
            break;
    }

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
