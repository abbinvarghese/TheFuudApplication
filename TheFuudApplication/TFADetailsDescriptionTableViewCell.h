//
//  TFADetailsDescriptionTableViewCell.h
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

@class TFADetailsDescriptionTableViewCell;
@protocol TFADetailsDescriptionTableViewCellDelegate <NSObject>

-(void)descriptionFieldEditingChangedWithText:(NSString*)text;

@end

#import <UIKit/UIKit.h>

@interface TFADetailsDescriptionTableViewCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UITextView *cellTextView;

@property (nonatomic, weak) id <TFADetailsDescriptionTableViewCellDelegate> delegate;

@end
