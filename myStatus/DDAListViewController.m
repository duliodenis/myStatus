//
//  DDAListViewController.m
//  myStatus
//
//  Created by Dulio Denis on 1/27/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "DDAListViewController.h"

@interface DDAListViewController () <UITextFieldDelegate>

@property (nonatomic) NSMutableArray *goals;
@property (nonatomic) NSMutableArray *accomplishments;

@end

@implementation DDAListViewController


#pragma mark - UIViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 260.0f, 32.0f)];
    textField.returnKeyType = UIReturnKeyGo;
    textField.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    textField.placeholder = @"Enter a goal to accomplish";
    self.navigationItem.titleView = textField;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"✏️"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(toggleEdit:)];

    textField.delegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *loadedGoals = [userDefaults arrayForKey:@"goals"];
    self.goals = [[NSMutableArray alloc] initWithArray:loadedGoals];
    
    NSArray *loadedAccomplishments = [userDefaults arrayForKey:@"accomplishments"];
    self.accomplishments = [[NSMutableArray alloc] initWithArray:loadedAccomplishments];
    
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
        self.navigationItem.rightBarButtonItem.title = @"✅";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"✏️";
    }
}


#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.goals insertObject:textField.text atIndex:0];

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self arrayForSection:indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        cell.textLabel.textColor = [UIColor blackColor];
    } else if (indexPath.section == 1) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self arrayForSection:indexPath.section] removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
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

@end
