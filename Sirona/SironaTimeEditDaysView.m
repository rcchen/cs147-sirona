//
//  SironaTimeEditDaysView.m
//  Sirona
//
//  Created by Roger Chen on 11/11/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaTimeEditDaysView.h"
#import "SironaAlertItem.h"

@implementation SironaTimeEditDaysView

@synthesize possibleDays;
@synthesize item;
@synthesize alertList;

// Returns the count of the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [possibleDays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Initialize a UITableViewCell with the string
    NSString *value = [possibleDays objectAtIndex:[indexPath row]];
    UITableViewCell *utvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    [[utvc textLabel] setText:value];
    [utvc setUserInteractionEnabled:YES];
    
    // If the item already contains the day, set the checkmark
    if ([[item getAlertDays] containsObject:value])
        utvc.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Return the formatted table cell
    return utvc;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Get a pointer to the cell
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
    
    // If it is not checked yet, check it and add it to the NSMutableArray
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSMutableArray *alertDays = [item getAlertDays];
        [alertDays addObject:[[cell textLabel] text]];
        [item setAlertDays:alertDays];
    }
    
    // If it is checked, uncheck it and remove from NSMutableArray
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSMutableArray *alertDays = [item getAlertDays];
        [alertDays removeObject:[[cell textLabel] text]];
        [item setAlertDays:alertDays];
    }
    
    
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
    
    // Deselect the row when the operation is completed
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"Repeat";

    }
    
    possibleDays = [[NSMutableArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    
    return self;
}

@end
