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
    }
    
    // Covers the cases that require replaceable strings on the right side
    else {
        
        // Allocate memory for the table cell and initialize with default styles
        utvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        [[utvc textLabel] setText:value];
        
        // Sets the text on the right side of the Repeat cell
        if (value == @"Repeat") {
            
            NSMutableArray *days = [item getAlertDays];
            NSMutableString *daysLabel = [[NSMutableString alloc] init];
            
            // If there are no days selected, print never
            if (![days count]) {
                [daysLabel appendString:@"Never"];
            }
            
            // Otherwise, figure out how to print based on this
            else {
                
                // If there are seven days, print Every day
                if ([days count] == 7)
                    [daysLabel appendString:@"Daily"];
                
                // If only Saturday and Sunday are selected, replace with Weekends
                else if ([days containsObject:@"Saturday"] && [days containsObject:@"Sunday"])
                    [daysLabel appendString:@"Weekends"];
                
                // If Saturday and Sunday are not selected and there are 5 days, replace with Weekdays
                else if ([days count] == 5 && ![days containsObject:@"Saturday"] && ![days containsObject:@"Sunday"])
                    [daysLabel appendString:@"Weekdays"];
                
                // Otherwise do the default print with prefixes
                else {
                    for (NSString* day in days) {
                        [daysLabel appendFormat:@"%@ ", [day substringToIndex:3]];
                    }
                }

            }
            
            [[utvc detailTextLabel] setText:daysLabel];
            
        }
        
        // Sets the text on the right side of the Times cell
        if (value == @"Times") {
            
            NSMutableArray *times = [item getAlertTimes];
            NSMutableString *timesLabel = [[NSMutableString alloc] init];
            
            if (![times count])
                [timesLabel appendString:@"None"];
            
            else
                [timesLabel appendFormat:@"%u times", [times count]];
            
            [[utvc detailTextLabel] setText:timesLabel];
        
        }
        
        // Add the disclosure indicator (chevron) on the right
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
        [stedv setItem:item];
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

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

@end
