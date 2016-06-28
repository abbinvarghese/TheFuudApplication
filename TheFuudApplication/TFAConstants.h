//
//  TFAConstants.h
//  TheFuudApplication
//
//  Created by Abbin Varghese on 21/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFAConstants : NSObject

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Restaurant Keys -

FOUNDATION_EXPORT NSString *const restaurantNameKey;
FOUNDATION_EXPORT NSString *const restaurantlocationKey;
FOUNDATION_EXPORT NSString *const restaurantPhoneNumberKey;
FOUNDATION_EXPORT NSString *const restaurantWorkingFromKey;
FOUNDATION_EXPORT NSString *const restaurantWorkingTillKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Fuud Keys -

FOUNDATION_EXPORT NSString *const fuudTitleKey;
FOUNDATION_EXPORT NSString *const fuudDescriptionKey;
FOUNDATION_EXPORT NSString *const fuudPriceKey;
FOUNDATION_EXPORT NSString *const fuudRatingKey;
FOUNDATION_EXPORT NSString *const fuudRestaurentKey;
FOUNDATION_EXPORT NSString *const fuudImageKey;
FOUNDATION_EXPORT NSString *const fuudLatitudeKey;
FOUNDATION_EXPORT NSString *const fuudLongitudeKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - User Keys -

FOUNDATION_EXPORT NSString *const userIDKey;
FOUNDATION_EXPORT NSString *const userIsAnonymousKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Location Keys -

FOUNDATION_EXPORT NSString *const locationPlaceIDKey;
FOUNDATION_EXPORT NSString *const locationNameKey;
FOUNDATION_EXPORT NSString *const locationAddressKey;
FOUNDATION_EXPORT NSString *const locationLatitudeKey;
FOUNDATION_EXPORT NSString *const locationLongitudeKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Feedback Keys -

FOUNDATION_EXPORT NSString *const feedbackTextKey;
FOUNDATION_EXPORT NSString *const feedbackFileURLKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Database Path Keys -

FOUNDATION_EXPORT NSString *const fuudPathKey;
FOUNDATION_EXPORT NSString *const storagePathKey;
FOUNDATION_EXPORT NSString *const userPathKey;
FOUNDATION_EXPORT NSString *const messagesPathKey;
FOUNDATION_EXPORT NSString *const feedbackPathKey;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UX Keys -

FOUNDATION_EXPORT NSString *const firstCameraLaunchKey;

@end
