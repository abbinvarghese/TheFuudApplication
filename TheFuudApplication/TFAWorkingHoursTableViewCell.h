//
//  TFAWorkingHoursTableViewCell.h
//  TheFuudApplication
//
//  Created by Abbin Varghese on 24/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

@protocol TFAWorkingHoursTableViewCellDelegate <NSObject>

-(void)workingHours:(NSString*)Hours indexPath:(NSIndexPath*)indexPath;

@end

#import <UIKit/UIKit.h>

@interface TFAWorkingHoursTableViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (assign, nonatomic) id<TFAWorkingHoursTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *cellTextField;
@property (strong, nonatomic) UIDatePicker *datePicker;
-(void)setPicker;

@end
