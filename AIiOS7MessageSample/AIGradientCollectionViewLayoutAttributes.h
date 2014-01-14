//
//  AIGradientCollectionViewLayoutAttributes.h
//  AIiOS7MessageSample
//
//  Created by Akira Iwaya on 2013/12/14.
//  Copyright (c) 2013年 akira108. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIGradientCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes
@property(nonatomic, strong)NSArray *colors; // 右のセル用
@property(nonatomic, strong)NSArray *colorsLeft; // 左のセル用
@end

