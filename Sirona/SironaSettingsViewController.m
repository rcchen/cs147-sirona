//
//  SironaSettingsViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaSettingsViewController.h"

@implementation SironaSettingsViewController

@synthesize settings;

// Returns the count of the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [settings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Initialize the user settings up here
    
    NSString *value = [settings objectAtIndex:[indexPath row]];
    UITableViewCell *utvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    [[utvc textLabel] setText:value];
    if ([value isEqual: @"Sound"]) {
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        utvc.accessoryView = switchview;
    }
    
    //UISwitch *test = [utvc accessoryView];
    //[test state];
    
    return utvc;
    
}

// Disallows table cells to be selected
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    
    // Call the superclass' designated initializer
    self = [super initWithNibName:nil bundle:nil];
    
    // If it exists, then we can customize it
    if (self) {
        
        // Get the tab bar item and give it a label
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Settings"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"19-gear.png"];
        [tbi setImage:i];
        
        
    }
    
    settings = [[NSMutableArray alloc] initWithObjects:@"Sound", @"Alert", nil];

    UINavigationItem *n = [self navigationItem];
    [n setTitle:NSLocalizedString(@"Settings", @"Application title")];
    
    return self;
    
}

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    style = UITableViewStyleGrouped;
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

@end
