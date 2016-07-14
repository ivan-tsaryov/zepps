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

@interface ViewController () {
    int visibleItemsCount;
}

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
    visibleItemsCount = self.collectionView.bounds.size.width/20;
    
    BubbleLine *view = [[BubbleLine alloc] initWithFrame:self.upperView.bounds];
    view.backgroundColor = [UIColor clearColor];
    view.alpha = 0.1;
    
    [self.upperView addSubview:view];
    
    [self normalizeChart];
}

- (void)configureCollectionView {
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    [self.collectionView setCollectionViewLayout:[[ChartLayout alloc] init]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    NSIndexPath *centerCellIndexPath =
    [self.collectionView indexPathForItemAtPoint:
     [self.view convertPoint:[self.view center] toView:self.collectionView]];
    [self.collectionView scrollToItemAtIndexPath: centerCellIndexPath atScrollPosition: UICollectionViewScrollPositionCenteredHorizontally animated: YES];
    
    [self normalizeChart];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self normalizeChart];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.chartData.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellData = [[self.chartData.dataArray objectAtIndex:indexPath.row] stringValue];
    
    static NSString *cellIdentifier = @"cvCell";

    double yOffset = ([self.chartData.dataArray[indexPath.row] floatValue] / kNumCount);
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIView *view = (UIView *) [cell viewWithTag: 50];
    
    view.frame = [self getNewFrameWithOffsetY: yOffset oldFrame: view.frame];
    //cell.frame = [self getNewFrameWithOffsetY: yOffset oldFrame: cell.frame];
    
//    UILabel *titleLabel = (UILabel *)[cell viewWithTag:60];
//    titleLabel.transform= CGAffineTransformMakeRotation(-M_PI_2);
//    [titleLabel setText:cellData];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //int inset = (int)(floor(visibleItemsCount/2) - indexPath.row+1)*20 ;
    
    //self.collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    //UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    self.selectorView.hidden = false;
    NSNumber *num = [self.chartData.dataArray objectAtIndex:indexPath.row];
    self.numLabel.text = [num stringValue];
    
    [self.collectionView scrollToItemAtIndexPath: indexPath atScrollPosition: UICollectionViewScrollPositionCenteredHorizontally animated: YES];
    [self normalizeChart];
    
    //self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//   self.selectorView.hidden = true;
}

/*
 Смещает ячейку в зависимости от offset (в процентах)
 */
- (CGRect)getNewFrameWithOffsetY:(float)offset oldFrame:(CGRect)oldFrame {
    CGRect newFrame = oldFrame;
    float frameHeight = newFrame.size.height;
    
    newFrame.origin.y = frameHeight-frameHeight*offset;
    
    return newFrame;
}

- (void)normalizeChart {
    self.maxNumberInVisible = @0;
    
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        
        NSNumber *num = [self.chartData.dataArray objectAtIndex:indexPath.row];
        
        if ([num doubleValue] > [self.maxNumberInVisible doubleValue]) {
            self.maxNumberInVisible = num;
        }
    }
    
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        
        NSNumber *num = [self.chartData.dataArray objectAtIndex:indexPath.row];
        
        float percent = 1;
        if (![self.maxNumberInVisible isEqual: @0]) {
            float over = [num floatValue];
            float to = [self.maxNumberInVisible floatValue];
            percent = over/to;
        }
        //NSLog(@"MAX NUMBER %@", self.maxNumberInVisible);
        NSLog(@"%@", num);
        
        self.topLabel.text = [NSString stringWithFormat: @"%f", [self.maxNumberInVisible floatValue]*0.75];
        self.middleLabel.text = [NSString stringWithFormat: @"%f", [self.maxNumberInVisible floatValue]*0.5];
        self.bottomLabel.text = [NSString stringWithFormat: @"%f", [self.maxNumberInVisible floatValue]*0.25];
        
        [UIView animateWithDuration: 0.3f animations: ^{
            UIView *view = (UIView *) [cell viewWithTag: 50];
            view.frame = [self getNewFrameWithOffsetY: percent oldFrame: view.frame];
            //cell.frame = [self getNewFrameWithOffsetY: percent oldFrame: cell.frame];
        } completion:^(BOOL finished) {
            
        }];
    }
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
