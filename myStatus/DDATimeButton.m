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
        _circleView.layer.cornerRadius = 20.0f;
    }
    return _circleView;
}


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.circleView];
        
        // use to see placement of timeButton in its view
        // self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
        
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

    [self.titleLabel sizeToFit];
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = roundf((buttonSize.width - titleFrame.size.width) / 2.0f);
    titleFrame.origin.y = roundf((buttonSize.height - titleFrame.size.height) / 2.0f);
    self.titleLabel.frame = titleFrame;

    self.circleView.frame = CGRectMake(MIN(roundf((buttonSize.width - 40.0f)/2.0f), titleFrame.origin.x - 8.0f),
                                       roundf((buttonSize.height - 40.0f)/2.0f),
                                       MAX(40.0f, titleFrame.size.width + 16.0f),
                                       40.0f);
}

- (CGSize)sizeThatFits:(CGSize)size {
    [self layoutSubviews];
    
    size.width = self.circleView.bounds.size.width + 20.0f;
    return size;
}


#pragma mark - Private

- (void)updateTime {
    if (self.time) {
        [self setImage:nil forState:UIControlStateNormal];
        
        NSString *title;
        NSTimeInterval timeInterval = [self.time doubleValue];
        
        if (self.ticking) {
            NSMutableString *timeFormat = [[NSMutableString alloc] init];
        
            if (timeInterval < 0) {
                [timeFormat appendString:@"-"];
            }
            
            if (fabsf(timeInterval) > 60 * 60) {
                [timeFormat appendString:@"hh:"];
            }
            
            [timeFormat appendString:@"mm:ss"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = timeFormat;
            dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            title = [dateFormatter stringFromDate:date];
            
            if ([self.time integerValue] > 0) {
                self.circleView.backgroundColor = [UIColor DDAGreen];
            } else {
                self.circleView.backgroundColor = [UIColor redColor];
            }
        } else {
            NSMutableString *text = [[NSMutableString alloc] init];
            if (fabs(timeInterval) < 60) {
                // Show Seconds
                [text appendFormat:@"%.0fs", timeInterval];
                
            } else if (fabsf(timeInterval) < 60 * 60) {
                // Show Minutes
                [text appendFormat:@"%.0fm", floorf(timeInterval / 60)];
            } else {
                // Show Hours
                [text appendFormat:@"%.0fh", floorf(timeInterval / 60 / 60)];
            }
            title = text;
            self.circleView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
        }
        [self setTitle:title forState:UIControlStateNormal];
        return;
    }
    [self setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [self setTitle:nil forState:UIControlStateNormal];
    self.circleView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.05f];
}

@end
