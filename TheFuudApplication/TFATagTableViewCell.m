//
//  TFATagTableViewCell.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 24/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFATagTableViewCell.h"

@implementation TFATagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _tagView.tagPlaceholder = @"Type phone number here";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
