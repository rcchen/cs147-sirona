//
//  SironaLibraryViewController.h
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//
//  File name is misleading -- corresponds to "My Medications" view.
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
