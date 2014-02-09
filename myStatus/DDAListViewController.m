//
//  DDAListViewController.m
//  myStatus
//
//  Created by Dulio Denis on 1/27/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "DDAListViewController.h"
#import "DDAGoalTableViewCell.h"
#import "DDAEditViewController.h"
#import "DDAGoalTextField.h"
#import "DDADurationPickerViewController.h"
#import "UIColor+Extensions.h"

#import <SAMGradientView/SAMGradientView.h>

@interface DDAListViewController () <UITextFieldDelegate, DDAEditViewControllerDelegate, DDADurationPickerViewControllerDelegate>

@property (nonatomic) NSMutableArray *goals;
@property (nonatomic) NSMutableArray *accomplishments;
@property (nonatomic) NSIndexPath *editingIndexPath;
@property (nonatomic, readonly) DDAGoalTextField *textField;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSIndexPath *tickingIndexPath;

@end

@implementation DDAListViewController


#pragma mark - Accessors

@synthesize textField = _textField;
@synthesize timer = _timer;


- (DDAGoalTextField *)textField {
    if (!_textField) {
        _textField = [[DDAGoalTextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 60.0f)];
        _textField.delegate = self;
    }
    return _textField;
}


- (void)setTimer:(NSTimer *)timer {
    if (_timer != timer) { // pointer comparison
        [_timer invalidate];
    }
    
    _timer = timer;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:_timer != nil];
}


