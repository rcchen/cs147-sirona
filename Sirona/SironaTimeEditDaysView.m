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

- (IBAction)finishEditingDays:(id)sender
{
    
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
    NSString *value = [possibleDays objectAtIndex:[indexPath row]];
    NSLog(@"value: %@", value);
    UITableViewCell *utvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    [[utvc textLabel] setText:value];
    [utvc setUserInteractionEnabled:YES];
    //utvc.accessoryType = UITableViewCellAccessoryCheckmark;
    return utvc;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
    NSLog(@"Selected %@", cell);
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        NSLog(@"Not checked, changing to checked");
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        NSLog(@"Checked, changing to not checked");
        cell.accessoryType = UITableViewCellAccessoryNone;
    } [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = @"Repeat";
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
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
