//
//  SironaHomeOnboardingController.h
//  Sirona
//
//  Created by Roger Chen on 11/28/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SironaHomeOnboardingController : UIViewController
{
    __weak IBOutlet UIImageView *imageMiddle;
    __weak IBOutlet UIImageView *imageDose;
    __weak IBOutlet UIImageView *imageRepeat;
    __weak IBOutlet UIImageView *imageAddAlert;
    __weak IBOutlet UIImageView *imageAddMed;
}

- (IBAction)middlePress:(id)sender;
- (IBAction)dosePress:(id)sender;
- (IBAction)repeatPress:(id)sender;
- (IBAction)addalertPress:(id)sender;
- (IBAction)addmedPress:(id)sender;

@end
