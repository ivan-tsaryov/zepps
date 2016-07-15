//
//  ChartData.m
//  zepps
//
//  Created by Ivan Tsaryov on 12.07.16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import "ChartData.h"
#import <stdlib.h>

NSInteger const kColCount = 20000;
NSInteger const kNumCount = 100000;

@interface ChartData ()

@end

@implementation ChartData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < kColCount; i++) {
            [self.dataArray addObject: [self randomNumberBetween: 0 maxNumber: kNumCount]];
        }
    }
    return self;
}

- (NSNumber *)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max {
    long rndNumber = min + (arc4random_uniform((uint32_t)(max - min + 1)));
    
    return [NSNumber numberWithLong: rndNumber];
}

@end
