//
//  SironaTimeViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/7/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaTimeEditAlertView.h"
#import "SironaTimeViewController.h"
#import "SironaTimeCellView.h"
#import "SironaAlertItem.h"

@implementation SironaTimeViewController

@synthesize alertList;

- (id)init
{
    
    self = [super init];
    
    if (self) {
        
        // Get the tab bar item and give it a label
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Alerts"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"10-medical.png"];
        [tbi setImage:i];
    
        // Pull in the alertlist from NSUserDefaults
        alertList = [[SironaAlertList alloc] init];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:NSLocalizedString(@"Alerts", @"Application title")];
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92.0f;
}

// Returns the count of the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [alertList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SironaTimeCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"SironaTimeCellView"];
    SironaAlertItem *sai = [alertList objectAtIndex:[indexPath row]];
    
    [[cell cellMain] setText:[[sai getLibraryItem] getName]];
    [[cell cellSecondary] setText:[[sai getLibraryItem] getDosage]];
    
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
    SironaAlertItem *selectedItem = [alertList objectAtIndex:[indexPath row]];
    [stevc setItem:selectedItem];
    [[self navigationController] pushViewController:stevc animated:YES];
    
}

- (IBAction)addNewItem:(id)sender
{
    
    SironaTimeEditAlertView *stevc = [[SironaTimeEditAlertView alloc] init];
    SironaAlertItem *newItem = [[SironaAlertItem alloc] init];
    [newItem setAlertId];
    //NSLog(@"The new alert ID is: %@", [newItem getAlertId]);
    [stevc setItem:newItem];
    [[self navigationController] pushViewController:stevc animated:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    for (SironaAlertItem *alertItem in [alertList allAlerts]) {
        [self setAllAlarms:alertItem];
    }
    
    for (UILocalNotification *old in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSLog(@"Alert for %@ at %@", [old.userInfo objectForKey:@"alertID"], [old fireDate]);
    }
    
    //[[self tableView] reloadData];
    
    if (![alertList count]) {

        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SironaAlertNoneView" owner:self options:nil];
        [self.navigationController.view addSubview:[nibs objectAtIndex:0]];

        // Add the SironaAlertNoneView subview here
    }

}

- (void)setAllAlarms:(SironaAlertItem *)alertItem
{
 
    
    // First delete all of the alarms associated with the alertItem
    for (UILocalNotification *old in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        // Cancel anything that matches the alertID
        if ([[old.userInfo objectForKey:@"alertID"] isEqualToString:[alertItem getAlertId]]) {
            NSLog(@"Removed alert for %@", [alertItem getAlertId]);
            [[UIApplication sharedApplication] cancelLocalNotification:old];
        }
        
    }
    
    // Then add all of the alerts back in
    NSArray *daysOfWeek = [[NSArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    
    for (NSString *time in [alertItem getAlertTimes]) {
        
        for (NSString *day in [alertItem getAlertDays]) {
            
            //NSLog(@"Count: %u", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
            
            int dayNum = [daysOfWeek indexOfObject:day];
            
            // Let's bring up the notification
            UILocalNotification *notif = [[UILocalNotification alloc] init];
            notif.repeatInterval = NSWeekCalendarUnit;
            
            // Create a date for the notification
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:time];
            dateFromString = [dateFromString dateByAddingTimeInterval:(86400 * ((dayNum+1) % 7))];
            
            //NSLog(@"String: %@, date: %@, daynum: %u", time, dateFromString, dayNum);
            
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.fireDate = dateFromString;
            
            NSMutableString *alertBody = [[NSMutableString alloc] init];
            [alertBody appendFormat:@"Time to take your %@", [[alertItem getLibraryItem] getName]];
            notif.alertBody = alertBody;
            
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

- (void)viewWillDisappear:(BOOL)animated
{

}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [alertList removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload {
    noneView = nil;
    [super viewDidUnload];
}
@end
