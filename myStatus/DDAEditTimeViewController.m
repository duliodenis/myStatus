//
//  DDAEditTimeViewController.m
//  myStatus
//
//  Created by Dulio Denis on 2/1/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "DDAEditTimeViewController.h"

@interface DDAEditTimeViewController ()
@property (nonatomic, readonly) UIDatePicker *datePicker;
@end

@implementation DDAEditTimeViewController

@synthesize datePicker = _datePicker;


#pragma mark - DatePicker Accessor

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    }
    return _datePicker;
}

#pragma mark - UIViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Time";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    UILabel *instructions = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, self.topLayoutGuide.length, 280.0f, 200.0f)];
    instructions.text = @"Pick a time duration for your goal.";
    instructions.textAlignment = NSTextAlignmentCenter;
    
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
    [self cancel:sender];
}

@end
