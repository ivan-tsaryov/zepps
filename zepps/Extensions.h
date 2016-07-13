//
//  Extensions.h
//  zepps
//
//  Created by Ivan Tsaryov on 13/07/16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (Etended)
- (NSArray *)take:(NSInteger)to;
@end

@interface UIColor (Etended)
+ (UIColor *)randomColor;
@end

@interface NSArray (Reverse)
- (NSArray *)reversedArray;
@end
