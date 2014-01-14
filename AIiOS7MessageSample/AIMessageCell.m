//
//  AICollectionViewCell.m
//  AIiOS7MessageSample
//
//  Created by Akira Iwaya on 2013/12/14.
//  Copyright (c) 2013年 akira108. All rights reserved.
//

#import "AIMessageCell.h"
#import "AIGradientCollectionViewLayoutAttributes.h"

@interface AIMessageCell ()
@end

@implementation AIMessageCell


- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    [(CAGradientLayer *)self.messageView.layer setColors:((AIGradientCollectionViewLayoutAttributes *)layoutAttributes).colors];
}

- (CGSize)intrinsicContentSize {
    CGSize messageSize = [self.messageView intrinsicContentSize];
    messageSize.width = UIViewNoIntrinsicMetric;
    return messageSize;
}

+ (CGFloat)heightForCellWithMessage:(NSString *)message {
    CGRect messageRect = [message boundingRectWithSize:CGSizeMake(200.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    return messageRect.size.height + 12.0f;
}


@end
