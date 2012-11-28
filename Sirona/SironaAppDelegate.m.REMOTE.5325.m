//
//  SironaAppDelegate.m
//  Sirona
//
//  Created by Roger Chen on 11/7/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaAppDelegate.h"
#import "SironaHomeViewController.h"
#import "SironaHomeViewControllerB.h"
#import "SironaTimeViewController.h"
#import "SironaLibraryViewController.h"
#import "SironaSettingsViewController.h"
#import "SironaAlertList.h"
#import "SironaAlertsViewController.h"

@implementation SironaAppDelegate

@synthesize window = _window;
@synthesize userAlerts;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    // First instantiate instances of all of the different UIViewControllers
    SironaHomeViewController *shvc = [[SironaHomeViewController alloc] init];
    SironaAlertsViewController *savc = [[SironaAlertsViewController alloc] init];
    SironaLibraryViewController *slvc = [[SironaLibraryViewController alloc] init];
    
    // Establish navigation controllers for each of the UIViewControllers that need one
    UINavigationController *homeViewController = [[UINavigationController alloc] initWithRootViewController:shvc];
    UINavigationController *alertsViewController = [[UINavigationController alloc] initWithRootViewController:savc];
    UINavigationController *libraryViewController = [[UINavigationController alloc] initWithRootViewController:slvc];
    
    // Change the UINavigationBar color to green
    UIColor *green = [[UIColor alloc] initWithRed:76/255. green:166/255. blue:93/255. alpha:1];
    homeViewController.navigationBar.tintColor = green;
    alertsViewController.navigationBar.tintColor = green;
    libraryViewController.navigationBar.tintColor = green;
    
    // Set the color of the status bar to be black instead of green
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    // Create the tab bar controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    /* TESTING AN ALTERNATIVE HOME VIEW HERE */
    //SironaHomeViewControllerB *altHome = [[SironaHomeViewControllerB alloc] init];
    
    // Create an array of the available view controllers, then set them to the TabBar
    NSArray *viewControllers = [NSArray arrayWithObjects:homeViewController, alertsViewController, libraryViewController, nil];
    [tabBarController setViewControllers:viewControllers];
    
    // Make it visible
    [[self window] setRootViewController:tabBarController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    /*
    // uniqueIdentifier deprecated since iOS5
    #define TESTING 1
    #ifdef TESTING
        [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    #endif
    
    [TestFlight takeOff:@"f9a37f0ed8d5db98483697763b46a443_MTU1MDcwMjAxMi0xMS0xNCAwNDoyNzozNS4wMjEzNzA"];
    */
    
    application.applicationIconBadgeNumber = 0;
    
    userAlerts = [[SironaAlertList alloc] init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    userAlerts = [prefs objectForKey:@"userAlerts"];
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"Received notification (localNotif): %@", localNotif);
    }
    
    return YES;
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
    NSLog(@"Received notification (didReceive): %@", notification);
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
