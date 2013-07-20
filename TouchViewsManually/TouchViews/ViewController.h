//
//  ViewController.h
//  TouchViews
//
//  Created by Andrés Pesate on 7/18/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MyView.h"
#import "ScoreDelegate.h"
#import "PauseViewController.h"

@interface ViewController : UIViewController <MatchDelegate, GameStatusDelegate>

@property float score;
@property (strong, nonatomic) id <ScoreDelegate> delegate;

@end
