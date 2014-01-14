//
//  AICollectionViewCell.h
//  AIiOS7MessageSample
//
//  Created by Akira Iwaya on 2013/12/14.
//  Copyright (c) 2013年 akira108. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIMessageGradientView.h"

@interface AIMessageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet AIMessageGradientView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
+ (CGFloat)heightForCellWithMessage:(NSString *)message;
@end