#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[DDAGoalTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    SAMGradientView *gradientView = [[SAMGradientView alloc] init];
    gradientView.gradientColors = @[[UIColor DDABlue],
                                    [UIColor DDAOrange]];
    self.tableView.backgroundView = gradientView;
    self.tableView.separatorColor = [UIColor DDAPaleWhite];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.rowHeight = 60.0f;
    
    // self.navigationItem.titleView = self.textField;
    self.navigationItem.title = @"Status";
    self.tableView.tableHeaderView = self.textField;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(toggleEdit:)];
    [self setEditing:NO animated:NO];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *loadedGoals = [userDefaults arrayForKey:@"goals"];
    self.goals = [[NSMutableArray alloc] initWithArray:loadedGoals];
    
    for (NSInteger i = 0; i < self.goals.count; i++) {
        NSDictionary *goal = self.goals[i];
        
        if (goal[@"startedTimingAt"]) {
            [self startTimingIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    
    NSArray *loadedAccomplishments = [userDefaults arrayForKey:@"accomplishments"];
    self.accomplishments = [[NSMutableArray alloc] initWithArray:loadedAccomplishments];
    
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
        [self.textField resignFirstResponder];
        
        self.navigationItem.rightBarButtonItem.title = @"Done";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"Edit";
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - UITextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setEditing:NO animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length == 0) {
        textField.text = nil;
        [textField resignFirstResponder];
        return NO;
    }
    
    NSDictionary *goal = @{
        @"text": textField.text
    };
    
    [self.goals insertObject:goal atIndex:0];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    textField.text = nil;
    
    [self save];
    return NO;
}


#pragma mark - UITableViewDataSource Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self arrayForSection:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDAGoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.editGestureRecognizer addTarget:self action:@selector(editGoal:)];
    [cell.timeButton addTarget:self action:@selector(time:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    // cell.goal = [self arrayForSection:indexPath.section][indexPath.row];
    cell.goal = [self goalForIndexPath:indexPath];
    cell.completed = indexPath.section == 1;
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self arrayForSection:indexPath.section] removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self save];
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath {
    NSMutableArray *array = [self arrayForSection:fromIndexPath.section];
    
    NSString *goal = array[fromIndexPath.row];
    [array removeObjectAtIndex:fromIndexPath.row];
    [array insertObject:goal atIndex:toIndexPath.row];
    [tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    [self save];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return NO;
    }
    return YES;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView beginUpdates];
    
    // Tapped an unachieved goal. Time to make it an accomplishment.
    if (indexPath.section == 0) {
        NSString *accomplishment = self.goals[indexPath.row];
        [self.goals removeObjectAtIndex:indexPath.row];
        [self.accomplishments insertObject:accomplishment atIndex:0];
        
        NSIndexPath *accomplishmentsIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [tableView insertRowsAtIndexPaths:@[accomplishmentsIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    // Tapped an accomplishment. Time to make it a goal to complete again.
    else {
        NSString *goal = self.accomplishments[indexPath.row];
        [self.accomplishments removeObjectAtIndex:indexPath.row];
        [self.goals insertObject:goal atIndex:0];
        
        NSIndexPath *goalIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [tableView insertRowsAtIndexPaths:@[goalIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [tableView endUpdates];
    [self save];
}


#pragma mark - BarButton Actions

- (void)toggleEdit:(id)sender {
    [self setEditing:!self.editing animated:YES];
}


#pragma mark - Private Actions

- (void)save {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.goals forKey:@"goals"];
    [userDefault setObject:self.accomplishments forKey:@"accomplishments"];
    [userDefault synchronize];
}


- (NSMutableArray *)arrayForSection:(NSInteger)section {
    if (section == 0) {
        return self.goals;
    }
    return self.accomplishments;
}


- (void) editGoal: (UITapGestureRecognizer *)sender {
    self.editingIndexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender.view];
    
    NSLog(@"Edit Goal: %@", [self arrayForSection:self.editingIndexPath.section][self.editingIndexPath.row]);
    
    DDAEditViewController *editViewController = [[DDAEditViewController alloc] init];
    editViewController.delegate = self;
    editViewController.text = [self goalForIndexPath:self.editingIndexPath][@"text"];
    [self.navigationController pushViewController:editViewController animated:YES];
    [self setEditing:NO animated:YES];
}


- (void)time:(id)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    [touch locationInView:self.tableView];
    CGPoint point = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];

    NSDictionary *goal = [self goalForIndexPath:indexPath];
    NSNumber *timeRemaining = goal[@"timeRemaining"];
    
    // Goal has timer, tick.
    if (timeRemaining) {
        // Already ticking. Stop.
        if ([indexPath isEqual:self.tickingIndexPath]) {
            [self stopTimingIndexPath:indexPath];
        }
        
        // Start ticking.
        else {
            if (self.tickingIndexPath) {
                [self stopTimingIndexPath:indexPath];
            }
            
            [self setGoalValue:[NSDate date] forKey:@"startedTimingAt" atIndexPath:indexPath];
            [self startTimingIndexPath:indexPath];
        }
        
        return;
    }
    
    // Goal does not have time - so allow picking
    self.editingIndexPath = indexPath;
    DDADurationPickerViewController *editTimeViewController = [[DDADurationPickerViewController alloc] init];
    editTimeViewController.delegate = self;
    editTimeViewController.duration = [goal[@"timeRemaining"] doubleValue];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editTimeViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}


- (void)tick:(id)sender {
    if (!self.tickingIndexPath) {
        return;
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[self.tickingIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSDictionary *)goalForIndexPath:(NSIndexPath *)indexPath {
    return [self arrayForSection:indexPath.section][indexPath.row];
}


- (void)setGoal:(NSDictionary *)goal forIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = [self arrayForSection:indexPath.section];
    array[indexPath.row] = goal;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self save];
}


- (void)setGoalValue:(id)value forKey:(NSString *)key atIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *goal = [[self goalForIndexPath:indexPath] mutableCopy];
    goal[key] = value;
    
    [self setGoal:goal forIndexPath:indexPath];
}


- (void)startTimingIndexPath:(NSIndexPath *)indexPath {
    self.tickingIndexPath = indexPath;
    self.timer = [NSTimer timerWithTimeInterval:1
                                         target:self
                                       selector:@selector(tick:)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)stopTimingIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *goal = [self goalForIndexPath:indexPath];
    NSDate *startedTimingAt = goal[@"startedTimingAt"];
    NSTimeInterval difference = [[NSDate date] timeIntervalSinceDate:startedTimingAt];
    NSTimeInterval timeRemaining = [goal[@"timeRemaining"] doubleValue];
    
    NSMutableDictionary *saved = [goal mutableCopy];
    saved[@"timeRemaining"] = @(timeRemaining - difference);
    [saved removeObjectForKey:@"startedTimingAt"];
    [self setGoal:saved forIndexPath:indexPath];
    //            [self setGoalValue:@(timeRemaining - difference) forKey:@"timeRemaining" atIndexPath:indexPath];
    
    self.timer = nil;
    self.tickingIndexPath = nil;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - DDEEditViewControllerDelegate

- (void)editViewController:(DDAEditViewController *)editViewController didEditText:(NSString *)text {
//    NSLog(@"Edited goal: %@", goal);
//    [self setGoal:goal forIndexPath:self.editingIndexPath];
    [self setGoalValue:text forKey:@"text" atIndexPath:self.editingIndexPath];
}


#pragma mark - DDADurationPickerViewController Delegate

- (void)durationPickerViewController:(DDADurationPickerViewController *)editTimeViewController
               didPickDuration:(NSTimeInterval)duration {
    [self setGoalValue:@(duration) forKey:@"timeRemaining" atIndexPath:self.editingIndexPath];
}

@end
