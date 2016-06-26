//
//  TFAManager.h
//  TheFuudApplication
//
//  Created by Abbin Varghese on 21/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFAManager : NSObject

+ (TFAManager*)sharedManager;

+(BOOL)isFirstCameraLaunch;

+(void)didFinishFirstCameraLaunch;

+(void)saveItemName:(NSString*)name price:(NSString*)price description:(NSString*)description images:(NSArray*)images restaurantName:(NSString*)restaurantName location:(NSMutableDictionary*)location phoneNumbers:(NSArray*)phoneNumbers woringFrom:(NSString*)workingFrom workingTill:(NSString*)workingTill;

@end
