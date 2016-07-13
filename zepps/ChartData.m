//
//  ChartData.m
//  zepps
//
//  Created by Ivan Tsaryov on 12.07.16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import "ChartData.h"
#import <stdlib.h>

NSInteger const kColCount = 20;
NSInteger const kNumCount = 1000;

@interface ChartData ()

@end

@implementation ChartData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.chartData = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < kColCount; i++) {
            id num = [[NSNumber alloc] initWithUnsignedInteger: arc4random_uniform(kNumCount)];
            
            [self.chartData addObject: num];
        }
    }
    return self;
}

@end
