//
//  SironaHomeNeueView.m
//  Sirona
//
//  Created by Roger Chen on 11/27/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaHomeNeueView.h"

#import "SironaTimeEditAlertView.h"
#import "SironaTimeAddNewMedicine.h"
#import "SironaHomeOnboardingController.h"

@implementation SironaHomeNeueView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Get the tab bar item and give it a label
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Home"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"53-house.png"];
        [tbi setImage:i];
        
        // Set the navigation item title as well
        UINavigationItem *n = [self navigationItem];
        [n setTitle:NSLocalizedString(@"Home", @"Application title")];
        
        // Boolean key for seeing the tutorial
        
        
        
        /*if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenTutorial"]) {
            
            // do something
            NSLog(@"Haven't seen the tutorial yet");
            
            // Handles the overlay
            UIViewController* c = [[UIViewController alloc] initWithNibName:@"SironaHomeOnboardingView" bundle:nil];
            UIView *overlayNone = [c view];
            //overlayNone.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            [self.view addSubview:overlayNone];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenTutorial"];
            
        }*/
        
        //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasSeenTutorial"];

    }
    
    return self;
    
}

- (IBAction)onTimePress:(id)sender {
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^(void) {
                         CGPoint initPoint = timeCircle.frame.origin;
                         CGSize initSize = timeCircle.frame.size;
                         timeCircle.frame = CGRectMake(80, 100, 163, 163);
                         timeCircle.frame = CGRectMake(initPoint.x, initPoint.y, initSize.width, initSize.height);
                    }completion:NULL];
    
}

- (IBAction)onNextPress:(id)sender {
    
    NSLog(@"Pressed the next medication");
    
}

- (IBAction)onAddAlert:(id)sender {
    
    NSLog(@"Pressed the add alert button");
    
    SironaTimeEditAlertView *stevc = [[SironaTimeEditAlertView alloc] init];
    SironaAlertItem *newItem = [[SironaAlertItem alloc] init];
    [newItem setAlertId];
    [stevc setItem:newItem];
    [[self navigationController] pushViewController:stevc animated:YES];
    
}

- (IBAction)onAddMed:(id)sender {
    
    NSLog(@"Pressed the add medication button");
    
    // Push the add new medicine view controller
    SironaTimeAddNewMedicine *stanm = [[SironaTimeAddNewMedicine alloc] init];
    [[self navigationController] pushViewController:stanm animated:YES];
    
}

- (void)displayFirstMessage
{
    
    SironaHomeOnboardingController *shoc = [[SironaHomeOnboardingController alloc] init];
    [[self navigationController] presentModalViewController:shoc animated:YES];
    
}

- (void)viewDidLoad {

    // NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    // NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    


    
    [medTitle setText:@"Vitamins"];
    [medDescription setText:@"Remember to take after each meal"];
    [timeNumber setText:@"23"];
    [timeUnits setText:@"minutes"];
    [medDosage setText:@"2 pills"];
    [medRepetitions setText:@"3 times"];
    

    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool firstTime = [prefs integerForKey:@"firstLaunch"];
    
    if (!firstTime) {
        [self displayFirstMessage];
        [prefs setBool:YES forKey:@"firstLaunch"];
    }
    
}

- (void)viewDidUnload {
    
    timeCircle = nil;
    medTitle = nil;
    medDescription = nil;
    timeNumber = nil;
    timeUnits = nil;
    medDosage = nil;
    medRepetitions = nil;
    [super viewDidUnload];
    
}

@end
