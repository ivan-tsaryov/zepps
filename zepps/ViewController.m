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
#import "BubbleLine.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *selectorView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UIView *upperView;

@property (nonatomic, strong) ChartData *chartData;
@property (nonatomic, strong) NSNumber *maxNumberInVisible;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chartData = [[ChartData alloc] init];
    
    [self configureCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    BubbleLine *view = [[BubbleLine alloc] initWithFrame:self.upperView.bounds];
    view.backgroundColor = [UIColor clearColor];
    view.alpha = 0.1;
    
    [self.upperView addSubview:view];
    
    [self scrollToCenterCell];
    [self normalizeChart];
    
    self.selectorView.hidden = false;
}

- (void)configureCollectionView {
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    [self.collectionView setCollectionViewLayout:[[ChartLayout alloc] init]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.chartData.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cvCell";
    
    float barHeightScale = ([self.chartData.dataArray[indexPath.row] floatValue] / kNumCount);
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIView *view = (UIView *) [cell viewWithTag: 50];
    view.frame = [self getNewFrameWithScale: barHeightScale basedOn: view.frame];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath: indexPath];
    [self scrollToSelectedCell: cell];
    
    self.selectorView.hidden = false;
    
    self.numLabel.text = [self.chartData.dataArray[indexPath.row] stringValue];
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

- (CGRect)getNewFrameWithScale:(float)barHeightScale basedOn:(CGRect)baseFrame {
    CGRect newFrame = baseFrame;
    float frameHeight = newFrame.size.height;
    
    newFrame.origin.y = frameHeight-frameHeight*barHeightScale;
    
    return newFrame;
}

- (void)scrollToSelectedCell:(UICollectionViewCell *)cell {
    float inset = cell.frame.origin.x - self.collectionView.bounds.size.width/2 + 10;
    [self.collectionView setContentOffset: CGPointMake(inset, 0) animated:YES];
}

- (void)scrollToCenterCell {
    NSIndexPath *centerCellIndexPath = [self.collectionView indexPathForItemAtPoint: [self.view convertPoint:[self.view center] toView:self.collectionView]];
    
    self.numLabel.text = [self.chartData.dataArray[centerCellIndexPath.row] stringValue];
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:centerCellIndexPath];
    [self scrollToSelectedCell: cell];
}

- (void)normalizeChart {
    NSNumber *maxNumber = [NSNumber numberWithInt: 0];
    
    self.maxNumberInVisible = @0;
    
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        
        NSNumber *currentNumber = self.chartData.dataArray[indexPath.row];
        
        if ([currentNumber compare: maxNumber] == NSOrderedDescending) {
            maxNumber = currentNumber;
        }
    }
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        
        NSNumber *currentNumber = self.chartData.dataArray[indexPath.row];
  
        float barHeightScale = 1;
        if ([maxNumber compare: @0] == NSOrderedDescending) {
            barHeightScale = [currentNumber floatValue]/[maxNumber floatValue];
        }
        
        self.topLabel.text = [self getShortNameOfNumber: [NSNumber numberWithFloat: [maxNumber floatValue]*0.75]];
        self.middleLabel.text = [self getShortNameOfNumber: [NSNumber numberWithFloat: [maxNumber floatValue]*0.5]];
        self.bottomLabel.text = [self getShortNameOfNumber: [NSNumber numberWithFloat: [maxNumber floatValue]*0.25]];
        
        [UIView animateWithDuration: 0.3f animations: ^{
            UIView *view = (UIView *) [cell viewWithTag: 50];
            view.frame = [self getNewFrameWithScale: barHeightScale basedOn: view.frame];
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(NSString *)getShortNameOfNumber:(NSNumber *)number {
    long shortNumber = [number longValue]/1000;
    return [NSString stringWithFormat: @"%li тыс.", shortNumber];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
