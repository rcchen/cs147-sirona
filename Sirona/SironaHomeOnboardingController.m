//
//  SironaHomeOnboardingController.m
//  Sirona
//
//  Created by Roger Chen on 11/28/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaHomeOnboardingController.h"

@implementation SironaHomeOnboardingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    NSLog(@"Initialized %@", nibNameOrNil);
    
    if (self) {
        
        // Do some custom stuff
        //[imageMiddle setHidden:YES];
        [imageDose setHidden:YES];
        [imageRepeat setHidden:YES];
        [imageAddAlert setHidden:YES];
        [imageAddMed setHidden:YES];
        
    }
    
    return self;
    
}

- (IBAction)middlePress:(id)sender {
    
    [imageMiddle setHidden:YES];
    [imageDose setHidden:NO];
        
}

- (IBAction)dosePress:(id)sender {

    [imageDose setHidden:YES];
    [imageRepeat setHidden:NO];
    
}

- (IBAction)repeatPress:(id)sender {

    [imageRepeat setHidden:YES];
    [imageAddAlert setHidden:NO];
    
}

- (IBAction)addalertPress:(id)sender {

    [imageAddAlert setHidden:YES];
    [imageAddMed setHidden:NO];
    
}

- (IBAction)addmedPress:(id)sender {
    
    [[self navigationController] dismissModalViewControllerAnimated:YES];

}

- (void)viewDidUnload {
    
    imageMiddle = nil;
    imageDose = nil;
    imageRepeat = nil;
    imageAddAlert = nil;
    imageAddMed = nil;
    [super viewDidUnload];
    
}

@end
