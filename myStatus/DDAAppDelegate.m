//
//  DDAAppDelegate.m
//  myStatus
//
//  Created by Dulio Denis on 1/27/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "DDAAppDelegate.h"
#import "DDAListViewController.h"
#import "UIColor+Extensions.h"

@implementation DDAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationBar* navigationBar = [UINavigationBar appearance];
    navigationBar.barTintColor = [UIColor DDABlue];
    navigationBar.tintColor = [UIColor whiteColor];
    
    NSDictionary *heavyTitleAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSFontAttributeName: [UIFont fontWithName:@"Avenir-Heavy" size:20.0f]};
    NSDictionary *lightTitleAttributes = @{NSForegroundColorAttributeName: [UIColor DDAPaleWhite],
                                           NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:16.0f]};
    
    navigationBar.titleTextAttributes = heavyTitleAttributes;
    
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    [barButtonItem setTitleTextAttributes:lightTitleAttributes forState:UIControlStateNormal];
    
    UIViewController *listViewController = [[DDAListViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:listViewController];
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
