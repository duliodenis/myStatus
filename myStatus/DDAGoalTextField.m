//
//  DDAGoalTextField.m
//  myStatus
//
//  Created by Dulio Denis on 1/30/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "DDAGoalTextField.h"

@implementation DDAGoalTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.93f alpha:1.0f];
        self.layer.cornerRadius =  5.0f; // nice rounded rect
        self.returnKeyType = UIReturnKeyGo;
        self.placeholder = @"Enter a goal to accomplish";

    }
    return self;
}


- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    return CGRectInset(rect, 8.0f, 0.0f);
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end
