//
//  DDAGoalTableViewCell.m
//  myStatus
//
//  Created by Dulio Denis on 1/28/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "DDAGoalTableViewCell.h"

@implementation DDAGoalTableViewCell

@synthesize goal = _goal;
@synthesize completed = _completed;
@synthesize editGestureRecognizer = _editGestureRecognizer;


#pragma mark - Instance Variable Setter

- (void)setGoal:(NSString *)goal {
    _goal = goal;
    
    self.textLabel.text = goal;
}

- (void)setCompleted:(BOOL)completed {
    _completed = completed;
    
    if (_completed) {
        self.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.textLabel.textColor = [UIColor blackColor];
    }
}


#pragma mark - UITapGestureRecognizer Method

- (UITapGestureRecognizer *)editGestureRecognizer {
    if (_editGestureRecognizer == nil) {
        _editGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        _editGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_editGestureRecognizer];
    }
    return _editGestureRecognizer;
}


#pragma mark - setEditing on TableViewCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.editGestureRecognizer.enabled = editing;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    return CGRectContainsPoint(self.contentView.frame, point);
}

@end
