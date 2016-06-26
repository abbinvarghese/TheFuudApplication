//
//  TFADetailsImagePreviewTableViewCell.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFADetailsImagePreviewTableViewCell.h"
#import "TFADetailsImagePreviewCollectionViewCell.h"

@implementation TFADetailsImagePreviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imagePreviewCollectionView.delegate = self;
    _imagePreviewCollectionView.dataSource = self;
    [_imagePreviewCollectionView registerNib:[UINib nibWithNibName:@"TFADetailsImagePreviewCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TFADetailsImagePreviewCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _selectedImage.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TFADetailsImagePreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TFADetailsImagePreviewCollectionViewCell" forIndexPath:indexPath];
    cell.previewImageView.image = _selectedImage[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *image = _selectedImage[indexPath.row];
    return CGSizeMake(image.size.width*collectionView.frame.size.height/image.size.height, collectionView.frame.size.height);
}

@end
