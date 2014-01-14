//
//  AIGradientCollectionViewOtherCell.m
//  AIiOS7MessageSample
//
//  Created by Akira Iwaya on 2013/12/27.
//  Copyright (c) 2013年 akira108. All rights reserved.
//

#import "AIMessageOtherCell.h"
#import "AIGradientCollectionViewLayoutAttributes.h"

#define MESSAGE_POSITION_Y 18.0f

@implementation AIMessageOtherCell

- (void)setup {
    self.profileImageView.layer.cornerRadius = CGRectGetHeight(self.profileImageView.frame)/2.0f;
    self.profileImageView.layer.masksToBounds = YES;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    [(CAGradientLayer *)self.messageView.layer setColors:((AIGradientCollectionViewLayoutAttributes *)layoutAttributes).colorsLeft];
}

- (CGSize)intrinsicContentSize {
    CGSize messageSize = [self.messageView intrinsicContentSize];
    messageSize.width = UIViewNoIntrinsicMetric;
    messageSize.height += MESSAGE_POSITION_Y;

    return messageSize;
}

+ (CGFloat)heightForCellWithMessage:(NSString *)message {
    CGRect messageRect = [message boundingRectWithSize:CGSizeMake(200.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    return messageRect.size.height + MESSAGE_POSITION_Y + 12.0f;
}

@end
