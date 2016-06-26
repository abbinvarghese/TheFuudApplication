//
//  NSMutableDictionary+TFALocation.h
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface NSMutableDictionary (TFALocation)

-(instancetype)initWithGMSPlace:(GMSPlace*)place;

-(NSString*)address;
-(NSString*)placeID;
-(NSNumber *)longitude;
-(NSNumber *)latitude;
-(NSString *)name;

@end
