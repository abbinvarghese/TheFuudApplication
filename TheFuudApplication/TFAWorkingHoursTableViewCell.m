//
//  TFAWorkingHoursTableViewCell.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 24/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFAWorkingHoursTableViewCell.h"

@implementation TFAWorkingHoursTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setPicker{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc]init];
    }
    [_datePicker setDate:[NSDate date]];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeTime;
    [_datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.cellTextField setInputView:_datePicker];
    
}

-(void)updateTextField:(id)sender{
    UIDatePicker *picker = (UIDatePicker*)self.cellTextField.inputView;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *dateString = [formatter stringFromDate:picker.date];
    if (self.indexPath.row == 0) {
        self.cellTextField.text = [NSString stringWithFormat:@"From: %@",dateString];
    }
    else{
        self.cellTextField.text = [NSString stringWithFormat:@"Till: %@",dateString];
    }
    if ([self.delegate respondsToSelector:@selector(workingHours:indexPath:)]) {
        [self.delegate workingHours:dateString indexPath:_indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
