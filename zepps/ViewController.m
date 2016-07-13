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

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

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
    [self normalizeChart];
}

- (void)configureCollectionView {
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    [self.collectionView setCollectionViewLayout:[[ChartLayout alloc] init]];
    //[self.collectionView setPagingEnabled: true];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self normalizeChart];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
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
    cell.frame = [self getNewFrameWithOffsetY: yOffset oldFrame: cell.frame];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.transform= CGAffineTransformMakeRotation(-M_PI_2);
    [titleLabel setText:cellData];
    
    return cell;
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
        
        float percent = 100;
        if (![self.maxNumberInVisible isEqual: @0]) {
            float over = [num floatValue];
            float to = [self.maxNumberInVisible floatValue];
            percent = over/to;
        }
        //NSLog(@"%@", self.maxNumberInVisible);
        NSLog(@"%@", num);
        
        [UIView animateWithDuration: 0.3f animations: ^{
            cell.frame = [self getNewFrameWithOffsetY: percent oldFrame: cell.frame];
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
