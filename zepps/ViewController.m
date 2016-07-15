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

@property (weak, nonatomic) IBOutlet UILabel *barNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *eightyPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixtyPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *fortyPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *twentyPercentLabel;

@property (weak, nonatomic) IBOutlet UIView *line;

@property (nonatomic, strong) ChartData *chartData;

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
    [self drawBubbleLine];
    
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

- (void)drawBubbleLine {
    BubbleLine *view = [[BubbleLine alloc] initWithFrame:self.view.bounds
                                                  coordX:self.line.frame.size.width/2
                                                  coordY:self.line.frame.origin.y + 1
                        ];
    view.userInteractionEnabled = NO;
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
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
    
    self.barNumberLabel.text = [self.chartData.dataArray[indexPath.row] stringValue];
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
    
    self.barNumberLabel.text = [self.chartData.dataArray[centerCellIndexPath.row] stringValue];
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:centerCellIndexPath];
    [self scrollToSelectedCell: cell];
}

- (void)normalizeChart {
    NSNumber *maxNumber = [NSNumber numberWithInt: 0];
    
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
        
        self.eightyPercentLabel.text = [self getShortNameOfNumber: [NSNumber numberWithFloat: [maxNumber floatValue]*0.8]];
        self.sixtyPercentLabel.text = [self getShortNameOfNumber: [NSNumber numberWithFloat: [maxNumber floatValue]*0.6]];
        self.fortyPercentLabel.text = [self getShortNameOfNumber: [NSNumber numberWithFloat: [maxNumber floatValue]*0.4]];
        self.twentyPercentLabel.text = [self getShortNameOfNumber: [NSNumber numberWithFloat: [maxNumber floatValue]*0.2]];
        
        [UIView animateWithDuration: 0.3f animations: ^{
            UIView *view = (UIView *) [cell viewWithTag: 50];
            view.frame = [self getNewFrameWithScale: barHeightScale basedOn: view.frame];
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(NSString *)getShortNameOfNumber:(NSNumber *)number {
    long shortNumber = [number longValue]/1000;
    
    if (shortNumber < 10) {
        return [NSString stringWithFormat: @"%li", [number longValue]];
    }
    
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
