//
//  SironaLibraryViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaLibraryDetailViewController.h"
#import "SironaLibraryViewController.h"
#import "SironaLibraryList.h"
#import "SironaLibraryItem.h"
#import "SironaLibraryCellView.h"

@implementation SironaLibraryViewController

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
        [tbi setTitle:@"Library"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"96-book.png"];
        [tbi setImage:i];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:NSLocalizedString(@"Library", @"Application title")];

    }
    
    [self refreshDisplay];
    
    return self;
}

@synthesize medicines;

// Returns the count of the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[SironaLibraryList sharedLibrary] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SironaLibraryItem *sli = [[[SironaLibraryList sharedLibrary] allItems] objectAtIndex:[indexPath row]];
    SironaLibraryCellView *slcv = [tableView dequeueReusableCellWithIdentifier:@"SironaLibraryCellView"];
    [[slcv cellMain] setText:[sli getBrand]];
    [[slcv cellSecondary] setText:[sli getCategory]];
    return slcv;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SironaLibraryDetailViewController *sldvc = [[SironaLibraryDetailViewController alloc] init];
    
    NSArray *items = [[SironaLibraryList sharedLibrary] allItems];
    SironaLibraryItem *selectedItem = [items objectAtIndex:[indexPath row]];
    [sldvc setItem:selectedItem];
    
    [[self navigationController] pushViewController:sldvc animated:YES];
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
    
    for (NSDictionary *item in jsonArray) {
        
        // Create a new Sirona Library Item
        SironaLibraryItem *sli = [[SironaLibraryItem alloc] initWithMDataBrand:[item objectForKey:@"mdataBrand"] mdataCategory:[item objectForKey:@"mdataCategory"] mdataId:[item objectForKey:@"mdataId"] mdataName:[item objectForKey:@"mdataName"] mdataPrecautions:[item objectForKey:@"mdataPrecautions"] mdataSideEffects:[item objectForKey:@"mdataSideEffects"] mdataNotes:@""];
        
        [[SironaLibraryList sharedLibrary] createItem:sli];
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedCustomMedList = [prefs objectForKey:@"customMedList"];
    
    // If there are custom meds, they will show up in the list
    if (encodedCustomMedList) {
        NSMutableArray *customMeds = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedCustomMedList];
        for (SironaLibraryItem *sli in customMeds) {
            [[SironaLibraryList sharedLibrary] createItem:sli];
        }
    }
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
}

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    style = UITableViewStylePlain;
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

@end
