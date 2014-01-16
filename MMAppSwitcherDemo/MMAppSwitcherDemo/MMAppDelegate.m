//
//  MMAppDelegate.m
//  MMAppSwitcherDemo
//
//  Created by Vinh Phuc Dinh on 15.01.14.
//  Copyright (c) 2014 Mocava Mobile. All rights reserved.
//

#import "MMAppDelegate.h"
#import "MMViewController.h"


@implementation MMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *viewController = [[MMViewController alloc] init];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
