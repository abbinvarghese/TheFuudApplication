//
//  TFAManager.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 21/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFAManager.h"
@import Firebase;

@implementation TFAManager

+ (TFAManager*)sharedManager {
    static TFAManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
