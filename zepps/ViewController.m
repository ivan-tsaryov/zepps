//
//  ViewController.m
//  zepps
//
//  Created by Ivan Tsaryov on 13/07/16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import "ViewController.h"
#import "ChartData.h"
#import "ChartLayout.h"
#import "CViewCell.h"
#import "NSNCategory.h"
#import "Scale.h"

NSString * const cellIdentifier = @"cvCell";

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (weak, nonatomic) IBOutlet UIView *selectorView;

@property (weak, nonatomic) IBOutlet UILabel *barNumberLabel;

@property (nonatomic, strong) ChartData *chartData;
@property (strong, nonatomic) Scale *scale;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chartData = [[ChartData alloc] init];
    self.scale = [[Scale alloc] initWithParentView:self.bottomView];
    
    [self configureCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self scrollToCenterCell];
    [self normalizeChart];
    
    self.selectorView.hidden = NO;
}

- (void)configureCollectionView {
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:[NSBundle mainBundle]];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView setCollectionViewLayout:[[ChartLayout alloc] init]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.chartData.data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.barHeightScale = ([self.chartData.data[indexPath.row] floatValue] / kNumCount);
    [cell updateCellFrame];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CViewCell *cell = (CViewCell *)[collectionView cellForItemAtIndexPath: indexPath];
    [self scrollToSelectedCell: cell];
    
    self.selectorView.hidden = NO;
    
    self.barNumberLabel.text = [self.chartData.data[indexPath.row] stringValue];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollToCenterCell];
    [self normalizeChart];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollToCenterCell];
    [self normalizeChart];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self normalizeChart];
}

- (void)scrollToSelectedCell:(UICollectionViewCell *)cell {
    float inset = cell.frame.origin.x - self.collectionView.bounds.size.width / 2 + kItemSize / 2;
    [self.collectionView setContentOffset: CGPointMake(inset, 0) animated:YES];
}

- (void)scrollToCenterCell {
    NSIndexPath *centerCellIndexPath = [self.collectionView indexPathForItemAtPoint: [self.view convertPoint:[self.view center] toView:self.collectionView]];
    
    self.barNumberLabel.text = [self.chartData.data[centerCellIndexPath.row] stringValue];
    
    CViewCell *cell = (CViewCell *)[self.collectionView cellForItemAtIndexPath:centerCellIndexPath];
    [self scrollToSelectedCell: cell];
}

- (void)normalizeChart {
    NSNumber *maxNumber = [NSNumber numberWithInt: 0];
    
    for (CViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        NSNumber *currentNumber = self.chartData.data[indexPath.row];
        
        if ([currentNumber compare: maxNumber] == NSOrderedDescending) {
            maxNumber = currentNumber;
        }
    }
    for (CViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        NSNumber *currentNumber = self.chartData.data[indexPath.row];
  
        if ([maxNumber compare: @0] == NSOrderedDescending) {
            cell.barHeightScale = [currentNumber floatValue]/[maxNumber floatValue];
        }
        
        [UIView animateWithDuration: 0.3f animations: ^{
            [cell updateCellFrame];
            
        } completion:^(BOOL finished) {
            [self.scale refreshScaleWithMax:maxNumber];
        }];
    }
}

@end
