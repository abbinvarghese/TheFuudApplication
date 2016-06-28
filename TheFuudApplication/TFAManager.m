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

+(BOOL)isFirstCameraLaunch{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:firstCameraLaunchKey]) {
        return NO;
    }
    else{
        return YES;
    }
}

+(void)didFinishFirstCameraLaunch{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstCameraLaunchKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)uuid{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}

+(void)saveItemName:(NSString*)name price:(NSString*)price description:(NSString*)description images:(NSArray*)images restaurantName:(NSString*)restaurantName location:(NSMutableDictionary*)location phoneNumbers:(NSArray*)phoneNumbers woringFrom:(NSString*)workingFrom workingTill:(NSString*)workingTill{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"MM"];
        NSString *myMonthString = [df stringFromDate:[NSDate date]];
        
        [df setDateFormat:@"yyyy"];
        NSString *myYearString = [df stringFromDate:[NSDate date]];
        
        FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:[NSString stringWithFormat:@"%@item_images/%@%@/%@.jpg",storagePathKey,myYearString,myMonthString,[self uuid]]];
        
        // Create the file metadata
        FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
        metadata.contentType = @"image/jpeg";
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        ;
        FIRStorageUploadTask *uploadTask = [storageRef putData:UIImageJPEGRepresentation(images[0], 0.5) metadata:metadata];
        
        [uploadTask observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot *snapshot) {
            // Upload reported progress
            double percentComplete = 100.0 * (snapshot.progress.completedUnitCount) / (snapshot.progress.totalUnitCount);
            NSLog(@"First = %f",percentComplete);
        }];
        
        // Errors only occur in the "Failure" case
        [uploadTask observeStatus:FIRStorageTaskStatusFailure handler:^(FIRStorageTaskSnapshot *snapshot) {
            if (snapshot.error != nil) {
                switch (snapshot.error.code) {
                    case FIRStorageErrorCodeObjectNotFound:
                        // File doesn't exist
                        break;
                        
                    case FIRStorageErrorCodeUnauthorized:
                        // User doesn't have permission to access file
                        break;
                        
                    case FIRStorageErrorCodeCancelled:
                        // User canceled the upload
                        break;
                        
                    case FIRStorageErrorCodeUnknown:
                        // Unknown error occurred, inspect the server response
                        break;
                }
            }
        }];
        
        [uploadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot) {
            if (images.count>1) {
                FIRStorageReference *storageRef2 = [[FIRStorage storage] referenceForURL:[NSString stringWithFormat:@"%@item_images/%@%@/%@.jpg",storagePathKey,myYearString,myMonthString,[self uuid]]];
                FIRStorageUploadTask *uploadTask2 = [storageRef2 putData:UIImageJPEGRepresentation(images[1], 0.5) metadata:metadata];
                
                [uploadTask2 observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot *snapshot2) {
                    // Upload reported progress
                    double percentComplete = 100.0 * (snapshot2.progress.completedUnitCount) / (snapshot2.progress.totalUnitCount);
                    NSLog(@"Second = %f",percentComplete);
                }];
                
                // Errors only occur in the "Failure" case
                [uploadTask2 observeStatus:FIRStorageTaskStatusFailure handler:^(FIRStorageTaskSnapshot *snapshot2) {
                    if (snapshot2.error != nil) {
                        switch (snapshot2.error.code) {
                            case FIRStorageErrorCodeObjectNotFound:
                                // File doesn't exist
                                break;
                                
                            case FIRStorageErrorCodeUnauthorized:
                                // User doesn't have permission to access file
                                break;
                                
                            case FIRStorageErrorCodeCancelled:
                                // User canceled the upload
                                break;
                                
                            case FIRStorageErrorCodeUnknown:
                                // Unknown error occurred, inspect the server response
                                break;
                        }
                    }
                }];
                
                [uploadTask2 observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot2) {
                    if (images.count>2) {
                        FIRStorageReference *storageRef3 = [[FIRStorage storage] referenceForURL:[NSString stringWithFormat:@"%@item_images/%@%@/%@.jpg",storagePathKey,myYearString,myMonthString,[self uuid]]];
                        FIRStorageUploadTask *uploadTask3 = [storageRef3 putData:UIImageJPEGRepresentation(images[2], 0.5) metadata:metadata];
                        
                        [uploadTask3 observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot *snapshot3) {
                            // Upload reported progress
                            double percentComplete = 100.0 * (snapshot3.progress.completedUnitCount) / (snapshot3.progress.totalUnitCount);
                            NSLog(@"Thrid = %f",percentComplete);
                        }];
                        
                        // Errors only occur in the "Failure" case
                        [uploadTask3 observeStatus:FIRStorageTaskStatusFailure handler:^(FIRStorageTaskSnapshot *snapshot3) {
                            if (snapshot3.error != nil) {
                                switch (snapshot3.error.code) {
                                    case FIRStorageErrorCodeObjectNotFound:
                                        // File doesn't exist
                                        break;
                                        
                                    case FIRStorageErrorCodeUnauthorized:
                                        // User doesn't have permission to access file
                                        break;
                                        
                                    case FIRStorageErrorCodeCancelled:
                                        // User canceled the upload
                                        break;
                                        
                                    case FIRStorageErrorCodeUnknown:
                                        // Unknown error occurred, inspect the server response
                                        break;
                                }
                            }
                        }];
                        
                        [uploadTask3 observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot3) {
                            
                            FIRDatabaseReference *ref = [[FIRDatabase database] reference];
                            
                            NSString *key = [[ref child:fuudPathKey] childByAutoId].key;
                            
                            NSMutableDictionary *rest = [[NSMutableDictionary alloc]init];
                            [rest setObject:restaurantName forKey:restaurantNameKey];
                            [rest setObject:location forKey:restaurantlocationKey];
                            if (phoneNumbers.count>0 && phoneNumbers != nil) {
                                [rest setObject:phoneNumbers forKey:restaurantPhoneNumberKey];
                            }
                            if (workingFrom.length>0) {
                                [rest setObject:workingFrom forKey:restaurantWorkingFromKey];
                            }
                            if (workingTill.length>0) {
                                [rest setObject:workingTill forKey:restaurantWorkingTillKey];
                            }
                            
                            NSArray *imageArray = [NSArray arrayWithObjects:
                                                   [NSString stringWithFormat:@"%@",snapshot.metadata.downloadURL],
                                                   [NSString stringWithFormat:@"%@",snapshot2.metadata.downloadURL],
                                                   [NSString stringWithFormat:@"%@",snapshot3.metadata.downloadURL],nil];
                            
                            NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
                            [item setObject:name forKey:fuudTitleKey];
                            [item setObject:[NSNumber numberWithDouble:[price doubleValue]] forKey:fuudPriceKey];
                            [item setObject:rest forKey:fuudRestaurentKey];
                            [item setObject:imageArray forKey:fuudImageKey];
                            
                            if (description.length>0) {
                                [item setObject:description forKey:fuudDescriptionKey];
                            }
                            [item setObject:location[locationLatitudeKey] forKey:fuudLatitudeKey];
                            [item setObject:location[locationLongitudeKey] forKey:fuudLongitudeKey];
                            
                            NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/%@/%@",fuudPathKey,key]:item};
                            
                            [ref updateChildValues:childUpdates];
                            
                            NSLog(@"All Uploads Finished");
                            
                        }];
                    }
                    else{
                        FIRDatabaseReference *ref = [[FIRDatabase database] reference];
                        
                        NSString *key = [[ref child:fuudPathKey] childByAutoId].key;
                        
                        NSMutableDictionary *rest = [[NSMutableDictionary alloc]init];
                        [rest setObject:restaurantName forKey:restaurantNameKey];
                        [rest setObject:location forKey:restaurantlocationKey];
                        if (phoneNumbers.count>0 && phoneNumbers != nil) {
                            [rest setObject:phoneNumbers forKey:restaurantPhoneNumberKey];
                        }
                        if (workingFrom.length>0) {
                            [rest setObject:workingFrom forKey:restaurantWorkingFromKey];
                        }
                        if (workingTill.length>0) {
                            [rest setObject:workingTill forKey:restaurantWorkingTillKey];
                        }
                        
                        NSArray *imageArray = [NSArray arrayWithObjects:
                                               [NSString stringWithFormat:@"%@",snapshot.metadata.downloadURL],
                                               [NSString stringWithFormat:@"%@",snapshot2.metadata.downloadURL], nil];
                        
                        NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
                        [item setObject:name forKey:fuudTitleKey];
                        [item setObject:[NSNumber numberWithDouble:[price doubleValue]] forKey:fuudPriceKey];
                        [item setObject:rest forKey:fuudRestaurentKey];
                        [item setObject:imageArray forKey:fuudImageKey];
                        
                        if (description.length>0) {
                            [item setObject:description forKey:fuudDescriptionKey];
                        }
                        [item setObject:location[locationLatitudeKey] forKey:fuudLatitudeKey];
                        [item setObject:location[locationLongitudeKey] forKey:fuudLongitudeKey];
                        
                        NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/%@/%@",fuudPathKey,key]:item};
                        
                        [ref updateChildValues:childUpdates];
                        
                        NSLog(@"All Uploads Finished");

                    }
                }];
                
            }
            else{
                FIRDatabaseReference *ref = [[FIRDatabase database] reference];
                
                NSString *key = [[ref child:fuudPathKey] childByAutoId].key;
                
                NSMutableDictionary *rest = [[NSMutableDictionary alloc]init];
                [rest setObject:restaurantName forKey:restaurantNameKey];
                [rest setObject:location forKey:restaurantlocationKey];
                if (phoneNumbers.count>0 && phoneNumbers != nil) {
                    [rest setObject:phoneNumbers forKey:restaurantPhoneNumberKey];
                }
                if (workingFrom.length>0) {
                    [rest setObject:workingFrom forKey:restaurantWorkingFromKey];
                }
                if (workingTill.length>0) {
                    [rest setObject:workingTill forKey:restaurantWorkingTillKey];
                }
                
                NSArray *imageArray = [NSArray arrayWithObjects:
                                       [NSString stringWithFormat:@"%@",snapshot.metadata.downloadURL],nil];
                
                NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
                [item setObject:name forKey:fuudTitleKey];
                [item setObject:[NSNumber numberWithDouble:[price doubleValue]] forKey:fuudPriceKey];
                [item setObject:rest forKey:fuudRestaurentKey];
                [item setObject:imageArray forKey:fuudImageKey];
                
                if (description.length>0) {
                    [item setObject:description forKey:fuudDescriptionKey];
                }
                [item setObject:location[locationLatitudeKey] forKey:fuudLatitudeKey];
                [item setObject:location[locationLongitudeKey] forKey:fuudLongitudeKey];
                
                NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/%@/%@",fuudPathKey,key]:item};
                
                [ref updateChildValues:childUpdates];
                
                NSLog(@"All Uploads Finished");
                
            }
        }];
        
    });
    
}

@end
