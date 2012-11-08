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
    IBOutlet UIImageView *orangeCircle;
    IBOutlet UIImageView *greenCircle;
    IBOutlet UIImageView *blueCircle;
}

- (IBAction)pressButton:(id)sender;
- (IBAction)pressBoom:(id)sender;

@end
