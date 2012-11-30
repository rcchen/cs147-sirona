//
//  SironaLibraryItem.h
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//
//  Represents a medication.

#import <Foundation/Foundation.h>

@interface SironaLibraryItem : NSObject
{
    NSString *mdataId;

    NSString *mdataName;
    NSString *mdataDosage;
    NSString *mdataRoute;
    NSString *mdataForm;
    NSString *mdataQuantity;
    
    NSString *mdataFor;
    NSString *mdataInstructions;
    NSString *mdataPrecautions;
    NSString *mdataSideEffects;
    NSString *mdataPharmacyPhone;
    NSString *mdataPharmacy;
    NSString *mdataDoctor;
    
    NSString *mdataNotes;
}

- (id)initWithMDataName:(NSString *)name
            mdataDosage:(NSString *)dosage
             mdataRoute:(NSString *)route
              mdataForm:(NSString *)form
          mdataQuantity:(NSString *)quantity
               mdataFor:(NSString *)forWho
      mdataInstructions:(NSString *)instructions
       mdataPrecautions:(NSString *)precautions
       mdataSideEffects:(NSString *)sideEffects
     mdataPharmacyPhone:(NSString *)pharmacyPhone
          mdataPharmacy:(NSString *)pharmacy
            mdataDoctor:(NSString *)doctor
             mdataNotes:(NSString *)notes;

- (NSString *)getId;
- (NSString *)getName;
- (NSString *)getDosage;
- (NSString *)getRoute;
- (NSString *)getForm;
- (NSString *)getQuantity;
- (NSString *)getFor;
- (NSString *)getInstructions;
- (NSString *)getPrecautions;
- (NSString *)getSideEffects;
- (NSString *)getPharmacyPhone;
- (NSString *)getPharmacy;
- (NSString *)getDoctor;
- (NSString *)getNotes;

@end
