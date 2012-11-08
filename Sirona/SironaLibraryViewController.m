//
//  SironaLibraryViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaLibraryViewController.h"
#import "SironaLibraryList.h"
#import "SironaLibraryItem.h"

@implementation SironaLibraryViewController

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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    SironaLibraryItem *sli = [[[SironaLibraryList sharedLibrary] allItems] objectAtIndex:[indexPath row]];
    NSLog(@"row: %@", indexPath);
    [[cell textLabel] setText:[sli getBrand]];
    return cell;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    
    // Call the superclass' designated initializer
    self = [super initWithNibName:nil bundle:nil];
    
    // If it exists, then we can customize it
    if (self) {
        
        // Get the tab bar item and give it a label
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Library"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"96-book.png"];
        [tbi setImage:i];
        
    }
    
    // Get the data from the endpoint
    NSURL *url = [NSURL URLWithString:@"http://cs147.adamantinelabs.com/get-medications.php"];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    // Serialize the returned data into a JSON array
    NSError *jsonError;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    
    for (NSDictionary *item in jsonArray) {
        
        // Create a new Sirona Library Item
        SironaLibraryItem *sli = [[SironaLibraryItem alloc] initWithMDataBrand:[item objectForKey:@"mdataBrand"] mdataCategory:[item objectForKey:@"mdataCategory"] mdataId:[item objectForKey:@"mdataId"] mdataName:[item objectForKey:@"mdataName"] mdataPrecautions:[item objectForKey:@"mdataPrecautions"] mdataSideEffects:[item objectForKey:@"mdataSideEffects"]];
        
        [[SironaLibraryList sharedLibrary] createItem:sli];
        
        NSLog(@"Added: %@", [item objectForKey:@"mdataBrand"]);

    }
    
    return self;
    
}

@end
