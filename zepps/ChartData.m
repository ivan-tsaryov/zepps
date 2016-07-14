//
//  ChartData.m
//  zepps
//
//  Created by Ivan Tsaryov on 12.07.16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import "ChartData.h"
#import <stdlib.h>

NSInteger const kColCount = 50;
NSInteger const kNumCount = 100000;

@interface ChartData ()

@end

@implementation ChartData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < kColCount; i++) {
            id num = [[NSNumber alloc] initWithUnsignedInteger: arc4random_uniform(kNumCount)];
            //id num = [[NSNumber alloc] initWithInt: i];
            [self.dataArray addObject: num];
        }
    }
    return self;
}

@end
