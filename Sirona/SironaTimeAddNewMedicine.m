//
//  SironaTimeAddNewMedicine.m
//  Sirona
//
//  Created by Catherine Lu on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaTimeAddNewMedicine.h"

@implementation SironaTimeAddNewMedicine

@synthesize medInfo;

// Returns the count of the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [medInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{

    
}

@end