//
//  TFADetailsNameTableViewCell.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFADetailsNameTableViewCell.h"

@implementation TFADetailsNameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    if ([self.delegate respondsToSelector:@selector(nameFieldEditingChangedWithText:)]) {
        [self.delegate nameFieldEditingChangedWithText:sender.text];
    }
}


@end
