//
//  AAPLGridViewCell2.h
//  Foodu
//
//  Created by Abbin Varghese on 03/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAPLGridViewCell2 : UICollectionViewCell

@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) UIImage *livePhotoBadgeImage;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (assign, nonatomic) BOOL cellSelected;

-(void)deSelectCellWithAnimation:(BOOL)animation;

-(void)selectCellWithAnimation:(BOOL)animation;

-(void)shakeCell;

@end
