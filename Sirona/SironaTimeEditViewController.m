//
//  SironaTimeEditViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/9/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaTimeEditViewController.h"
#import "SironaTimeEditDaysView.h"
#import "SironaAlertItem.h"

@implementation SironaTimeEditViewController

@synthesize item;
@synthesize alarmSettings;

// Returns the count of the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [alarmSettings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *value = [alarmSettings objectAtIndex:[indexPath row]];
    NSLog(@"value: %@", value);
    UITableViewCell *utvc;
    if (value == @"Snooze") {
        utvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        [[utvc textLabel] setText:value];
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        utvc.accessoryView = switchview;
    } else {
        utvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        [[utvc textLabel] setText:value];
        [[utvc detailTextLabel] setText:@"Value"];
        utvc.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return utvc;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedItem = [alarmSettings objectAtIndex:[indexPath row]];
    NSLog(@"Selected %@", selectedItem);
    if (selectedItem == @"Repeat") {
        SironaTimeEditDaysView *stedv = [[SironaTimeEditDaysView alloc] init];
        // Set the current days to the days that are currently selected
        // Actually just make sure the entire SironaAlertItem pointer gets copied over
        [[self navigationController] pushViewController:stedv animated:YES];
    }
}

- (void)setItem:(SironaAlertItem *)theItem
{
    item = theItem;
    [[self navigationItem] setTitle:[[item getLibraryItem] getBrand]];
}

- (void)viewDidUnload {
    dayPicker = nil;
    alertSettings = nil;
    datePicker = nil;
    setAlert = nil;
    [super viewDidUnload];
}

- (IBAction)scheduleAlarm:(id)sender
{
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    // Grab the picker time, floor func to reset seconds to 0
    NSDate *pickerDate = [datePicker date];
    NSTimeInterval time = floor([pickerDate timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    pickerDate = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    
    // Set the local notification
    localNotif.fireDate = pickerDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    NSLog(@"Scheduled for %@", pickerDate);
    
    // It's an alert of some sort that we want to schedule
    localNotif.alertBody = @"Time to take your Vicodin!";
    localNotif.alertAction = @"View";
    localNotif.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    alarmSettings = [[NSMutableArray alloc] initWithObjects:@"Repeat", @"Sound", @"Snooze", @"Label", @"Times", nil];
    
    NSLog(@"Item: %@", item);

    if (!item) {
        NSLog(@"No item");
        self.title = @"Add new alert";
    }
    
    return self;
}


@end
