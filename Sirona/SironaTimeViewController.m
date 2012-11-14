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

@synthesize alerts;

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
        // Get the tab bar item and give it a label
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"My Meds"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"10-medical.png"];
        [tbi setImage:i];
    
        // Pull in the alerts from NSUserDefaults
        alerts = [[NSMutableArray alloc] init];
        //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        //alerts = [prefs objectForKey:@"userAlerts"];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:NSLocalizedString(@"Alarms", @"Application title")];
        
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
    return [alerts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SironaTimeCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"SironaTimeCellView"];
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

- (IBAction)addNewItem:(id)sender
{
    
    SironaTimeEditAlertView *stevc = [[SironaTimeEditAlertView alloc] init];
    SironaAlertItem *newItem = [[SironaAlertItem alloc] init];
    [newItem setAlertId];
    //NSLog(@"The new alert ID is: %@", [newItem getAlertId]);
    [stevc setItem:newItem];
    [stevc setAlertList:alerts];
    [[self navigationController] pushViewController:stevc animated:YES];

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
        
    NSLog(@"Alert count: %u", [alerts count]);
    
    for (SironaAlertItem *alertItem in alerts) {
        [self setAllAlarms:alertItem];
    }
    
    for (UILocalNotification *old in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSLog(@"Alert for %@ at %@", [old.userInfo objectForKey:@"alertID"], [old fireDate]);
    }
    
    [[self tableView] reloadData];

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
            [alertBody appendFormat:@"Time to take your %@", [[alertItem getLibraryItem] getBrand]];
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

// Saves the encoded data into NSUserDefaults
- (void)saveEncodedData
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedAlertList = [NSKeyedArchiver archivedDataWithRootObject:alerts];
    [prefs setObject:encodedAlertList forKey:@"alertList"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Save encoded data to NSUserDefaults in case there were alerts that were deleted
    [self saveEncodedData];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [alerts removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"SironaTimeCellView" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"SironaTimeCellView"];
}

/*
- (IBAction)scheduleAlarm:(id)sender
{

    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    // Grab the picker time, floor func to reset seconds to 0
    NSDate *pickerDate = [self.datePicker date];
    NSTimeInterval time = floor([pickerDate timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    pickerDate = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    
    // Set the local notification
    localNotif.fireDate = pickerDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    NSLog(@"Scheduled for %@", pickerDate);
    
    // It's an alert of some sort that we want to schedule
    localNotif.alertBody = @"Yay an alert!";
    localNotif.alertAction = @"View";
    localNotif.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
}
*/

@end
