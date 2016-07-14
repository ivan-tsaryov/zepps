//
//  BubbleLine.m
//  zepps
//
//  Created by Ivan Tsaryov on 14/07/16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import "BubbleLine.h"

@implementation BubbleLine

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float startPositionX = rect.origin.x;
    float endPositionX = rect.size.width;
    float middlePositionX = rect.size.width/2;
    
    [path moveToPoint:CGPointMake(startPositionX, 150.0)];
    [path addLineToPoint:CGPointMake(middlePositionX - 10, 150.0)];
    [path addLineToPoint:CGPointMake(middlePositionX, 160.0)];
    [path addLineToPoint:CGPointMake(middlePositionX + 10, 150.0)];
    [path addLineToPoint:CGPointMake(endPositionX, 150.0)];
    path.lineWidth = 2;
    [[UIColor blackColor] setStroke];
    [path stroke];
}

@end
