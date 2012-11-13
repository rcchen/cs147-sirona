//
//  SironaTimeViewController.h
//  Sirona
//
//  Created by Roger Chen on 11/7/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SironaTimeEditAlertView.h"

@interface SironaTimeViewController : UITableViewController
{
    IBOutlet UITableView *alarmsTable;
}

@property NSMutableArray *alerts;

- (IBAction)addNewItem:(id)sender;

@end
