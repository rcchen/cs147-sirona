//
//  SironaHomeViewController.h
//  Sirona
//
//  Created by Roger Chen on 11/7/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SironaHomeViewController : UIViewController
{
    
    // IBOutlets for the circles
    IBOutlet UIImageView *circleOne;
    IBOutlet UIImageView *circleTwo;
    IBOutlet UIImageView *circleThree;
    IBOutlet UIImageView *circleFour;
    IBOutlet UIImageView *circleFive;
    
    IBOutlet UILabel *labelOne;
    IBOutlet UILabel *labelTwo;
    IBOutlet UILabel *labelThree;
    IBOutlet UILabel *labelFour;
    IBOutlet UILabel *labelFive;
    
    // IBOutlet for the time
    IBOutlet UILabel *timeLabel;
    NSTimer *timer;
    
}

- (IBAction)pressLabel:(id)sender;

@property NSMutableArray *topFive;
@property NSMutableArray *alerts;

@end
