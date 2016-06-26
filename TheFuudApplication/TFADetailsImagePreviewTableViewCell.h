//
//  TFADetailsImagePreviewTableViewCell.h
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFADetailsImagePreviewTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *selectedImage;

@property (weak, nonatomic) IBOutlet UICollectionView *imagePreviewCollectionView;

@end
