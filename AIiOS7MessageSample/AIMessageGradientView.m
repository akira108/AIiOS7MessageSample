//
//  AIGradientView.m
//  AIiOS7MessageSample
//
//  Created by Akira Iwaya on 2013/12/17.
//  Copyright (c) 2013年 akira108. All rights reserved.
//

#import "AIMessageGradientView.h"

#define MARGIN_X 8.0f
#define MARGIN_Y 6.0f
@implementation AIMessageGradientView

- (void)setup {
    self.layer.cornerRadius = 15.0f;
    self.layer.masksToBounds = YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    return self;
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [self.messageLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    size.width += MARGIN_X * 2;
    size.height += MARGIN_Y * 2;
    return size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.messageLabel.preferredMaxLayoutWidth = 200.0f;
    [self invalidateIntrinsicContentSize];
}

- (NSString *)message {
    return self.messageLabel.text;
}

- (void)setMessage:(NSString *)message {
    if(![message isEqualToString:self.messageLabel.text]) {
        self.messageLabel.text = message;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
