//
//  DDAGoalTextField.m
//  myStatus
//
//  Created by Dulio Denis on 1/30/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "DDAGoalTextField.h"
#import "UIColor+Extensions.h"

@implementation DDAGoalTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
        // self.layer.cornerRadius =  5.0f; // nice rounded rect
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.returnKeyType = UIReturnKeyGo;
        self.font = [UIFont fontWithName:@"Avenir" size:18.0f];
        self.tintColor = [UIColor DDAOrange];
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
