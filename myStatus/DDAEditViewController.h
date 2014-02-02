//
//  DDAEditViewController.h
//  myStatus
//
//  Created by Dulio Denis on 1/29/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

@class DDAEditViewController;

@protocol DDAEditViewControllerDelegate <NSObject>

@optional

- (void)editViewController:(DDAEditViewController *)editViewController didEditText:(NSString *)text;

@end


@interface DDAEditViewController : UIViewController

@property (nonatomic, weak) id<DDAEditViewControllerDelegate> delegate;
@property (nonatomic) NSString *text;

@end
