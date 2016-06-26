//
//  TFARestaurentDetailsTableViewController.h
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFARestaurentDetailsTableViewController : UITableViewController

@property (strong, nonatomic) NSString *dishName;
@property (strong, nonatomic) NSString *dishPrice;
@property (strong, nonatomic) NSString *dishDescription;
@property (nonatomic, strong) NSMutableArray *selectedImage;

@end
