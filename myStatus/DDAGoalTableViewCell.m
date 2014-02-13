//
//  DDAGoalTableViewCell.m
//  myStatus
//
//  Created by Dulio Denis on 1/28/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "DDAGoalTableViewCell.h"
#import "DDATimeButton.h"
#import "UIColor+Extensions.h"

@implementation DDAGoalTableViewCell

@synthesize goal = _goal;
@synthesize completed = _completed;
@synthesize editGestureRecognizer = _editGestureRecognizer;
@synthesize timeButton = _timeButton;


#pragma mark - timeButton Getter

- (DDATimeButton *)timeButton {
    if (!_timeButton) {
        _timeButton = [[DDATimeButton alloc] init];
        // _timeButton.backgroundColor = [UIColor redColor];
        // _timeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _timeButton;
}


#pragma mark - Instance Variables Setters

- (void)setGoal:(NSDictionary *)goal {
    _goal = goal;
    
    self.textLabel.text = goal[@"text"];
    
    [self updateTimeButton];
}


- (void)setCompleted:(BOOL)completed {
    _completed = completed;
    
    self.timeButton.hidden = _completed;
    
    if (_completed) {
        self.textLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    } else {
        self.textLabel.textColor = [UIColor whiteColor];
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


#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.contentView.bounds.size;
    CGSize buttonSize = [self.timeButton sizeThatFits:CGSizeMake(60.0f, size.height)];
    self.timeButton.frame = CGRectMake(size.width - buttonSize.width, 0.0f, buttonSize.width, buttonSize.height);
    
    CGRect frame = self.textLabel.frame;
    frame.size.width = size.width - frame.origin.x - 10.0f - buttonSize.width;
    self.textLabel.frame = frame;
    
}


#pragma mark - UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.timeButton];
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.font = [UIFont fontWithName:@"Avenir" size:20.f];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor DDAGreen];
        self.selectedBackgroundView = view;
    }
    return self;
}


- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.goal = nil;
}


#pragma mark - setEditing on UITableViewCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.editGestureRecognizer.enabled = editing;
    // self.timeButton.alpha = editing ? 0.0f : 1.0f; // Leave the time button on during editing
}


#pragma mark - Private

- (void)updateTimeButton {
    // Check if we are ticking.
    self.timeButton.ticking = self.goal[@"startedTimingAt"] != nil;
    
    // If there's no time set then set the time to nil and ticking to false and return
    NSNumber *timeRemaining = self.goal[@"timeRemaining"];
    if (!timeRemaining) {
        self.timeButton.time = nil;
        self.timeButton.ticking = NO;
        return;
    }

    // Get the time
    NSTimeInterval seconds = [self.goal[@"timeRemaining"] doubleValue];

    // Offset the time if necessary
    if (self.timeButton.ticking) {
        NSDate *startedTimingAt = self.goal[@"startedTimingAt"];
        NSTimeInterval difference = [[NSDate date] timeIntervalSinceDate:startedTimingAt];
        seconds -= difference;
    }
    
    // Set the time
    self.timeButton.time = @(seconds);
}


#pragma mark - UIGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    return CGRectContainsPoint(self.contentView.frame, point);
}

@end
