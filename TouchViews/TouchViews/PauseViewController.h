//
//  PauseViewController.h
//  TouchViews
//
//  Created by Andrés Pesate on 7/19/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameStatusDelegate.h"

@interface PauseViewController : UIViewController

@property (strong, nonatomic) id <GameStatusDelegate> delegate;

@end
