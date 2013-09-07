//
//  SironaTimeSelectMedicine.h
//  Sirona
//
//  Created by Roger Chen on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SironaAlertItem.h"
#import "SironaAlertList.h"
#import "SironaLibraryCellView.h"

@interface SironaTimeSelectMedicine : UITableViewController
{
    IBOutlet UITableView *medicineTable;
}

@property NSMutableArray *medicines;
@property SironaAlertItem *item;
@property UITableViewCell *previous_cell;
@property SironaAlertList *alertList;

- (void)setItem:(SironaAlertItem *)item;
- (void)refreshDisplay;
- (IBAction)addNewItem:(id)sender;
- (void)setAlertList:(SironaAlertList *)alertList;

@end
