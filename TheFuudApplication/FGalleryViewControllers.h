//
//  FGalleryViewControllers.h
//  Foodu
//
//  Created by Abbin on 05/04/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;
@import PhotosUI;

@interface FGalleryViewControllers : UIViewController<PHPhotoLibraryChangeObserver,UICollectionViewDelegate,UICollectionViewDataSource>

@end
