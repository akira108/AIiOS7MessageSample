//
//  AICollectionViewController.m
//  AIiOS7MessageSample
//
//  Created by Akira Iwaya on 2013/12/14.
//  Copyright (c) 2013年 akira108. All rights reserved.
//

#import "AICollectionViewController.h"
#import "AIMessageCell.h"
#import "AIMessageOtherCell.h"
#import "AISpringyCollectionViewFlowLayout.h"
#import "DAKeyboardControl.h"

@interface AICollectionViewController () <UITextFieldDelegate>
@property(nonatomic, weak)IBOutlet UIToolbar *toolbar;
@property(nonatomic, weak)IBOutlet UITextField *textField;
@property(nonatomic, weak)IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomVerticalSpacerConstraint;

@property (strong, nonatomic) NSMutableArray *items;

- (IBAction)sendButtonDidTap:(id)sender;

@end

@implementation AICollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [((AISpringyCollectionViewFlowLayout *)self.collectionView.collectionViewLayout) setColors:@[
                                                                                                 [UIColor colorWithRed:120/255.0 green:206/255.0 blue:50/255.0 alpha:1.000],
                                                                                                 [UIColor colorWithRed:196/255.0 green:255/255.0 blue:146/255.0 alpha:1.000],
                                                                                                 ]];
    [((AISpringyCollectionViewFlowLayout *)self.collectionView.collectionViewLayout) setLocations:@[
                                                                                                    @(0.0f),
                                                                                                    @(1.0f)
                                                                                                    ]];
    [((AISpringyCollectionViewFlowLayout *)self.collectionView.collectionViewLayout) setColorsLeft:@[
                                                                                                     [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.000],
                                                                                                     [UIColor colorWithRed:194/255.0 green:219/255.0 blue:240/255.0 alpha:1.000],
                                                                                                     ]];
    [((AISpringyCollectionViewFlowLayout *)self.collectionView.collectionViewLayout) setLocationsLeft:@[
                                                                                                        @(0.0f),
                                                                                                        @(1.0f)
                                                                                                        ]];
    
    __weak typeof(self) wself = self;
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        __strong typeof(self) sself = wself;
        if(opening) {
            CGPoint contentOffset = sself.collectionView.contentOffset;
            contentOffset.y = MIN(contentOffset.y + CGRectGetHeight(keyboardFrameInView), sself.collectionView.contentSize.height - (CGRectGetHeight(sself.collectionView.frame) - sself.collectionView.contentInset.bottom));
            sself.collectionView.contentOffset = contentOffset;
        }
    } constraintBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        __strong typeof(self) sself = wself;
        sself.bottomVerticalSpacerConstraint.constant = CGRectGetHeight(sself.view.frame) - keyboardFrameInView.origin.y;
    }];
    
    UINib *cellNib = [UINib nibWithNibName:@"AIMessageCell" bundle:nil];
    UINib *otherCellNib = [UINib nibWithNibName:@"AIMessageOtherCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CellIdentifier"];
    [self.collectionView registerNib:otherCellNib forCellWithReuseIdentifier:@"OtherCellIdentifier"];
    
    self.items = [NSMutableArray array];
    
    for(int i=0; i< 30; i++) {
        NSString *identifier;
        NSString *message;
        switch (i%2) {
            case 0:
                identifier = @"CellIdentifier";
                break;
            case 1:
                identifier = @"OtherCellIdentifier";
            default:
                break;
        }
        
        switch(i % 4) {
            case 0:
                message = @"あい";
                break;
            case 1:
                message = @"あいうえお";
                break;
            case 2:
                message = @"あいうえおかきくけこ";
                break;
            case 3:
                message = @"あいうえおかきくけこあいうえおかきくけこあいうえおかきくけこあいうえおかきくけこ";
                break;
            default:
                break;
        }
        [self.items addObject:@{@"identifier" : identifier, @"message" : message}];
    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length + CGRectGetHeight(self.toolbar.frame) + self.bottomVerticalSpacerConstraint.constant +  10, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length + CGRectGetHeight(self.toolbar.frame) + self.bottomVerticalSpacerConstraint.constant + 10, 0);
    self.view.keyboardTriggerOffset = CGRectGetHeight(self.toolbar.frame);

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Methods

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    return self.items[indexPath.item][@"identifier"];;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    CGSize size;
    size.width = 300.0f;
    
    static NSMutableDictionary *cellHeightCache;
    static NSMutableDictionary *otherCellHeightCache;
    
    if(cellHeightCache == nil) cellHeightCache = [NSMutableDictionary dictionary];
    if(otherCellHeightCache == nil) otherCellHeightCache = [NSMutableDictionary dictionary];
    
    if([cellIdentifier isEqualToString:@"CellIdentifier"]) {
        if(cellHeightCache[indexPath]) size.height = [cellHeightCache[indexPath] floatValue];
        else {
            size.height = [cellHeightCache[indexPath] floatValue] ?: [AIMessageCell heightForCellWithMessage:[self messageForIndexPath:indexPath]];
            cellHeightCache[indexPath] = @(size.height);
        }
    } else if([cellIdentifier isEqualToString:@"OtherCellIdentifier"]) {
        if(otherCellHeightCache[indexPath]) size.height = [otherCellHeightCache[indexPath] floatValue];
        else {
            size.height = [AIMessageOtherCell heightForCellWithMessage:[self messageForIndexPath:indexPath]];
            otherCellHeightCache[indexPath] = @(size.height);
        }
    }
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.items count];
}

