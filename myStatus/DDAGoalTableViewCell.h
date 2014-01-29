//
//  DDAGoalTableViewCell.h
//  myStatus
//
//  Created by Dulio Denis on 1/28/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

@interface DDAGoalTableViewCell : UITableViewCell

@property (nonatomic) NSString *goal;
@property (nonatomic) BOOL completed;
@property (nonatomic) UITapGestureRecognizer *editGestureRecognizer;

@end