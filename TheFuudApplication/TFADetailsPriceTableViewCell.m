//
//  TFADetailsPriceTableViewCell.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFADetailsPriceTableViewCell.h"

@implementation TFADetailsPriceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        self.cellTextField.text = [self currencySymbol];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:[self currencySymbol]]) {
        textField.text = @"";
        textField.placeholder = @"Price";
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location == 0 && range.length == 1) {
        return NO;
    }
    else{
        return YES;
    }
}
- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    if ([self.delegate respondsToSelector:@selector(priceFieldEditingChangedWithText:)]) {
        NSString *newStr = [sender.text substringWithRange:NSMakeRange(1, [sender.text length]-1)];
        [self.delegate priceFieldEditingChangedWithText:newStr];
    }
}

-(NSString*)currencySymbol{
    return [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
}


@end
