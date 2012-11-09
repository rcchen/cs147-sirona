//
//  SironaLibraryViewController.h
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SironaLibraryDetailViewController.h"
#import "SironaLibraryCellView.h"

@interface SironaLibraryViewController : UITableViewController
{
    IBOutlet UITableView *medicineTable;
}

@property NSMutableArray *medicines;

- (void)refreshDisplay;
- (IBAction)addNewItem:(id)sender;

@end
