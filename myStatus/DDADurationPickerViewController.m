//
//  DDADurationPickerViewController.m
//  myStatus
//
//  Created by Dulio Denis on 2/2/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "DDADurationPickerViewController.h"
#import <SAMGradientView/SAMGradientView.h>
#import "UIColor+Extensions.h"

@interface DDADurationPickerViewController ()
@property (nonatomic, readonly) UIDatePicker *datePicker;
@end

@implementation DDADurationPickerViewController

@synthesize datePicker = _datePicker;
@synthesize duration = _duration;


#pragma mark - DatePicker Accessor

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        _datePicker.tintColor = [UIColor whiteColor];
        _datePicker.backgroundColor = [UIColor DDAPaleWhite];
    }
    return _datePicker;
}


- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    self.datePicker.countDownDuration = _duration;
}


#pragma mark - UIViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Time";
    self.view.backgroundColor = [UIColor whiteColor];
    
    SAMGradientView *gradientView = [[SAMGradientView alloc] initWithFrame:self.view.bounds];
    gradientView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    gradientView.gradientColors = @[[UIColor DDABlue],
                                    [UIColor DDAOrange]];
    [self.view addSubview:gradientView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    UILabel *instructions = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, self.topLayoutGuide.length, 300.0f, 200.0f)];
    instructions.text = @"Pick a time for your streak reminder.";
    instructions.textAlignment = NSTextAlignmentCenter;
    instructions.textColor = [UIColor whiteColor];
    
    [self.view addSubview:instructions];
    [self.view addSubview:self.datePicker];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.datePicker sizeToFit];
    
    CGRect frame = self.datePicker.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height;
    self.datePicker.frame = frame;
}


#pragma mark - Actions

- (void)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)done:(id)sender {
    if ([self.delegate respondsToSelector:@selector(durationPickerViewController:didPickDuration:)]) {
        [self.delegate durationPickerViewController:self didPickDuration:self.datePicker.countDownDuration];
    }
    [self cancel:sender];
}

@end
