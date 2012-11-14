//
//  SironaTimeCellView.h
//  Sirona
//
//  Created by Roger Chen on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SironaTimeCellView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellMain;
@property (weak, nonatomic) IBOutlet UILabel *cellSecondary;
@property (weak, nonatomic) IBOutlet UILabel *cellTertiary;
@property (weak, nonatomic) IBOutlet UIImage *cellImage;

@end
