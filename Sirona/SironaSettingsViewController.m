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
    
    NSString *value = [settings objectAtIndex:[indexPath row]];
    NSLog(@"value: %@", value);
    UITableViewCell *utvc = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    [[utvc textLabel] setText:value];
    if (value == @"Sound") {
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        utvc.accessoryView = switchview;
    }
    return utvc;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
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
    
    settings = [[NSMutableArray alloc] initWithObjects:@"Sound", @"Alert", @"Cloud sync", nil];
    
    for (NSString* str in settings)
        NSLog(@"%@", str);
    
    UINavigationItem *n = [self navigationItem];
    [n setTitle:NSLocalizedString(@"Settings", @"Application title")];
    
    return self;
    
}

@end
