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
    
    // IBOutlet for the time
    IBOutlet UILabel *timeLabel;
    NSTimer *timer;
    
}

- (IBAction)pressButton:(id)sender;

@end
