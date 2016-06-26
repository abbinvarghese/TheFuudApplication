//
//  TFADetailsNameTableViewCell.h
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

@class TFADetailsNameTableViewCell;
@protocol TFADetailsNameTableViewCellDelegate <NSObject>

-(void)nameFieldEditingChangedWithText:(NSString*)text;

@end

#import <UIKit/UIKit.h>

@interface TFADetailsNameTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cellTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomBorder;

@property (nonatomic, weak) id <TFADetailsNameTableViewCellDelegate> delegate;

@end
