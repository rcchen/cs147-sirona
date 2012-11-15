//
//  SironaHomeViewControllerB.m
//  Sirona
//
//  Created by Roger Chen on 11/14/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaHomeViewControllerB.h"

@implementation SironaHomeViewControllerB

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    
    // Call the superclass' designated initializer
    self = [super initWithNibName:nil bundle:nil];
        
    // If it exists, then we can customize it
    if (self) {
        
        // Get the tab bar item and give it a label
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Home"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"53-house.png"];
        [tbi setImage:i];
        
    }
    
    return self;
    
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)viewDidAppear:(BOOL)animated
{
    
    UIViewController* c = [[UIViewController alloc] initWithNibName:@"SironaAlertNoneView" bundle:nil];
    UIView *overlayNone = [c view];
    overlayNone.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:overlayNone];
    
}


@end
