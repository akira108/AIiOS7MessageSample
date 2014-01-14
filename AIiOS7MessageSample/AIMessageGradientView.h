//
//  AIGradientView.h
//  AIiOS7MessageSample
//
//  Created by Akira Iwaya on 2013/12/17.
//  Copyright (c) 2013年 akira108. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AIMessageGradientView : UIView
@property(nonatomic, weak)IBOutlet UILabel *messageLabel;

- (NSString *)message;
- (void)setMessage:(NSString *)message;
@end