- (NSString *)messageForIndexPath:(NSIndexPath *)indexPath {
    return self.items[indexPath.item][@"message"];
}

-(void)updateCell:(AIMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSString *message = [self messageForIndexPath:indexPath];
    [cell.messageView setMessage:message];
}

- (void)updateOtherCell:(AIMessageOtherCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [cell.messageView setMessage:[self messageForIndexPath:indexPath]];
    [cell.profileImageView setImage:[UIImage imageNamed:@"profile"]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    NSString *cellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    if([cellIdentifier isEqualToString:@"CellIdentifier"]) {
        AIMessageCell *temp = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [self updateCell:temp atIndexPath:indexPath];
        cell = temp;
    } else if([cellIdentifier isEqualToString:@"OtherCellIdentifier"]){
        AIMessageOtherCell *temp = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        [self updateOtherCell:temp atIndexPath:indexPath];
        cell = temp;
    }
    return cell;
}

- (void)updateGradient {
    __weak typeof(self) wself = self;
    [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(UICollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
        CGPoint p = cell.center;
        CGFloat positon = p.y - wself.collectionView.contentOffset.y;
        // add 120.0f to respond user's very fast scrolling.
        CGFloat relative = (positon/(CGRectGetHeight(wself.collectionView.frame)) - 0.5) * 2;
        
        cell.backgroundColor = [UIColor colorWithHue:0.084 - relative/16.0f saturation:0.900 brightness:1.000 alpha:1.000];
        [cell layoutSubviews];
    }];
}

- (IBAction)sendButtonDidTap:(id)sender {
    __weak typeof(self) wself = self;
    [self.collectionView performBatchUpdates:^{
        __strong typeof(self) sself = wself;
        NSDictionary *newItem = @{@"identifier" : @"CellIdentifier", @"message" : sself.textField.text};
        [sself.items addObject:newItem];
        [sself.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[sself.items count] -1 inSection:0]]];
    } completion:^(BOOL finished) {
        __strong typeof(self) sself = wself;
        sself.textField.text = @"";
        CGPoint bottomOffset = CGPointMake(0.0f, sself.collectionView.contentSize.height + sself.collectionView.contentInset.bottom - CGRectGetHeight(sself.collectionView.bounds));
        [sself.collectionView setContentOffset:bottomOffset animated:YES];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
       NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(newLength > 0) self.sendButton.enabled = YES;
    else self.sendButton.enabled = NO;
    return YES;
}
@end

