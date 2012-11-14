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
        [n setTitle:NSLocalizedString(@"Medication", @"Application title")];
        
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
    

    //UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];

    // If the medication was previously selected, set the checkmark
    if ([[[item getLibraryItem] getBrand] isEqualToString: [sli getBrand]]) {
        slcv.accessoryType = UITableViewCellAccessoryCheckmark;
        NSLog(@"%@", [item getLibraryItem]);
    }
    
    /*if ([previous_cell isEqual: slcv])
        slcv.accessoryType = UITableViewCellAccessoryCheckmark;*/
    
    return slcv;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a pointer to the cell
        
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [item setLibraryItem:[medicines objectAtIndex:[indexPath row]]];
        
        /*if (previous_cell) {
            previous_cell.accessoryType = UITableViewCellAccessoryNone;
        }
        previous_cell = cell;*/
        
        [[self navigationController] popViewControllerAnimated:YES];

    }

    
    // Deselect the row when the operation is completed
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshDisplay
{
    
    // Get the data from the endpoint
    NSURL *url = [NSURL URLWithString:@"http://cs147.adamantinelabs.com/get-medications.php"];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    // Serialize the returned data into a JSON array
    NSError *jsonError;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
    // Add something here to catch the error
    
    for (NSDictionary *med in jsonArray) {
        
        // Create a new Sirona Library Item
        SironaLibraryItem *sli = [[SironaLibraryItem alloc] initWithMDataBrand:[med objectForKey:@"mdataBrand"] mdataCategory:[med objectForKey:@"mdataCategory"] mdataId:[med objectForKey:@"mdataId"] mdataName:[med objectForKey:@"mdataName"] mdataPrecautions:[med objectForKey:@"mdataPrecautions"] mdataSideEffects:[med objectForKey:@"mdataSideEffects"] mdataNotes:@""];
        
        [medicines addObject:sli];

    }
    
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

- (IBAction)setMedicine:(id)sender
{
    
    SironaTimeAddNewMedicine *stanm = [[SironaTimeAddNewMedicine alloc] init];
    //SironaAlertItem *newItem = [[SironaAlertItem alloc] init];
    //[stevc setItem:newItem];
    //[stevc setAlertList:alerts];
    [[self navigationController] pushViewController:stanm animated:YES];
    
}

@end