//
//  WorldClockViewController.m
//  Timer
//
//  Created by Andrés Pesate on 7/14/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "WorldClockViewController.h"
#import "StopwatchViewController.h"
#import "AlarmViewController.h"
#import "TimerViewController.h"

@interface WorldClockViewController (){
    StopwatchViewController*    stopwatchViewController;
    AlarmViewController*        alarmViewController;
    TimerViewController*        timerViewController;
    __weak IBOutlet UILabel *myLabelUnder;
    __weak IBOutlet UILabel *myLabelConstruction;
    
}

@end

@implementation WorldClockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [myLabelUnder setFont:[UIFont fontWithName:@"Planks" size:40]];
    [myLabelConstruction setFont:[UIFont fontWithName:@"Planks" size:40]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeView:(UIButton *)sender {
    switch (sender.tag) {
        case 4:
            [self.view removeFromSuperview];
            break;
        case 5:
            [self.view removeFromSuperview];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            stopwatchViewController = [[StopwatchViewController alloc] initWithNibName:nil bundle:nil];
            [self.view addSubview:stopwatchViewController.view];
            [UIView commitAnimations];
            break;
        case 6:
            [self.view removeFromSuperview];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            timerViewController = [[TimerViewController alloc] initWithNibName:nil bundle:nil];
            [self.view addSubview:timerViewController.view];
            [UIView commitAnimations];
            break;
        case 7:
            [self.view removeFromSuperview];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            alarmViewController = [[AlarmViewController alloc] initWithNibName:nil bundle:nil];
            [self.view addSubview:alarmViewController.view];
            [UIView commitAnimations];
            break;
            
        default:
            break;
    }
}

@end
