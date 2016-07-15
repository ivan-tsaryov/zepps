//
//  BubbleLine.m
//  zepps
//
//  Created by Ivan Tsaryov on 14/07/16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import "BubbleLine.h"

@interface BubbleLine () {
    CGFloat horizontalCenter;
    CGFloat verticalCenter;
}

@end

@implementation BubbleLine

- (instancetype)initWithFrame:(CGRect)frame coordX:(CGFloat)x coordY:(CGFloat)y {
    self = [super initWithFrame:frame];
    if (self) {
        horizontalCenter = x;
        verticalCenter = y;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2);
    
    [self fillLineWithContext:ctx];
    [self drawTriangleWithContext:ctx];
    [self drawStrokeWithContext:ctx];
}

/*
    Закрашивание всей линии белым цветом
 */
-(void)fillLineWithContext:(CGContextRef)ctx {
    CGContextSetAlpha(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, verticalCenter);
    CGContextAddLineToPoint(ctx, horizontalCenter * 2, verticalCenter);
    
    CGContextDrawPath(ctx, kCGPathStroke);
}

/*
    Рисование белого треугольника в  центре линии
 */
-(void)drawTriangleWithContext:(CGContextRef)ctx {
    CGColorRef whiteColor = [UIColor whiteColor].CGColor;
    CGContextSetAlpha(ctx, 1);
    CGContextSetFillColorWithColor(ctx, whiteColor);
    CGContextSetStrokeColorWithColor(ctx, whiteColor);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, horizontalCenter - 10, verticalCenter);
    CGContextAddLineToPoint(ctx, horizontalCenter, verticalCenter + 10);
    CGContextAddLineToPoint(ctx, horizontalCenter + 10, verticalCenter);
    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx,kCGPathFillStroke);
}

/*
    Рисование изогнутой в центре линии
 */
-(void)drawStrokeWithContext:(CGContextRef)ctx {
    CGContextSetAlpha(ctx, 0.2);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, verticalCenter);
    CGContextAddLineToPoint(ctx, horizontalCenter - 10, verticalCenter);
    CGContextAddLineToPoint(ctx, horizontalCenter, verticalCenter + 10);
    CGContextAddLineToPoint(ctx, horizontalCenter + 10, verticalCenter);
    CGContextAddLineToPoint(ctx, horizontalCenter * 2, verticalCenter);

    CGContextDrawPath(ctx, kCGPathStroke);
}

@end
