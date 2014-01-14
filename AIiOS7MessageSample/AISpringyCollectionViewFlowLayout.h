//
//  AISpringyCollectionViewFlowLayout.h
//  AIiOS7MessageSample
//
//  Created by Akira Iwaya on 2013/12/14.
//  Copyright (c) 2013年 akira108. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AISpringyCollectionViewFlowLayout : UICollectionViewFlowLayout
@property(nonatomic, strong)NSArray *colors;
@property(nonatomic, strong)NSArray *locations;
@property(nonatomic, strong)NSArray *colorsLeft;
@property(nonatomic, strong)NSArray *locationsLeft;

@end
