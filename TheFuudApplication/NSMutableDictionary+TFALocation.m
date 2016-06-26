//
//  NSMutableDictionary+TFALocation.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "NSMutableDictionary+TFALocation.h"

@implementation NSMutableDictionary (TFALocation)

-(instancetype)initWithGMSPlace:(GMSPlace *)place{
    self = [self init];
    if (self != nil){
        [self setObject:place.placeID forKey:locationPlaceIDKey];
        if (place.formattedAddress) {
            [self setObject:place.formattedAddress forKey:locationAddressKey];
        }
        else{
            [self setObject:@"" forKey:locationAddressKey];
        }
        if (place.name) {
            [self setObject:place.name forKey:locationNameKey];
        }
        else{
            [self setObject:@"" forKey:locationNameKey];
        }
        [self setObject:[NSNumber numberWithDouble:place.coordinate.latitude] forKey:locationLatitudeKey];
        [self setObject:[NSNumber numberWithDouble:place.coordinate.longitude] forKey:locationLongitudeKey];
    }
    return self;
}

-(NSString *)name{
    return [self objectForKey:locationNameKey];
}

-(NSString *)address{
    return [self objectForKey:locationAddressKey];
}

-(NSString *)placeID{
    return [self objectForKey:locationPlaceIDKey];
}

-(NSNumber *)longitude{
    return [self objectForKey:locationLongitudeKey];
}

-(NSNumber *)latitude{
    return [self objectForKey:locationLatitudeKey];
}

@end
