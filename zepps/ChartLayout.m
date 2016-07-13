

#import "ChartLayout.h"

#define kItemSize 20

@interface ChartLayout () {
    CGSize contentSize;
    NSArray *attributes;
}

@end

@implementation ChartLayout

- (NSInteger)numberOfItems {
    id<UICollectionViewDataSource> dataSource = self.collectionView.dataSource;
    return [dataSource collectionView:self.collectionView numberOfItemsInSection:0];
}

- (void)prepareLayout {
    [super prepareLayout];
}

- (CGSize)collectionViewContentSize {
    contentSize = CGSizeMake(kItemSize * self.numberOfItems*2, self.collectionView.frame.size.height);
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectMake(indexPath.row*kItemSize, 0, kItemSize, self.collectionView.bounds.size.height);
    return attr;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger firstObject = MIN(rect.origin.y / kItemSize, 0);
    NSInteger lastObject = MAX((rect.origin.y + rect.size.height) / kItemSize, self.numberOfItems);
    NSMutableArray *attrs = [NSMutableArray new];
    for (NSInteger i = firstObject; i < lastObject; i++)
        [attrs addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    return attrs;
}

@end