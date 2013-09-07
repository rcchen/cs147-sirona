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
    
    // Special case for the daily label
    if ([indexPath row] == 0) {
        [[utvc textLabel] setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        if ([[item getAlertDays] count] == 7) // If all days are selected
            utvc.accessoryType = UITableViewCellAccessoryCheckmark;
    }
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
        
        // If daily is checked, then check all other days and add to alertDays
        if ([indexPath row] == 0) {
            UITableViewCell *otherCell;
            for (otherCell in [tableView visibleCells]) {
                if (otherCell.accessoryType == UITableViewCellAccessoryNone) {
                    otherCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    NSMutableArray *alertDays = [item getAlertDays];
                    [alertDays addObject:[[otherCell textLabel] text]];
                    [item setAlertDays:alertDays];
                }
            }
        } else {
            NSMutableArray *alertDays = [item getAlertDays];
            [alertDays addObject:[[cell textLabel] text]];
            [item setAlertDays:alertDays];
        }
    }
    
    // If it is already checked, uncheck it and remove from NSMutableArray
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSMutableArray *alertDays = [item getAlertDays];
        [alertDays removeObject:[[cell textLabel] text]];
        
        // If Daily is deselected
        if ([indexPath row] == 0) {
            UITableViewCell *otherCell;
            for (otherCell in [tableView visibleCells]) {
                otherCell.accessoryType = UITableViewCellAccessoryNone;
            }
            [alertDays removeAllObjects];
        }
        
        // Make sure daily is deselected if not all days are selected
        if ([alertDays count] < 7) {
            [tableView cellForRowAtIndexPath:0].accessoryType = UITableViewCellAccessoryNone;
            [tableView reloadData];
        }
        
        [item setAlertDays:alertDays];
        
    }
    
    // Add the item in
    [alertList addAlert:item];
    
    NSLog(@"AlertID: %@", [item getAlertId]);
    
    // Deselect the row when the operation is completed
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"Repeat";
        
        alertList = [[SironaAlertList alloc] init];
    }
    
    possibleDays = [[NSMutableArray alloc] initWithObjects:@"Daily", @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    
    return self;
}

@end
