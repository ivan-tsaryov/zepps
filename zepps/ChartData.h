//
//  ChartData.h
//  zepps
//
//  Created by Ivan Tsaryov on 12.07.16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const kColCount;
extern NSInteger const kNumCount;

@interface ChartData : NSObject

@property (nonatomic, strong) NSMutableArray<NSNumber *> *data;

@end
