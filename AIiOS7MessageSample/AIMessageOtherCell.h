//
//  AIGradientCollectionViewOtherCell.h
//  AIiOS7MessageSample
//
//  Created by Akira Iwaya on 2013/12/27.
//  Copyright (c) 2013年 akira108. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIMessageGradientView.h"

@interface AIMessageOtherCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet AIMessageGradientView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

+ (CGFloat)heightForCellWithMessage:(NSString *)message;

@end
