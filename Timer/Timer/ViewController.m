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
#import "AlarmViewController.h"
#import "WorldClockViewController.h"


@interface ViewController (){
    StopwatchViewController*    stopwatchViewController;
    TimerViewController*        timerViewController;
    AlarmViewController*        alarmViewController;
    WorldClockViewController*   worldClockViewController;
    __weak IBOutlet UIImageView *myView;
    
}
- (IBAction)changeView:(UIButton *)sender;

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


- (IBAction)changeView:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            stopwatchViewController = [[StopwatchViewController alloc] initWithNibName:nil bundle:nil];
            [self.view addSubview:stopwatchViewController.view];
            [UIView commitAnimations];
            break;
        case 2:
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            timerViewController = [[TimerViewController alloc] initWithNibName:nil bundle:nil];
            [self.view addSubview:timerViewController.view];
            [UIView commitAnimations];
            break;
        case 3:
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            alarmViewController = [[AlarmViewController alloc] initWithNibName:nil bundle:nil];
            [self.view addSubview:alarmViewController.view];
            [UIView commitAnimations];
            break;
        case 4:
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            worldClockViewController = [[WorldClockViewController alloc] initWithNibName:nil bundle:nil];
            [self.view addSubview:worldClockViewController.view];
            [UIView commitAnimations];
            break;
            
        default:
            break;
    }
}
@end
