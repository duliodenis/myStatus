//
//  DDAAppDelegate.m
//  myStatus
//
//  Created by Dulio Denis on 1/27/14.
//  Copyright (c) 2014 ddApps. All rights reserved.
//

#import "DDAAppDelegate.h"
#import "DDAListViewController.h"

@implementation DDAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *listViewController = [[DDAListViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:listViewController];
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
