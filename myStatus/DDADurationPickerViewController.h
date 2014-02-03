//
//  DDADurationPickerViewController.h
//  myStatus
//
//  Created by Dulio Denis on 2/2/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

@protocol DDADurationPickerViewControllerDelegate;

@interface DDADurationPickerViewController : UIViewController
@property (nonatomic, weak) id<DDADurationPickerViewControllerDelegate> delegate;
@property (nonatomic) NSTimeInterval duration;
@end

@protocol DDADurationPickerViewControllerDelegate <NSObject>

@optional
- (void)durationPickerViewController:(DDADurationPickerViewController *)editTimeViewController
           didPickDuration:(NSTimeInterval)timeInterval;

@end