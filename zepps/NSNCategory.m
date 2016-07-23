//
//  NSNCategory.m
//  zepps
//
//  Created by Ivan Tsaryov on 23/07/16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import "NSNCategory.h"

@implementation NSNumber (NSNCategory)

-(NSString *)getScaleFormattedString {
    long shortNumber = [self longValue]/1000;

    
    if (shortNumber < 10) {
        return [NSString stringWithFormat: @"%li", [self longValue]];
    }
    
    return [NSString stringWithFormat: @"%li тыс.", shortNumber];
}

@end
