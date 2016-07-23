//
//  CViewCell.h
//  zepps
//
//  Created by Ivan Tsaryov on 23/07/16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *cellBar;

@property float barHeightScale;

-(void)updateCellFrame;

@end
