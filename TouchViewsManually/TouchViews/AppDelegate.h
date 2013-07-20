//
//  AppDelegate.h
//  TouchViews
//
//  Created by Andrés Pesate on 7/18/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *mainViewController;

@end
