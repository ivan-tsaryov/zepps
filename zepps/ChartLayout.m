

#import "ChartLayout.h"

NSInteger const kItemSize = 20;

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
    contentSize = CGSizeMake(kItemSize * self.numberOfItems, self.collectionView.frame.size.height);
    
    NSMutableArray *itemsAttr = [[NSMutableArray alloc] init];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];
    NSIndexPath *indexPath;
    
    for (NSInteger item = 0; item < itemCount; item++) {
        indexPath = [NSIndexPath indexPathForItem:item inSection: 0];
        
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = CGRectMake(indexPath.row * kItemSize, 0, kItemSize, self.collectionView.bounds.size.height);
        
        [itemsAttr addObject: attr];
    }
    attributes = itemsAttr;
}

- (CGSize)collectionViewContentSize {
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return attributes[indexPath.row];
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