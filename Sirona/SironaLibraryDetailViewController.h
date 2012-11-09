//
//  SironaLibraryDetailViewController.h
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SironaLibraryItem;

@interface SironaLibraryDetailViewController : UIViewController
{
    __weak IBOutlet UILabel *dataBrand;
    __weak IBOutlet UILabel *dataCategory;
    __weak IBOutlet UILabel *dataId;
    __weak IBOutlet UILabel *dataPrecautions;
    __weak IBOutlet UILabel *dataSideEffects;
}

@property (nonatomic, strong)SironaLibraryItem *item;

- (void)setItem:(SironaLibraryItem *)theItem;

@end
