//
//  SironaTimeEditDaysView.h
//  Sirona
//
//  Created by Roger Chen on 11/11/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SironaTimeEditDaysView : UITableViewController

@property NSMutableArray *possibleDays;

- (IBAction)finishEditingDays:(id)sender;

@end
