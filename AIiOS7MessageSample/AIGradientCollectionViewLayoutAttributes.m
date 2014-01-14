//
//  AIGradientCollectionViewLayoutAttributes.m
//  AIiOS7MessageSample
//
//  Created by Akira Iwaya on 2013/12/14.
//  Copyright (c) 2013年 akira108. All rights reserved.
//

#import "AIGradientCollectionViewLayoutAttributes.h"

@implementation AIGradientCollectionViewLayoutAttributes
- (instancetype)copyWithZone:(NSZone *)zone {
    typeof(self) clone = [super copyWithZone:zone];
    clone->_colors = [self.colors copy];
    clone->_colorsLeft = [self.colorsLeft copy];
    return clone;
}

- (BOOL)isEqual:(id)object {
    BOOL equality = [super isEqual:object];
    if(!equality) return NO;
    
    AIGradientCollectionViewLayoutAttributes *otherObject = (AIGradientCollectionViewLayoutAttributes *)object;
    if([otherObject.colors isEqual:self.colors] && [otherObject.colorsLeft isEqual:self.colorsLeft]) return YES;
    else return NO;
}

@end
