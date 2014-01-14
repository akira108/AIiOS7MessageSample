//
//  AICollectionViewController.h
//  AIiOS7MessageSample
//
//  Created by Akira Iwaya on 2013/12/14.
//  Copyright (c) 2013年 akira108. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AICollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
