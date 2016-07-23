//
//  CViewCell.m
//  zepps
//
//  Created by Ivan Tsaryov on 23/07/16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import "CViewCell.h"

@implementation CViewCell

-(void)prepareForReuse {
    [super prepareForReuse];
}

-(void)updateCellFrame {
    CGRect newFrame = self.cellBar.frame;
    float currentHeight = newFrame.size.height;

    newFrame.origin.y = currentHeight - currentHeight * self.barHeightScale;

    self.cellBar.frame = newFrame;
}

@end
