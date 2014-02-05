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
@synthesize timeButton = _timeButton;


#pragma mark - timeButton Getter

- (UIButton *)timeButton {
    if (!_timeButton) {
        _timeButton = [[UIButton alloc] init];
        // _timeButton.backgroundColor = [UIColor redColor];
        _timeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
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


#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.contentView.bounds.size;
    CGSize buttonSize = CGSizeMake(60.0f, size.height);
    self.timeButton.frame = CGRectMake(size.width - buttonSize.width, 0.0f, buttonSize.width, buttonSize.height);
    
    CGRect frame = self.textLabel.frame;
    frame.size.width = size.width - frame.origin.x - 10.0f - buttonSize.width;
    self.textLabel.frame = frame;
    
}


#pragma mark - UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.timeButton];
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
    NSNumber *timeRemaining = self.goal[@"timeRemaining"];
    if (!timeRemaining) {
        [self.timeButton setTitle:@"🕗" forState:UIControlStateNormal];
        return;
    }

    UIColor *color;
    NSTimeInterval seconds = [self.goal[@"timeRemaining"] doubleValue];
    
    if (self.goal[@"startedTimingAt"]) {
        NSDate *startedTimingAt = self.goal[@"startedTimingAt"];
        NSTimeInterval difference = [[NSDate date] timeIntervalSinceDate:startedTimingAt];
        seconds -= difference;
        
        color = seconds >= 0 ? [UIColor greenColor] : [UIColor redColor];
    } else {
        color = [UIColor colorWithWhite:0.8f alpha:1.0f];
       // [_timeButton setTitleColor:[UIColor colorWithWhite:0.5f alpha:1.0f] forState:UIControlStateHighlighted];
    }
    
    NSString *time = [NSString stringWithFormat:@"%i", (NSInteger)seconds];
    [self.timeButton setTitle:time forState:UIControlStateNormal];
    [self.timeButton setTitleColor:color forState:UIControlStateNormal];
    [self.timeButton setTitleColor:[color colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
}


#pragma mark - UIGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    return CGRectContainsPoint(self.contentView.frame, point);
}

@end
