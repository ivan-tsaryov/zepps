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

@property (strong, nonatomic) NSMutableArray<UIView *> *lines;

@end

@implementation Scale

- (instancetype)initWithParentView:(UIView *)parentView {
    self = [super init];
    if (self) {
        _parentView = parentView;
        _lines = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)refreshScale:(NSMutableArray *)values maxNumber:(NSNumber *)num {
    for (UIView *v in self.lines) {
        [v removeFromSuperview];
    }
    
    for (int i = 0; i < values.count; i++) {
        ScaleItem *view = [[ScaleItem alloc] init];
        view.label.text = [values[i] getScaleFormattedString];
        [self.parentView addSubview:view];
        
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        int con = view.superview.bounds.size.height - view.superview.bounds.size.height*([values[i] floatValue]/[num floatValue]);
        
        //[self.parentView layoutIfNeeded];
        [self configureConstraints:con view:view];
        //[UIView animateWithDuration: 0.3f animations: ^{
            [self.parentView layoutIfNeeded];
        //}];
        
        
        [self.lines addObject: view];
    }

   
}

- (void)configureConstraints:(int) constant view:(UIView *)view {
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
                                  constant: constant
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
