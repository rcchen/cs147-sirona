//
//  SironaLibraryItem.m
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaLibraryItem.h"

@implementation SironaLibraryItem

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
             mdataNotes:(NSString *)notes
{
    [self setLibraryItemId];
    mdataName = name;
    mdataDosage = dosage;
    mdataRoute = route;
    mdataForm = form;
    mdataQuantity = quantity;
    mdataFor = forWho;
    mdataInstructions = instructions;
    mdataPrecautions = precautions;
    mdataSideEffects = sideEffects;
    mdataPharmacyPhone = pharmacyPhone;
    mdataPharmacy = pharmacy;
    mdataDoctor = doctor;
    mdataNotes = notes;
    
    return self;
}

- (void)setLibraryItemId
{
    if (![mdataId length]) {
        NSDate *now = [[NSDate alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
        mdataId = [formatter stringFromDate:now];
    }
    
}

- (NSString *)getId {
    return mdataId;
}
- (NSString *)getName {
    return mdataName;
}
- (NSString *)getDosage {
    return mdataDosage;
}
- (NSString *)getRoute {
    return mdataRoute;
}
- (NSString *)getForm {
    return mdataForm;
}
- (NSString *)getQuantity {
    return mdataQuantity;
}
- (NSString *)getFor {
    return mdataFor;
}
- (NSString *)getInstructions {
    return mdataInstructions;
}
- (NSString *)getPrecautions {
    return mdataPrecautions;
}
- (NSString *)getSideEffects {
    return mdataSideEffects;
}
- (NSString *)getPharmacyPhone {
    return mdataPharmacyPhone;
}
- (NSString *)getPharmacy {
    return mdataPharmacy;
}
- (NSString *)getDoctor {
    return mdataDoctor;
}
- (NSString *)getNotes {
    return mdataNotes;
}

- (NSComparisonResult)compare:(SironaLibraryItem *)otherObject {
    return [self.getName localizedCaseInsensitiveCompare:otherObject.getName];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:mdataId forKey:@"mdataId"];
    [encoder encodeObject:mdataName forKey:@"mdataName"];
    [encoder encodeObject:mdataDosage forKey:@"mdataDosage"];
    [encoder encodeObject:mdataRoute forKey:@"mdataRoute"];
    [encoder encodeObject:mdataForm forKey:@"mdataForm"];
    [encoder encodeObject:mdataQuantity forKey:@"mdataQuantity"];
    [encoder encodeObject:mdataFor forKey:@"mdataFor"];
    [encoder encodeObject:mdataInstructions forKey:@"mdataInstructions"];
    [encoder encodeObject:mdataPrecautions forKey:@"mdataPrecautions"];
    [encoder encodeObject:mdataSideEffects forKey:@"mdataSideEffects"];
    [encoder encodeObject:mdataPharmacyPhone forKey:@"mdataPharmacyPhone"];
    [encoder encodeObject:mdataPharmacy forKey:@"mdataPharmacy"];
    [encoder encodeObject:mdataDoctor forKey:@"mdataDoctor"];
    [encoder encodeObject:mdataNotes forKey:@"mdataNotes"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        mdataId = [decoder decodeObjectForKey:@"mdataId"];
        mdataName = [decoder decodeObjectForKey:@"mdataName"];
        mdataDosage = [decoder decodeObjectForKey:@"mdataDosage"];
        mdataRoute = [decoder decodeObjectForKey:@"mdataRoute"];
        mdataForm = [decoder decodeObjectForKey:@"mdataForm"];
        mdataQuantity = [decoder decodeObjectForKey:@"mdataQuantity"];
        mdataFor = [decoder decodeObjectForKey:@"mdataFor"];
        mdataInstructions = [decoder decodeObjectForKey:@"mdataInstructions"];
        mdataPrecautions = [decoder decodeObjectForKey:@"mdataPrecautions"];
        mdataSideEffects = [decoder decodeObjectForKey:@"mdataSideEffects"];
        mdataPharmacyPhone = [decoder decodeObjectForKey:@"mdataPharmacyPhone"];
        mdataPharmacy = [decoder decodeObjectForKey:@"mdataPharmacy"];
        mdataDoctor = [decoder decodeObjectForKey:@"mdataDoctor"];
        mdataNotes = [decoder decodeObjectForKey:@"mdataNotes"];
    }
    return self;
}


@end
