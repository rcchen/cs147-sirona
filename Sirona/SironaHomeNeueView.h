//
//  SironaHomeNeueView.h
//  Sirona
//
//  Created by Roger Chen on 11/27/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SironaHomeNeueView : UIViewController
{
    __weak IBOutlet UIImageView *timeCircle;
    __weak IBOutlet UILabel *medTitle;
    __weak IBOutlet UILabel *medDescription;
    __weak IBOutlet UILabel *timeNumber;
    __weak IBOutlet UILabel *timeUnits;
    __weak IBOutlet UILabel *medDosage;
    __weak IBOutlet UILabel *medRepetitions;
}

- (IBAction)onTimePress:(id)sender;
- (IBAction)onNextPress:(id)sender;
- (IBAction)onAddAlert:(id)sender;
- (IBAction)onAddMed:(id)sender;

@end
