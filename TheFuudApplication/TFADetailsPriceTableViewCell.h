//
//  TFADetailsPriceTableViewCell.h
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

@class TFADetailsPriceTableViewCell;
@protocol TFADetailsPriceTableViewCellDelegate <NSObject>

-(void)priceFieldEditingChangedWithText:(NSString*)text;

@end

#import <UIKit/UIKit.h>

@interface TFADetailsPriceTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cellTextField;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@property (nonatomic, weak) id <TFADetailsPriceTableViewCellDelegate> delegate;

@end
