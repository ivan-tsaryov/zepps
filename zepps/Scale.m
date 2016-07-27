//
//  Scale.m
//  zepps
//
//  Created by Ivan Tsaryov on 24/07/16.
//  Copyright © 2016 Ivan Tsaryov. All rights reserved.
//

#import "Scale.h"
#import "ScaleItem.h"
#import "NSNCategory.h"

@interface Scale ()

@property (nonatomic, strong) UIView *parentView;

@property (strong, nonatomic) NSMutableArray<UIView *> *scaleLines;
@property (strong, nonatomic) NSMutableArray *scaleValues;

@property (strong, nonatomic) NSDictionary *dividers;

@property BOOL needChangeScales;
@property int prevIncrement;

@end

@implementation Scale

- (instancetype)initWithParentView:(UIView *)parentView {
    self = [super init];
    if (self) {
        self.parentView = parentView;
        self.scaleLines = [[NSMutableArray alloc] init];
        self.scaleValues = [[NSMutableArray alloc] init];
        
        self.dividers = @{@5 : @5000, @4 : @500, @3 : @50, @2 : @5, @1 : @1};
    }
    return self;
}

- (void)getScaleValuesWithMax:(NSNumber *)maxNumber {
    [self.scaleValues removeAllObjects];

    int increment = 0;
    float quarterOfMax = [maxNumber floatValue] / 5;
    
    NSUInteger numCount = [@(floor(quarterOfMax)) stringValue].length;
    
    int div = [[self.dividers objectForKey:[NSNumber numberWithUnsignedInteger: numCount]] intValue];
    
    quarterOfMax = quarterOfMax / div;
    increment = floor(quarterOfMax) * div;
    
    int temp = increment;
    [self.scaleValues addObject: @(temp)];
    
    while (([maxNumber integerValue] - temp) > increment) {
        temp = temp + increment;
        [self.scaleValues addObject: @(temp)];
    }
    
    self.needChangeScales = (increment != self.prevIncrement);
    self.prevIncrement = increment;
}

- (void)refreshScaleWithMax:(NSNumber *)maxNumber {
    [self getScaleValuesWithMax:maxNumber];
    
    //if (self.needChangeScales) {
        for (UIView *line in self.scaleLines) {
            [line removeFromSuperview];
        }
        [self.scaleLines removeAllObjects];
        
        
        [self.parentView layoutIfNeeded];
        for (int i = 0; i < self.scaleValues.count; i++) {
            ScaleItem *view = [[ScaleItem alloc] init];
            
            view.label.text = [self.scaleValues[i] getScaleFormattedString];
            [self.parentView addSubview:view];
            
            view.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.scaleLines addObject: view];
            
            int superViewHeight = view.superview.bounds.size.height;
            int shift = superViewHeight - superViewHeight * ([self.scaleValues[i] floatValue]/[maxNumber floatValue]);
            [self configureConstraints:shift view:view];
        }
    //}
}

- (void)configureConstraints:(int)shift view:(UIView *)view {
    [NSLayoutConstraint constraintWithItem: view
                                 attribute: NSLayoutAttributeLeading
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: view.superview
                                 attribute: NSLayoutAttributeLeading
                                multiplier: 1
                                  constant: 0
     ].active = true;
    
    [NSLayoutConstraint constraintWithItem: view
                                 attribute: NSLayoutAttributeTrailing
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: view.superview
                                 attribute: NSLayoutAttributeTrailing
                                multiplier: 1
                                  constant: 0
     ].active = true;
    
    [NSLayoutConstraint constraintWithItem: view
                                 attribute: NSLayoutAttributeTop
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: view.superview
                                 attribute: NSLayoutAttributeTop
                                multiplier: 1
                                  constant: shift
     ].active = true;
    
    [NSLayoutConstraint constraintWithItem: view
                                 attribute: NSLayoutAttributeHeight
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: nil
                                 attribute: NSLayoutAttributeNotAnAttribute
                                multiplier: 1
                                  constant: 16
     ].active = true;
}

@end
