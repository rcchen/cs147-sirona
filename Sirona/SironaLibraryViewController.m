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

@implementation SironaLibraryViewController

@synthesize medicines;

- (IBAction)addNewItem:(id)sender
{
    
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

@end
