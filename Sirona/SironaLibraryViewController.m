//
//  SironaLibraryViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaMedicationDetailedViewController.h"
#import "SironaLibraryViewController.h"
#import "SironaLibraryList.h"
#import "SironaLibraryItem.h"
#import "SironaLibraryCellView.h"
#import "SironaTimeAddNewMedicine.h"

@implementation SironaLibraryViewController

@synthesize medicines;

- (IBAction)addNewItem:(id)sender
{
    SironaTimeAddNewMedicine *stanm = [[SironaTimeAddNewMedicine alloc] init];
    [[self navigationController] pushViewController:stanm animated:YES];
}

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        // Get the tab bar item and give it a label
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"My Meds"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"94-pill.png"];
        [tbi setImage:i];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:NSLocalizedString(@"My Meds", @"Application title")];
        
        medicines = [[NSMutableArray alloc] init];
        
        // Add button to add a new medicine
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        // Add edit button to the left
        self.navigationItem.leftBarButtonItem = self.editButtonItem;

        self.tableView.allowsSelection = NO;
        self.tableView.allowsSelectionDuringEditing = YES;
    }
    
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
    SironaLibraryCellView *slcv = [tableView dequeueReusableCellWithIdentifier:@"SironaLibraryCellView"];
    [[slcv cellMain] setText:[sli getName]];
    [[slcv cellSecondary] setText:[sli getDosage]];
    return slcv;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SironaMedicationDetailedViewController *smdvc = [[SironaMedicationDetailedViewController alloc] init];
    SironaLibraryItem *selectedItem = [medicines objectAtIndex:[indexPath row]];
    [smdvc setItem:selectedItem];
    
    [[self navigationController] pushViewController:smdvc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Check to make sure no alerts are using the medication
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
        
        // If there are alerts, make sure none use the medicine we want to delete
        if (encodedAlertList) {
            NSMutableArray *prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
            for (SironaAlertItem* alert in prefAlerts) {
                if ([[[alert getLibraryItem] getId] isEqualToString:[[medicines objectAtIndex:[indexPath row]] getId]]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot delete"
                                                                    message:@"Medication is used in an alarm"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            }
        }
        
        [medicines removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
    
}


// sets the editing that occurs when Edit is pressed
/*- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [self setEditing:editing animated:animated];
}*/

// Get medications from local storage
- (void)refreshDisplay
{
    [medicines removeAllObjects];
    
    NSLog(@"Before: %u", [medicines count]);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedCustomMedList = [prefs objectForKey:@"customMedList"];
    
    // If there are custom meds, they will show up in the list
    if (encodedCustomMedList) {
        NSMutableArray *customMeds = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedCustomMedList];
        for (SironaLibraryItem *sli in customMeds) {
            [medicines addObject:sli];
        }
    }
    
    [medicines sortUsingComparator:^(id one, id two) {
        SironaLibraryItem *itemOne = (SironaLibraryItem *)one;
        SironaLibraryItem *itemTwo = (SironaLibraryItem *)two;
        return [[itemOne getName] caseInsensitiveCompare:[itemTwo getName]];
    }];

    NSLog(@"After: %u", [medicines count]);
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshDisplay];
}

// Makes the table rows taller
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"SironaLibraryCellView" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"SironaLibraryCellView"];
    [self refreshDisplay];
}

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    style = UITableViewStylePlain;
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

// When user leaves the screen, saves the updated medicines list
- (void)viewWillDisappear:(BOOL)animated
{
    // Save encoded data to NSUserDefaults in case there were alerts that were deleted
    [self saveEncodedData];
}

- (void)saveEncodedData
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedAlertList = [NSKeyedArchiver archivedDataWithRootObject:medicines];
    [prefs setObject:encodedAlertList forKey:@"customMedList"];
    
}

@end
