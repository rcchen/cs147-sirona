//
//  SironaTimeViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/7/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaTimeEditViewController.h"
#import "SironaTimeViewController.h"
#import "SironaAlertList.h"
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
    return [[[SironaAlertList sharedAlerts] allAlerts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    SironaAlertItem *sai = [[[SironaAlertList sharedAlerts] allAlerts] objectAtIndex:[indexPath row]];
    NSLog(@"row: %@", indexPath);
    [[cell textLabel] setText:[[sai getLibraryItem] getBrand]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SironaTimeEditViewController *stevc = [[SironaTimeEditViewController alloc] init];
    NSArray *items = [[SironaAlertList sharedAlerts] allAlerts];
    SironaAlertItem *selectedItem = [items objectAtIndex:[indexPath row]];
    [stevc setItem:selectedItem];
    
    [[self navigationController] pushViewController:stevc animated:YES];
}

- (IBAction)addNewItem:(id)sender
{
    SironaTimeEditViewController *stevc = [[SironaTimeEditViewController alloc] init];
    SironaAlertItem *newItem = [[SironaAlertItem alloc] init];
    [stevc setItem:newItem];
    [[self navigationController] pushViewController:stevc animated:YES];
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
