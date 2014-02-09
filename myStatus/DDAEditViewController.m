//
//  DDAEditViewController.m
//  myStatus
//
//  Created by Dulio Denis on 1/29/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "DDAEditViewController.h"
#import "DDAGoalTextField.h"
#import <SAMGradientView/SAMGradientView.h>
#import "UIColor+Extensions.h"

@interface DDAEditViewController () <UITextFieldDelegate>
@property (nonatomic, readonly) DDAGoalTextField *textField;
@property (nonatomic) CGRect keyboardFrame;
@end

@implementation DDAEditViewController

@synthesize textField = _textField;
@synthesize text = _text;


#pragma mark - Accessors

- (DDAGoalTextField *)textField {
    if (!_textField) {
        _textField = [[DDAGoalTextField alloc] init];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
    }
    return _textField;
}


- (void)setText:(NSString *)text {
    _text = text;
    self.textField.text = text;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Edit Goal";
    self.view.backgroundColor = [UIColor whiteColor];
    
    SAMGradientView *gradientView = [[SAMGradientView alloc] initWithFrame:self.view.bounds];
    gradientView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    gradientView.gradientColors = @[[UIColor DDABlue],
                                    [UIColor DDAOrange]];
    [self.view addSubview:gradientView];
    
    [self.view addSubview:self.textField];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    self.textField.frame = CGRectMake(0.0f, roundf((size.height - self.keyboardFrame.size.height + self.topLayoutGuide.length - 60.0f) / 2), size.width, 60.0f);
}


#pragma mark - Private Methods

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSValue *value = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    self.keyboardFrame = [value CGRectValue];
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    void (^animations)(void) = ^{
        [self viewDidLayoutSubviews];
    };
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.4 options:UIViewAnimationOptionCurveEaseIn animations:animations completion:nil];
}


#pragma mark - Actions

- (void)save:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editViewController:didEditText:)]) {
        [self.delegate editViewController:self didEditText:self.textField.text];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length == 0) {
        return NO;
    }

    [self save:textField];
    return NO;
}

@end
