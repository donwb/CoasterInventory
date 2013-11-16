//
//  RecipeCollectionViewController.h
//  RecipePhoto
//
//  Created by Don Browning on 11/15/13.
//  Copyright (c) 2013 Don Browning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeCollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property NSArray *photos;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
