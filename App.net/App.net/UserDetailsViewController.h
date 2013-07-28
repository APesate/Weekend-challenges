//
//  UserDetailsViewController.h
//  App.net
//
//  Created by Andrés Pesate on 7/27/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PostsCell.h"

@interface UserDetailsViewController : UIViewController

@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) UIImage* userAvatar;
@property (strong, nonatomic) NSString* userID;

@end
