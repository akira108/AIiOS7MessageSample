//
//  AISpringyCollectionViewFlowLayout.m
//  AIiOS7MessageSample
//
//  Created by Akira Iwaya on 2013/12/14.
//  Copyright (c) 2013年 akira108. All rights reserved.
//

#import "AISpringyCollectionViewFlowLayout.h"
#import "AIGradientCollectionViewLayoutAttributes.h"
#import "UIColor+HexColors.h"

@interface AISpringyCollectionViewFlowLayout ()

@property(nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property(nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property(nonatomic, assign) CGFloat latestDelta;

@end

@implementation AISpringyCollectionViewFlowLayout

- (void)setup {
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    self.visibleIndexPathsSet = [NSMutableSet set];
    self.locations = @[@(0.0f), @(1.0f)];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

+ (Class)layoutAttributesClass {
    return [AIGradientCollectionViewLayoutAttributes class];
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGRect originalRect = (CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size};
    CGRect visibleRect = CGRectInset(originalRect, -100, -100);
    
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
    NSSet *itemsIndexPathsInVisibleRectSet = [[NSSet setWithArray:itemsInVisibleRectArray] valueForKey:@"indexPath"];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behavior, NSDictionary *bindings) {
        BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:[[[behavior items] firstObject] indexPath]] != nil;
        return !currentlyVisible;
    }];
    
    NSArray *noLongerVisibleBehaviors = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:predicate];
    
    [noLongerVisibleBehaviors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.dynamicAnimator removeBehavior:obj];
        [self.visibleIndexPathsSet removeObject:[[[obj items] firstObject] indexPath]];
    }];
    
    predicate = [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        BOOL currentlyVisible = [self.visibleIndexPathsSet member:item.indexPath] != nil;
        return !currentlyVisible;
    }];
    
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:predicate];
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        
        springBehavior.length = 0.0f;
        springBehavior.damping = 0.8f;
        springBehavior.frequency = 0.8f;
        
        if(!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehavior.anchorPoint.y);
            CGFloat xDistanceFromTouch = fabsf(touchLocation.x - springBehavior.anchorPoint.x);
            CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
            
            if (self.latestDelta < 0) {
                center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
            }
            else {
                center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
            }
            item.center = center;
        }
        [self.dynamicAnimator addBehavior:springBehavior];
        [self.visibleIndexPathsSet addObject:item.indexPath];
    }];
    
}

