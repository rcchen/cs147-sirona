//
//  SironaAlertsViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/14/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaAlertsViewController.h"
#import "SironaTimeCellView.h"
#import "SironaTimeEditAlertView.h"
#import "SironaAlertItem.h"

@implementation SironaAlertsViewController

@synthesize alertsTable;
@synthesize alerts;

- (id) init
{
    
    self = [super init];
    
    if (self) {
        
        // Get the tab bar item and give it a label
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Alerts"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"10-medical.png"];
        [tbi setImage:i];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:NSLocalizedString(@"Alerts", @"Application title")];
        
        // Create a new bar button item that will send addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        // Set the button on the left to edit for the navigationItem
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
    }
    return self;
    
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"SironaTimeCellView" bundle:nil];
    [alertsTable registerNib:nib forCellReuseIdentifier:@"SironaTimeCellView"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
    if (encodedAlertList) {
        NSMutableArray *prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
        alerts = prefAlerts;
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
    if (encodedAlertList) {
        NSMutableArray *prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
        alerts = prefAlerts;
    }
    
    // Programatically add a tableView to the thing
    alertsTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.alertsTable.dataSource = self;
    self.alertsTable.delegate = self;
    [[self alertsTable] reloadData];
    [self.view addSubview:alertsTable];
        
    for (SironaAlertItem *alertItem in alerts) {
        [self setAllAlarms:alertItem];
    }
    
    for (UILocalNotification *old in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSLog(@"Alert for %@ at %@", [old.userInfo objectForKey:@"alertID"], [old fireDate]);
    }
    
    if (![alerts count]) {
        
        // Handles the overlay
        UIViewController* c = [[UIViewController alloc] initWithNibName:@"SironaAlertNoneView" bundle:nil];
        UIView *overlayNone = [c view];
        overlayNone.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self.view addSubview:overlayNone];
        
    }

}


- (void)viewWillDisappear:(BOOL)animated
{
    // Save encoded data to NSUserDefaults in case there were alerts that were deleted
    [self saveEncodedData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92.0f;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [alerts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SironaTimeCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"SironaTimeCellView"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SironaTimeCellView" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = (SironaTimeCellView *)[topLevelObjects objectAtIndex:0];
    }

    SironaAlertItem *sai = [alerts objectAtIndex:[indexPath row]];
    [[cell cellMain] setText:[[sai getLibraryItem] getBrand]];
    [[cell cellSecondary] setText:[[sai getLibraryItem] getCategory]];
    
    NSMutableString *tertiaryText = [[NSMutableString alloc] init];
    if ([[sai getAlertDays] count] == 0)
        [[cell cellTertiary] setText:@"No days set"];
    else {
        for (NSString *day in [sai getAlertDays]) {
            [tertiaryText appendFormat:@"%@ ", [day substringToIndex:3]];
        } [[cell cellTertiary] setText:tertiaryText];
    }
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SironaTimeEditAlertView *stevc = [[SironaTimeEditAlertView alloc] init];
    SironaAlertItem *selectedItem = [alerts objectAtIndex:[indexPath row]];
    [stevc setItem:selectedItem];
    [[self navigationController] pushViewController:stevc animated:YES];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [alerts removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
    
}


- (IBAction)addNewItem:(id)sender
{
    
    SironaTimeEditAlertView *stevc = [[SironaTimeEditAlertView alloc] init];
    SironaAlertItem *newItem = [[SironaAlertItem alloc] init];
    [newItem setAlertId];
    [stevc setItem:newItem];
    [stevc setAlertList:alerts];
    [[self navigationController] pushViewController:stevc animated:YES];
    
}


- (void)setAllAlarms:(SironaAlertItem *)alertItem
{
    
    // First delete all of the alarms associated with the alertItem
    for (UILocalNotification *old in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        // Cancel anything that matches the alertID
        if ([[old.userInfo objectForKey:@"alertID"] isEqualToString:[alertItem getAlertId]]) {
            [[UIApplication sharedApplication] cancelLocalNotification:old];
        }
        
    }
    
    // Then add all of the alerts back in
    NSArray *daysOfWeek = [[NSArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    
    for (NSString *time in [alertItem getAlertTimes]) {
        
        for (NSString *day in [alertItem getAlertDays]) {

            int dayNum = [daysOfWeek indexOfObject:day];

            NSLog(@"Time: %@", time);
            
            // Create a date for the notification
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"h:mm a"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:time];
            dateFromString = [dateFromString dateByAddingTimeInterval:(86400 * (dayNum+3))];
                        
            NSLog(@"Date: %@", dateFromString);
            
            NSMutableString *alertBody = [[NSMutableString alloc] init];
            [alertBody appendFormat:@"Time to take your %@", [[alertItem getLibraryItem] getBrand]];
            
            // Create and set properties of the UILocalNotification
            UILocalNotification *notif = [[UILocalNotification alloc] init];
            notif.repeatInterval = NSWeekCalendarUnit;
            notif.alertBody = alertBody;
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.fireDate = dateFromString;
            notif.alertAction = @"View";
            notif.soundName = UILocalNotificationDefaultSoundName;
            notif.applicationIconBadgeNumber += 1;
            
            // Use this code to store the ID in the userInfo dictionary
            NSArray *alertID = [[NSArray alloc] initWithObjects:[alertItem getAlertId], nil];
            NSArray *alertKey = [[NSArray alloc] initWithObjects:@"alertID", nil];
            notif.userInfo = [[NSDictionary alloc] initWithObjects:alertID forKeys:alertKey];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
            
        }
        
    }
    
}

- (void)saveEncodedData
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedAlertList = [NSKeyedArchiver archivedDataWithRootObject:alerts];
    [prefs setObject:encodedAlertList forKey:@"alertList"];
    
}

@end
