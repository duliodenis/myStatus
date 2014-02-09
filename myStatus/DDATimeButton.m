//
//  DDATimeButton.m
//  myStatus
//
//  Created by Dulio Denis on 2/9/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "DDATimeButton.h"
#import "UIColor+Extensions.h"

@interface DDATimeButton()
@property (nonatomic, readonly) UIView *circleView;
@end

@implementation DDATimeButton


#pragma mark - Accessors

@synthesize time = _time;
@synthesize circleView  = _circleView;


- (void)setTime:(NSNumber *)time {
    _time = time;
    
    [self updateTime];
}


- (void)setTicking:(BOOL)ticking {
    _ticking = ticking;
    
    [self updateTime];
}


- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [[UIView alloc] init];
        _circleView.userInteractionEnabled = NO;
    }
    return _circleView;
}


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.circleView];
        self.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:13.0f];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self updateTime];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize buttonSize = self.bounds.size;
    self.circleView.frame = CGRectMake(roundf((buttonSize.width - 40.0f)/2.0f),
                                       roundf((buttonSize.height - 40.0f)/2.0f),
                                       40.0f,
                                       40.0f);
    self.circleView.layer.cornerRadius = self.circleView.bounds.size.height / 2.0f;
    
    //CGRect frame = self.titleLabel.frame;
    //frame.origin.y += 2.0f;
    self.titleLabel.frame =  CGRectInset(self.circleView.frame, 4.0f, 0.0f);
}


#pragma mark - Private

- (void)updateTime {
    if (self.time) {
        [self setImage:nil forState:UIControlStateNormal];
        [self setTitle:[self.time description] forState:UIControlStateNormal];
        
        if (self.ticking) {
            if ([self.time integerValue] > 0) {
                self.circleView.backgroundColor = [UIColor DDAGreen];
            } else {
                self.circleView.backgroundColor = [UIColor redColor];
            }
        } else {
            self.circleView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
        }
        return;
    }
    [self setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [self setTitle:nil forState:UIControlStateNormal];
    self.circleView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.05f];
}

@end
