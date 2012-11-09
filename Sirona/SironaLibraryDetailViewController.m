//
//  SironaLibraryDetailViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaLibraryDetailViewController.h"
#import "SironaLibraryItem.h"

@implementation SironaLibraryDetailViewController

@synthesize item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [dataBrand setText:[item getBrand]];
    [dataCategory setText:[item getCategory]];
    [dataId setText:[item getId]];
    [dataPrecautions setText:[item getPrecautions]];
    [dataSideEffects setText:[item getSideEffects]];
    
}

- (void)setItem:(SironaLibraryItem *)theItem
{
    item = theItem;
}

@end
