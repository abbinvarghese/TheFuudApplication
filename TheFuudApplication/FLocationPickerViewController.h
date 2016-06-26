//
//  FLocationPickerViewController.h
//  Foodu
//
//  Created by Abbin on 18/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "TFACurrentLocationTableViewCell.h"

@class FLocationPickerViewController;

@protocol FLocationPickerDelegate <NSObject>

-(void)FLocationPicker:(FLocationPickerViewController*)picker didFinishPickingPlace:(NSMutableDictionary*)location;

@end

@interface FLocationPickerViewController : UIViewController<UISearchBarDelegate,GMSAutocompleteFetcherDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) id <FLocationPickerDelegate> delegate;

@property (assign, nonatomic) NSInteger tag;

@end
