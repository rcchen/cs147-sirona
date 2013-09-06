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
@synthesize alertSettings;

- (IBAction)saveAlert:(id)sender
{
    if (![item getLibraryItem]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Saving"
                                                        message:@"Please specify the medication"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([[item getAlertDays] count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Saving"
                                                        message:@"Please specify what days to repeat the alarm"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([[item getAlertTimes] count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Saving"
                                                        message:@"Please specify the alarm times"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
    //NSLog(@"NSData: %@", encodedAlertList);
    NSMutableArray *alerts = [[NSMutableArray alloc] init];
    if (encodedAlertList) {
        NSLog(@"Encoded alert list found");
        NSMutableArray *prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
        //NSLog(@"PrefAlerts: %@", prefAlerts);
        alerts = prefAlerts;
    } else {
        NSLog(@"No alert list found");
        alerts = [[NSMutableArray alloc] init];
        [alerts addObject:item];
        encodedAlertList = [NSKeyedArchiver archivedDataWithRootObject:alerts];
        [prefs setObject:encodedAlertList forKey:@"alertList"];
    } [self.navigationController popViewControllerAnimated:true];
    //NSLog(@"AlertList: %@", alerts);
}

// Returns the count of the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (!item)
        NSLog(@"item is null");
    else
        NSLog(@"alert id: %@", [item getAlertId]);
    return [alertSettings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *value = [alertSettings objectAtIndex:[indexPath row]];
    UITableViewCell *utvc;
    if ([value isEqual: @"Snooze"]) {
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
        if ([value isEqual: @"Repeat"]) {
            
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
                    for (int i = 0; i < [days count]; i++) {
                        [daysLabel appendFormat:@"%@ ", [[days objectAtIndex:i] substringToIndex:3]];
                    }
                }
                
            }
            
            [[utvc detailTextLabel] setText:daysLabel];
            
        }
        
        // Sets the text on the right side of the Medication cell
        if ([value isEqual: @"Medication"]) {
            SironaLibraryItem *med = [item getLibraryItem];
            NSMutableString *medLabel = [[NSMutableString alloc] init];
            if (med) {
                [medLabel appendFormat:@"%@", [med getName]];
            }
            
            [[utvc detailTextLabel] setText:medLabel];
        }
        
        
        // Sets the text on the right side of the Times cell
        if ([value isEqual: @"Times"]) {
            
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
    if ([selectedItem isEqual: @"Repeat"]) {
        SironaTimeEditDaysView *stedv = [[SironaTimeEditDaysView alloc] init];
        // Set the current days to the days that are currently selected
        // Actually just make sure the entire SironaAlertItem pointer gets copied over
        [stedv setItem:item];
        [[self navigationController] pushViewController:stedv animated:YES];
    }
    
    // Covers the selection of Times to push SironaTimeEditTimesView
    else if ([selectedItem isEqual: @"Times"]) {
        SironaTimeEditTimesView *stetv = [[SironaTimeEditTimesView alloc] init];
        [stetv setItem:item];
        [[self navigationController] pushViewController:stetv animated:YES];
    }
    
    // Covers the selection of Medication to push SironaTimeSelectMedicineView
    else if ([selectedItem isEqual: @"Medication"]) {
        SironaTimeSelectMedicine *stsm = [[SironaTimeSelectMedicine alloc] init];
        [stsm setItem:item];
        [[self navigationController] pushViewController:stsm animated:YES];
    }
    
}

- (void)viewDidLoad {
    
    // Get the name of the brand of the library item
    NSString *name = [[item getLibraryItem] getName];
    
    // If there is no brand, then set the title to new alert
    if (!name)
        self.title = @"New alert";
    
    // Otherwise use the brand name of the item as the title
    else
        self.title = name;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
        
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    
    if (self) {
        
        // Initialize the objects that show up in the TableView
        alertSettings = [[NSMutableArray alloc] initWithObjects:@"Medication", @"Repeat", @"Times", nil];
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Save"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(saveAlert:)];
        self.navigationItem.rightBarButtonItem = saveButton;
        
    }
    
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
    
    // Get the name of the brand of the library item
    NSString *name = [[item getLibraryItem] getName];
    
    // If there is no brand, then set the title to new alert
    if (!name)
        self.title = @"New alert";
    
    // Otherwise use the brand name of the item as the title
    else
        self.title = name;
}


@end
