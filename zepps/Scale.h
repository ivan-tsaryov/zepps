//
//  Scale.h
//  zepps
//
//  Created by Ivan Tsaryov on 24/07/16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Scale : NSObject

-(instancetype)initWithParentView:(UIView *)parentView;
-(void)refreshScaleWithMax:(NSNumber *)maxNumber;

@end
