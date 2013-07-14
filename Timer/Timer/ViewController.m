//
//  ViewController.m
//  Timer
//
//  Created by Andrés Pesate on 7/11/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "ViewController.h"
#import "StopwatchViewController.h"
#import "TimerViewController.h"


@interface ViewController (){
    StopwatchViewController*    stopwatchViewController;
    TimerViewController*        timerViewController;
    
}
- (IBAction)openStopwatchView:(id)sender;
- (IBAction)openTimerView:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openStopwatchView:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    stopwatchViewController = [[StopwatchViewController alloc] initWithNibName:nil bundle:nil];
    [self.view addSubview:stopwatchViewController.view];
    [UIView commitAnimations];
}

- (IBAction)openTimerView:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    timerViewController = [[TimerViewController alloc] initWithNibName:nil bundle:nil];
    [self.view addSubview:timerViewController.view];
    [UIView commitAnimations];
}
@end
