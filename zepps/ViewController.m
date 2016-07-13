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
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) ChartData *chartData;

@property (nonatomic, strong) NSNumber *maxNumberInVisible;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.chartData = [[ChartData alloc] init];
    self.maxNumberInVisible = @0;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
//    NSMutableArray *firstSection = [[NSMutableArray alloc] init];
//    for (int i=0; i<50; i++) {
//        [firstSection addObject:[NSString stringWithFormat:@"Cell %d", i]];
//    }
    self.dataArray = [[NSArray alloc] initWithObjects:self.chartData.dataArray, nil];
    
    UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    
    [self.collectionView setCollectionViewLayout:[[ChartLayout alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *sectionArray = [self.dataArray objectAtIndex:section];
    return [sectionArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
    
    NSString *cellData = [[data objectAtIndex:indexPath.row] stringValue];
    
    static NSString *cellIdentifier = @"cvCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    
    [titleLabel setText:cellData];
    
    return cell;
    
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    self.maxNumberInVisible = @0;
//    
//    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
//        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
//        
//        NSNumber *num = [self.chartData.dataArray objectAtIndex:indexPath.row];
//        
//        if ([num doubleValue] > [self.maxNumberInVisible doubleValue]) {
//            self.maxNumberInVisible = num;
//        }
//        
//        float percent = 100;
//        if (![self.maxNumberInVisible isEqual: @0]) {
//            float over = [num floatValue];
//            float to = [self.maxNumberInVisible floatValue];
//            percent = over/to;
//        }
//        
//        cell.transform = CGAffineTransformIdentity;
//        cell.transform = CGAffineTransformScale(cell.transform, 1, percent);
//        NSLog(@"%@",num);
//    }
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat picDimension = self.view.frame.size.width / 4.0f;
//    return CGSizeMake(picDimension, picDimension);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    CGFloat leftRightInset = self.view.frame.size.width / 14.0f;
//    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset);
//}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSNumber *num = [self.chartData.dataArray objectAtIndex:indexPath.row];
//    //You may want to create a divider to scale the size by the way..
//    float percent = 100;
//    if (![self.maxNumberInVisible isEqual: @0]) {
//        float over = [num floatValue];
//        float to = [self.maxNumberInVisible floatValue];
//        percent = over/to;
//    }
//    
//    return CGSizeMake(50, self.collectionView.bounds.size.height*0.6f);
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
