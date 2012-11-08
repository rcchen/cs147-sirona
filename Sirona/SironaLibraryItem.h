//
//  SironaLibraryItem.h
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SironaLibraryItem : NSObject
{
    NSString *mdataBrand;
    NSString *mdataCategory;
    NSString *mdataId;
    NSString *mdataName;
    NSString *mdataPrecautions;
    NSString *mdataSideEffects;
}

- (id)initWithMDataBrand:(NSString *)jsonBrand
           mdataCategory:(NSString *)jsonCategory
                 mdataId:(NSString *)jsonId
               mdataName:(NSString *)jsonName
        mdataPrecautions:(NSString *)jsonPrecautions
        mdataSideEffects:(NSString *)jsonSideEFfects;

- (NSString *)getBrand;
- (NSString *)getCategory;
- (void)setBrand:(NSString *)brand;
- (void)setCategory:(NSString *)category;

@end
