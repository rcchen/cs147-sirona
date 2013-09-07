//
//  SironaTimeViewController.h
//  Sirona
//
//  Created by Roger Chen on 11/7/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SironaTimeEditAlertView.h"

@interface SironaTimeViewController : UIViewController <UITableViewDelegate, UITableViewDelegate>
{
    IBOutlet UITableView *alarmsTable;
    IBOutlet UIView *noneView;
}

@property SironaAlertList *alertList;

- (IBAction)addNewItem:(id)sender;

@end
