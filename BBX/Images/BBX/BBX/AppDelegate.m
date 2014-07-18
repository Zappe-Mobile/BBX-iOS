//
//  AppDelegate.m
//  BBX
//
//  Created by Roman Khan on 02/04/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "AlternateHomeViewController.h"
#import "UIDevice+Extras.h"
#import "AccountViewController.h"
#import "TransactionViewController.h"
#import "OtherViewController.h"
#import "MyAccountViewController.h"
#import "ProcessBBXTransactionViewController.h"
#import "OptionsViewController.h"

@implementation AppDelegate

-(void)setController:(NSString *)value
{
    Value = value;
    if ([Value isEqualToString:@"0"]) {

        HomeViewController * objHome = [[HomeViewController alloc]init];
        UINavigationController * navLogin = [[UINavigationController alloc]initWithRootViewController:objHome];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
        if ([[UIDevice currentDevice]IS_OS_7]) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:19.0f/255.0f green:106.0f/255.0f blue:221.0f/255.0f alpha:1.0]];
            [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
            navLogin.navigationBar.translucent = YES;
        }
        else if ([[UIDevice currentDevice]IS_OS_6]) {
            [navLogin.navigationBar setTintColor:[UIColor colorWithRed:19.0f/255.0f green:106.0f/255.0f blue:221.0f/255.0f alpha:1.0]];
            [[UIApplication sharedApplication]setStatusBarHidden:NO];
            navLogin.navigationBar.translucent = NO;
            
        }
        
        UITabBarController * tabBarController = [[UITabBarController alloc]init];
        
//        MyAccountViewController * objAccount = [[MyAccountViewController alloc]init];
//        UINavigationController * navAccount = [[UINavigationController alloc]initWithRootViewController:objAccount];
//        
//        ProcessBBXTransactionViewController * objTrans = [[ProcessBBXTransactionViewController alloc]init];
//        UINavigationController * navTrans = [[UINavigationController alloc]initWithRootViewController:objTrans];
        
        OptionsViewController * objOther = [[OptionsViewController alloc]init];
        UINavigationController * navOther = [[UINavigationController alloc]initWithRootViewController:objOther];
        
        navLogin.tabBarItem.title = @"Home";
        navLogin.tabBarItem.image = [UIImage imageNamed:@"icon_One.png"];
        
//        navAccount.tabBarItem.title = @"My Account";
//        navAccount.tabBarItem.image = [UIImage imageNamed:@"icon_Two.png"];
//        
//        navTrans.tabBarItem.title = @"Transactions";
//        navTrans.tabBarItem.image = [UIImage imageNamed:@"icon_Three.png"];
        
        navOther.tabBarItem.title = @"Options";
        navOther.tabBarItem.image = [UIImage imageNamed:@"icon_Four.png"];
        
        [tabBarController setViewControllers:[NSArray arrayWithObjects:navLogin,navOther,nil]];
        //tabBarController.tabBar.backgroundColor = [UIColor colorWithRed:103.0f/255.0f green:137.0f/255.0f blue:202.0f/255.0f alpha:1.0];
        
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
        //[[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
        
        tabBarController.tabBar.barTintColor =  [UIColor colorWithRed:34.0f/255.0f green:111.0f/255.0f blue:211.0f/255.0f alpha:1.0];
        
        self.window.rootViewController = tabBarController;


        //self.window.rootViewController = navLogin;

        
        
    }
    else if ([Value isEqualToString:@"1"]){
        LoginViewController * objRegister = [[LoginViewController alloc]init];
        UINavigationController * registerNav = [[UINavigationController alloc]initWithRootViewController:objRegister];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
        if ([[UIDevice currentDevice]IS_OS_7]) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:19.0f/255.0f green:106.0f/255.0f blue:221.0f/255.0f alpha:1.0]];
            [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
        }
        else if ([[UIDevice currentDevice]IS_OS_6]) {
            [registerNav.navigationBar setTintColor:[UIColor colorWithRed:19.0f/255.0f green:106.0f/255.0f blue:221.0f/255.0f alpha:1.0]];
            [[UIApplication sharedApplication]setStatusBarHidden:NO];
            registerNav.navigationBar.translucent = NO;
            
        }

        [self.window setRootViewController:registerNav];
        
    }
    else {
       
        AlternateHomeViewController * objHome = [[AlternateHomeViewController alloc]init];
        UINavigationController * navLogin = [[UINavigationController alloc]initWithRootViewController:objHome];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
        if ([[UIDevice currentDevice]IS_OS_7]) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:19.0f/255.0f green:106.0f/255.0f blue:221.0f/255.0f alpha:1.0]];
            [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
        }
        else if ([[UIDevice currentDevice]IS_OS_6]) {
            [navLogin.navigationBar setTintColor:[UIColor colorWithRed:19.0f/255.0f green:106.0f/255.0f blue:221.0f/255.0f alpha:1.0]];
            [[UIApplication sharedApplication]setStatusBarHidden:NO];
            navLogin.navigationBar.translucent = NO;
            
        }
        
        UITabBarController * tabBarController = [[UITabBarController alloc]init];
        
        MyAccountViewController * objAccount = [[MyAccountViewController alloc]init];
        UINavigationController * navAccount = [[UINavigationController alloc]initWithRootViewController:objAccount];
        
        ProcessBBXTransactionViewController * objTrans = [[ProcessBBXTransactionViewController alloc]init];
        UINavigationController * navTrans = [[UINavigationController alloc]initWithRootViewController:objTrans];
        
        OtherViewController * objOther = [[OtherViewController alloc]init];
        UINavigationController * navOther = [[UINavigationController alloc]initWithRootViewController:objOther];
        
        navLogin.tabBarItem.title = @"Home";
        navLogin.tabBarItem.image = [UIImage imageNamed:@"icon_One.png"];
        
        navAccount.tabBarItem.title = @"My Account";
        navAccount.tabBarItem.image = [UIImage imageNamed:@"icon_Two.png"];
        
        navTrans.tabBarItem.title = @"Transactions";
        navTrans.tabBarItem.image = [UIImage imageNamed:@"icon_Three.png"];
        
        navOther.tabBarItem.title = @"Other";
        navOther.tabBarItem.image = [UIImage imageNamed:@"icon_Four.png"];

        [tabBarController setViewControllers:[NSArray arrayWithObjects:navLogin,navAccount,navTrans,navOther,nil]];
        //tabBarController.tabBar.backgroundColor = [UIColor colorWithRed:103.0f/255.0f green:137.0f/255.0f blue:202.0f/255.0f alpha:1.0];
        
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
        //[[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
        
        tabBarController.tabBar.barTintColor =  [UIColor colorWithRed:34.0f/255.0f green:111.0f/255.0f blue:211.0f/255.0f alpha:1.0];
        
        self.window.rootViewController = tabBarController;

    }
    [self.window makeKeyAndVisible];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"firstLaunch"]) {
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"247" forKey:@"SELECTEDLANGUAGE"];
        [defaults setObject:@"English" forKey:@"SELECTEDLANGUAGENAME"];
        [defaults setObject:@"5" forKey:@"SELECTEDCOUNTRY"];
        [defaults setObject:@"Australia" forKey:@"SELECTEDCOUNTRYNAME"];
        [defaults setObject:@"247" forKey:@"LANGSELECTED"];
        [defaults synchronize];
    }

    [MagicalRecord setupCoreDataStack];
    [self setController:@"0"];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
