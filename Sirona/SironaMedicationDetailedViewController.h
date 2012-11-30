//
//  SironaMedicationDetailedViewController.h
//  Sirona
//
//  Created by Catherine Lu on 11/28/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SironaAlertItem.h"

@interface SironaMedicationDetailedViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>
{
    
}

//@property NSMutableArray *medicines;
@property NSArray *medicineSections;
@property NSMutableArray *textFields;
@property NSArray *placeholderText;
@property NSMutableArray *inputtedText;
@property (nonatomic, strong)SironaLibraryItem *item;
@property NSMutableArray *alertList;

// Default setter
- (void)setMedicines:(NSMutableArray *)medicines;

@end
