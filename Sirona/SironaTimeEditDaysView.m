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

- (IBAction)finishEditingDays:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
        
    // Deselect the row when the operation is completed
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"Repeat";
        
        // Bar button for "Done"
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                target:self
                                action:@selector(finishEditingDays:)];
        [[self navigationItem] setRightBarButtonItem:bbi];

    }
    
    possibleDays = [[NSMutableArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    
    return self;
}

@end
