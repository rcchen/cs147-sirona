//
//  SironaTimeViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/7/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaTimeEditAlertView.h"
#import "SironaTimeViewController.h"
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

// Returns the count of the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [alerts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    SironaAlertItem *sai = [alerts objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:@"Lol an item"];
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
    [stevc setItem:newItem];
    [stevc setAlertList:alerts];
    [[self navigationController] pushViewController:stevc animated:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
    if (encodedAlertList) {
        NSMutableArray *prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
        alerts = prefAlerts;
    }
    
    // This is where we want to clear all the notifications and whatnot
        
    NSLog(@"Alert count: %u", [alerts count]);
    
    for (SironaAlertItem *alertItem in alerts)
        [self setAllAlarms:alertItem];
    
    [[self tableView] reloadData];

}

- (void)setAllAlarms:(SironaAlertItem *)alertItem
{
    NSLog(@"In here");
    
    // First delete all of the alarms associated with the alertItem
    for (UILocalNotification *old in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        // Implement some sort of thing with keys
        
    }
    
    // This is so shoddy :/
    NSArray *daysOfWeek = [[NSArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    
    for (NSString *time in [alertItem getAlertTimes]) {
        for (NSString *day in [alertItem getAlertDays]) {
            
            int dayNum = [daysOfWeek indexOfObject:day];
            NSLog(@"%@ on %@ (%u)", time, day, dayNum);
            
            /*
            UILocalNotification *notif = [[UILocalNotification alloc] init];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            notif.repeatInterval = kCFCalendarUnitWeekday;
            */
             
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
