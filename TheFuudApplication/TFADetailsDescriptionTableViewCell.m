//
//  TFADetailsDescriptionTableViewCell.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFADetailsDescriptionTableViewCell.h"

@implementation TFADetailsDescriptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Description(Optional)"]) {
        textView.text = @"";
        textView.textColor = [UIColor darkTextColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.text = @"Description(Optional)";
        textView.textColor = [UIColor colorWithWhite:0 alpha:0.25];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(descriptionFieldEditingChangedWithText:)]) {
        [self.delegate descriptionFieldEditingChangedWithText:textView.text];
    }
}

@end
