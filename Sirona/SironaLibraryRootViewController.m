//
//  SironaLibraryRootViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/9/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaLibraryRootViewController.h"

@implementation SironaLibraryRootViewController

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
    
    return self;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
