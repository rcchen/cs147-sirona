//
//  SironaTimeEditAlertView.m
//  Sirona
//
//  Created by Roger Chen on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaTimeEditAlertView.h"
#import "SironaTimeEditDaysView.h"
#import "SironaTimeEditTimesView.h"
#import "SironaTimeSelectMedicine.h"

#import "SironaAlertList.h"

@implementation SironaTimeEditAlertView

@synthesize item;
@synthesize alertList;
@synthesize alertSettings;

- (IBAction)saveAlert:(id)sender{
    
    // Set the alerts from NSUserDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
    if (encodedAlertList) {
        NSMutableArray *prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
        alertList = prefAlerts;
    }
    
    // Remove the object if it exists already
    for (SironaAlertItem *sai in alertList) {
        NSLog(@"AlertID: %@, Item: %@", sai.getAlertId, item.getAlertId);
        if ([[sai getAlertId] isEqualToString:[item getAlertId]]) {
            NSLog(@"Removing duplicate object");
            [alertList removeObject:sai];
            break;
        }
    }
    
    // Add the item in
    [alertList addObject:item];
    
    NSLog(@"AlertID: %@", [item getAlertId]);
    
    // Now save it to NSUserDefaults
    encodedAlertList = [NSKeyedArchiver archivedDataWithRootObject:alertList];
    [prefs setObject:encodedAlertList forKey:@"alertList"];
    
    // Pop back to the previous view controller
    [[self navigationController] popViewControllerAnimated:YES];
    
}

// Returns the count of the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [alertSettings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *value = [alertSettings objectAtIndex:[indexPath row]];
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
                else if ([days containsObject:@"Saturday"] && [days containsObject:@"Sunday"] && [days count] == 2)
                    [daysLabel appendString:@"Weekends"];
                
                // If Saturday and Sunday are not selected and there are 5 days, replace with Weekdays
                else if ([days count] == 5 && ![days containsObject:@"Saturday"] && ![days containsObject:@"Sunday"])
                    [daysLabel appendString:@"Weekdays"];
                
                // Otherwise do the default print with prefixes
                else {
                    
                    // Create an array of possible days
                    // TODO: Replace with static const
                    NSMutableArray *possibleDays = [[NSMutableArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
                    
                    // This is to make sure that days show up in the right order
                    for (int i = 0; i < [possibleDays count]; i++) {
                        NSString *day = [possibleDays objectAtIndex:i];
                        if ([days containsObject:day]) {
                            [daysLabel appendFormat:@"%@ ", [day substringToIndex:3]];
                        }
                    }
                    
                }
                
            }
            
            [[utvc detailTextLabel] setText:daysLabel];
            
        }
        
        // Sets the text on the right side of the Medication cell
        if (value == @"Medication") {
            SironaLibraryItem *med = [item getLibraryItem];
            NSMutableString *medLabel = [[NSMutableString alloc] init];
            if (med) {
                [medLabel appendFormat:@"%@", [med getBrand]];
            }
            
            [[utvc detailTextLabel] setText:medLabel];
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
    NSString *selectedItem = [alertSettings objectAtIndex:[indexPath row]];
    
    // Covers the selection of Repeat to push SironaTimeEditDaysView
    if (selectedItem == @"Repeat") {
        SironaTimeEditDaysView *stedv = [[SironaTimeEditDaysView alloc] init];
        // Set the current days to the days that are currently selected
        // Actually just make sure the entire SironaAlertItem pointer gets copied over
        [stedv setItem:item];
        [[self navigationController] pushViewController:stedv animated:YES];
    }
    
    // Covers the selection of Times to push SironaTimeEditTimesView
    else if (selectedItem == @"Times") {
        SironaTimeEditTimesView *stetv = [[SironaTimeEditTimesView alloc] init];
        [stetv setItem:item];
        [[self navigationController] pushViewController:stetv animated:YES];
    }
    
    // Covers the selection of Medication to push SironaTimeSelectMedicineView
    else if (selectedItem == @"Medication") {
        SironaTimeSelectMedicine *stsm = [[SironaTimeSelectMedicine alloc] init];
        [stsm setItem:item];
        [[self navigationController] pushViewController:stsm animated:YES];
    }
    
}

- (void)viewDidLoad {
    
    // Get the name of the brand of the library item
    NSString *brand = [[item getLibraryItem] getBrand];
    
    // If there is no brand, then set the title to new alert
    if (!brand)
        self.title = @"New alert";
    
    // Otherwise use the brand name of the item as the title
    else
        self.title = brand;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
        
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                target:self
                                action:@selector(saveAlert:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        
    }
    
    // Initialize the objects that show up in the TableView
    alertSettings = [[NSMutableArray alloc] initWithObjects:@"Medication", @"Repeat", @"Times", nil];
    
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
    
    // Get the name of the brand of the library item
    NSString *brand = [[item getLibraryItem] getBrand];
    
    // If there is no brand, then set the title to new alert
    if (!brand)
        self.title = @"New alert";
    
    // Otherwise use the brand name of the item as the title
    else
        self.title = brand;
}


@end