- (UIColor *)colorAt:(CGFloat)location betweenColorA:(UIColor *)colorA andColorB:(UIColor *)colorB {
    CGFloat gradientBeginR, gradientBeginG, gradientBeginB, gradientBeginAlpha;
    CGFloat gradientEndR, gradientEndG, gradientEndB, gradientEndAlpha;
    
    [colorA getRed:&gradientBeginR green:&gradientBeginG blue:&gradientBeginB alpha:&gradientBeginAlpha];
    [colorB getRed:&gradientEndR green:&gradientEndG blue:&gradientEndB alpha:&gradientEndAlpha];
    
    CGFloat red = gradientBeginR + (gradientEndR - gradientBeginR) * location;
    CGFloat green = gradientBeginG + (gradientEndG - gradientBeginG) * location;
    CGFloat blue = gradientBeginB + (gradientEndB - gradientBeginB) * location;
    CGFloat alpha = gradientBeginAlpha + (gradientEndAlpha - gradientEndAlpha) *location;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//- (void)assignGradientColorsToLayoutAttributes:(NSArray *)layoutAttributes{
//    [layoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL *stop) {
//        AIGradientCollectionViewLayoutAttributes *layoutAttributes = (AIGradientCollectionViewLayoutAttributes *)obj;
//
//        CGRect layoutAttributesFrameInCollectionViewFrame = CGRectOffset(layoutAttributes.frame, 0.0f, -self.collectionView.contentOffset.y);
//        NSLog(@"layoutAttributesFrameInCollectionViewFrame = %@ [at %d]", NSStringFromCGRect(layoutAttributesFrameInCollectionViewFrame), layoutAttributes.indexPath.item);
//        CGFloat gradientBeginPosition = CGRectGetMinY(layoutAttributesFrameInCollectionViewFrame);
//        CGFloat gradientEndPosition = CGRectGetMaxY(layoutAttributesFrameInCollectionViewFrame);
//        CGFloat beginPosition = gradientBeginPosition/CGRectGetHeight(self.collectionView.frame);
//        CGFloat endPosition = gradientEndPosition/CGRectGetHeight(self.collectionView.frame);
//        
//        CGFloat beginRelative = beginPosition - 0.5f;
//        CGFloat endRelative = endPosition - 0.5f;
//        
//        UIColor *color  = [UIColor colorWithHue:0.084 - beginRelative/16.0f saturation:0.900 brightness:1.000 alpha:1.000];
//        
//        [layoutAttributes setColors:@[(id)color.CGColor, (id)color.CGColor]];
//    }];
//}

- (NSArray *)colorsForBeginPosition:(CGFloat)beginPosition endPosition:(CGFloat)endPosition withColors:(NSArray *)colors colorsIdeintifier:(NSString *)colorsIdentifier loations:(NSArray *)locations {
    NSAssert([colors count] == [locations count], @"[colors count] must equals to [locations]");
    NSAssert([locations containsObject:@(0.0f)] && [locations containsObject:@(1.0f)], @"locations must contain @(0.0f) and @(1.0f)");
    
    static NSMutableDictionary *cache;
    if(!cache) {
        cache = [[NSMutableDictionary alloc] init];
    }
    
    NSString *key = [NSString stringWithFormat:@"%f+%f+%@",beginPosition, endPosition, colorsIdentifier];
    
    NSArray *cachedColors = cache[key];
    
    if(cachedColors) {
        return cachedColors;
    }
    
    NSArray *returnColor;
    UIColor *beginColor;
    UIColor *endColor;
    
    NSUInteger count = [locations count];
    
    if(beginPosition > 1.0f) {
        beginColor = [colors firstObject];
    } else if(beginPosition < 0.0f) {
        beginColor = [colors lastObject];
    }
    if(endPosition > 1.0f) {
        endColor = [colors firstObject];
    } else if(endPosition < 0.0f){
        endColor = [colors lastObject];
    }
    
    for (NSUInteger i=0; i<count-1; i++) {
        if(beginPosition >= [locations[i] floatValue] && beginPosition <= [locations[i+1] floatValue]) {
            // calc "relative" vaue of beginPosition in self.locations
            CGFloat relativebeginPosition = ([locations [i+1] floatValue] - beginPosition)/([locations [i+1] floatValue] - [locations[i] floatValue]);
            beginColor = [self colorAt:relativebeginPosition betweenColorA:colors[i] andColorB:colors[i+1]];
        }
        if(endPosition >= [locations[i] floatValue] && endPosition <= [locations[i+1] floatValue]) {
            // calc "relative" vaue of endPosition in self.locations
            CGFloat relativeendPosition = ([locations [i+1] floatValue] - endPosition)/([locations [i+1] floatValue] - [locations[i] floatValue]);
            endColor = [self colorAt:relativeendPosition betweenColorA:colors[i] andColorB:colors[i+1]];
        }
        
        if(beginColor && endColor) break;
    }
    if(!beginColor || !endColor) {
        beginColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        endColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
    }
    returnColor = @[(id)beginColor.CGColor, (id)endColor.CGColor];
    cache[key] = returnColor;
    return returnColor;
}

- (void)assignGradientColorsToLayoutAttributes:(NSArray *)layoutAttributes {
    [layoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL *stop) {
        AIGradientCollectionViewLayoutAttributes *layoutAttributes = (AIGradientCollectionViewLayoutAttributes *)obj;
        CGRect layoutAttributesFrameInCollectionViewFrame = CGRectOffset(layoutAttributes.frame, 0.0f, -self.collectionView.contentOffset.y);
        CGFloat gradientBeginPosition = CGRectGetMinY(layoutAttributesFrameInCollectionViewFrame);
        CGFloat gradientEndPosition = CGRectGetMaxY(layoutAttributesFrameInCollectionViewFrame);
        CGFloat beginPosition = gradientBeginPosition/CGRectGetHeight(self.collectionView.frame);
        CGFloat endPosition = gradientEndPosition/CGRectGetHeight(self.collectionView.frame);
        NSArray *colorsForLayoutAttributes = [self colorsForBeginPosition:beginPosition endPosition:endPosition withColors:self.colors colorsIdeintifier:@"color1" loations:self.locations];
        NSArray *colorsLeftForLayoutAttributes = [self colorsForBeginPosition:beginPosition endPosition:endPosition withColors:self.colorsLeft colorsIdeintifier:@"color2" loations:self.locationsLeft];
        [layoutAttributes setColors:colorsForLayoutAttributes];
        [layoutAttributes setColorsLeft:colorsLeftForLayoutAttributes];
    }];
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAtributeses = [self.dynamicAnimator itemsInRect:rect];
    [self assignGradientColorsToLayoutAttributes:layoutAtributeses];
    return layoutAtributeses;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    if(layoutAttributes) {
        [self assignGradientColorsToLayoutAttributes:@[layoutAttributes]];
    } else {
        layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    }
    return layoutAttributes;
}

//- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
//    [super prepareForCollectionViewUpdates:updateItems];
//    
//    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
//        if(updateItem.updateAction == UICollectionUpdateActionInsert) {
//            UICollectionViewLayoutAttributes *attributes = [self.dynamicAnimator layoutAttributesForCellAtIndexPath:updateItem.indexPathAfterUpdate];
//            [self assignGradientColorsToLayoutAttributes:@[attributes]];
//        }
//    }];
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    self.latestDelta = delta;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehavior, NSUInteger idx, BOOL *stop) {
        CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehavior.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabsf(touchLocation.x - springBehavior.anchorPoint.x);
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
        
        UICollectionViewLayoutAttributes *item = [[springBehavior items] firstObject];
        CGPoint center = item.center;
        if(delta < 0) {
            center.y += MAX(delta, delta*scrollResistance);
        } else {
            center.y += MIN(delta, delta*scrollResistance);
        }
        item.center = center;
        
        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];
    
    return YES;
}

@end
