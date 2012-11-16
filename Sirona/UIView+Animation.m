//
//  UIView+Animation.m
//  Sirona
//
//  Created by Roger Chen on 11/15/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option
{
    [UIView animateWithDuration:secs delay:0 options:UIViewAnimationCurveLinear animations:^{
        self.frame = CGRectMake(destination.x, destination.y, self.frame.size.width, self.frame.size.height);
    }completion:^(BOOL finshed) {
    }];
    
}

@end
