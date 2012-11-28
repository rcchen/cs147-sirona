//
//  SironaTimeSelectMedicine.m
//  Sirona
//
//  Created by Roger Chen on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaTimeSelectMedicine.h"

#import "SironaTimeAddNewMedicine.h"
#import "SironaTimeSelectMedicineCellView.h"
#import "SironaLibraryList.h"
#import "SironaLibraryItem.h"

@implementation SironaTimeSelectMedicine

@synthesize medicines;
@synthesize item;
@synthesize previous_cell;
@synthesize alertList;

- (IBAction)addNewItem:(id)sender
{
    SironaTimeAddNewMedicine *stanm = [[SironaTimeAddNewMedicine alloc] init];
    [stanm setMedicines:medicines];
    [[self navigationController] pushViewController:stanm animated:YES];
}

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {

        UINavigationItem *n = [self navigationItem];
        [n setTitle:NSLocalizedString(@"My Medications", @"Application title")];
        
    }
    
    medicines = [[NSMutableArray alloc] init];
    
    // Create a new bar button item that will send
    // addNewItem: to ItemsViewController
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                            target:self
                            action:@selector(setMedicine:)];
    
    
    // Set this bar button item as the right item in the navigationItem
    [[self navigationItem] setRightBarButtonItem:bbi];
    
    
    [self refreshDisplay];
    
    return self;
    
}


// Returns the count of the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [medicines count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SironaLibraryItem *sli = [medicines objectAtIndex:[indexPath row]];
    SironaTimeSelectMedicineCellView *slcv = [tableView dequeueReusableCellWithIdentifier:@"SironaTimeSelectMedicineCellView"];
    [[slcv cellMain] setText:[sli getBrand]];
    [[slcv cellSecondary] setText:[sli getCategory]];
    slcv.accessoryType = UITableViewCellAccessoryNone;

    //UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];

    // If the medication was previously selected, set the checkmark
    if ([[[item getLibraryItem] getBrand] isEqualToString: [sli getBrand]]) {
        slcv.accessoryType = UITableViewCellAccessoryCheckmark;
        NSLog(@"%@", [item getLibraryItem]);
    }
    
    return slcv;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a pointer to the cell
        
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [item setLibraryItem:[medicines objectAtIndex:[indexPath row]]];
        
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
        
        [[self navigationController] popViewControllerAnimated:YES];

    }

    
    // Deselect the row when the operation is completed
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshDisplay
{
    
    [medicines removeAllObjects];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedCustomMedList = [prefs objectForKey:@"customMedList"];
    
    // If there are custom meds, they will show up in the list
    if (encodedCustomMedList) {
        NSMutableArray *customMeds = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedCustomMedList];
        for (SironaLibraryItem *sli in customMeds) {
            [medicines addObject:sli];
        }
    }
    
    [medicines sortUsingSelector:@selector(compare:)];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [[self tableView] reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"SironaTimeSelectMedicineCellView" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"SironaTimeSelectMedicineCellView"];
}

// Makes the table rows taller
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (IBAction)setMedicine:(id)sender
{
    
    SironaTimeAddNewMedicine *stanm = [[SironaTimeAddNewMedicine alloc] init];
    [stanm setItem:item];
    [stanm setAlertList:alertList];
    [[self navigationController] pushViewController:stanm animated:YES];
    
}

@end