//
//  StopwatchViewController.m
//  Timer
//
//  Created by Andrés Pesate on 7/11/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "StopwatchViewController.h"
#import "TimerViewController.h"
#import "AlarmViewController.h"
#import "WorldClockViewController.h"

@interface StopwatchViewController (){
    
    __weak IBOutlet UILabel *milisecondsLabel;
    __weak IBOutlet UILabel *hourLabel;
    __weak IBOutlet UILabel *minutesLabel;
    __weak IBOutlet UILabel *secondsLabel;
    __weak IBOutlet UITextView *lapsTextView;
    __weak IBOutlet UILabel *colonHMLabel;
    __weak IBOutlet UILabel *colonMSLabel;
    
    UIButton*       myStopButton;
    UIButton*       myStartButton;
    UIButton*       myResetButton;
    UIButton*       myLapButton;
    NSTimer*        timer;
    NSTimer*        colonTimer;
    NSFileManager*  fileManager;
    NSString*       newLap;
    NSDateFormatter* dateFormat;
    
    int             numberOfLaps;
    
    TimerViewController*        timerViewController;
    AlarmViewController*        alarmViewController;
    WorldClockViewController*   worldClockViewController;

}

@end

@implementation StopwatchViewController

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
    
    colonTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(colonIntermitent) userInfo:nil repeats:YES];
    
    numberOfLaps = 0;
    [milisecondsLabel setFont:[UIFont fontWithName:@"Symbol" size:15]];
    [secondsLabel setFont:[UIFont fontWithName:@"Symbol" size:50]];
    [minutesLabel setFont:[UIFont fontWithName:@"Symbol" size:50]];
    [hourLabel setFont:[UIFont fontWithName:@"Symbol" size:50]];
    
    
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    //Create Start Button
    myStartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myStartButton setFrame:CGRectMake(20, 233, 132, 43)];
    [myStartButton setTitle:@"Start" forState:UIControlStateNormal];
    [myStartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[myStartButton titleLabel] setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20]];
    [myStartButton setBackgroundColor: [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0]];
    [myStartButton.layer setCornerRadius:8];
    [myStartButton setTag:1];
    
    [myStartButton addTarget:self action:@selector(onClickColor:) forControlEvents:UIControlEventTouchDown];
    [myStartButton addTarget:self action:@selector(onReleaseColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myStartButton];
    
    //Create Stop Button
    myStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myStopButton setFrame:CGRectMake(20, 233, 132, 43)];
    [myStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [myStopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[myStopButton titleLabel] setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20]];
    [myStopButton setBackgroundColor: [UIColor redColor]];
    [myStopButton.layer setCornerRadius:8];
    [myStopButton setTag:2];
    
    [myStopButton addTarget:self action:@selector(onClickColor:) forControlEvents:UIControlEventTouchDown];
    [myStopButton addTarget:self action:@selector(onReleaseColor:) forControlEvents:UIControlEventTouchUpInside];
    
    //Create Reset Button
    myResetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myResetButton setFrame:CGRectMake(155, 233, 132, 43)];
    [myResetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [myResetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[myResetButton titleLabel] setFont:[UIFont fontWithName:@"Courier" size:20]];
    [myResetButton setBackgroundColor: [UIColor lightGrayColor]];
    [myResetButton.layer setCornerRadius:8];
    [myResetButton setTag:3];
    
    [myResetButton addTarget:self action:@selector(onClickColor:) forControlEvents:UIControlEventTouchDown];
    [myResetButton addTarget:self action:@selector(onReleaseColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myResetButton];
    
    //Create Lap Button
    myLapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myLapButton setFrame:CGRectMake(155, 233, 132, 43)];
    [myLapButton setTitle:@"Add Lap" forState:UIControlStateNormal];
    [myLapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[myLapButton titleLabel] setFont:[UIFont fontWithName:@"Courier" size:20]];
    [myLapButton setBackgroundColor: [UIColor lightGrayColor]];
    [myLapButton.layer setCornerRadius:8];
    [myLapButton setTag:4];
    
    [myLapButton addTarget:self action:@selector(onClickColor:) forControlEvents:UIControlEventTouchDown];
    [myLapButton addTarget:self action:@selector(onReleaseColor:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)colonIntermitent{
    [colonHMLabel setEnabled:!(colonHMLabel.enabled)];
    [colonMSLabel setEnabled:!(colonMSLabel.enabled)];
}

-(void)stopwatch{
    
    [milisecondsLabel setText:[NSString stringWithFormat:@"%@%i", [milisecondsLabel.text integerValue]+1>9?@"":@"0",[milisecondsLabel.text integerValue] + 1]];
    
    if ([[milisecondsLabel text] integerValue]>99) {
        [milisecondsLabel setText:@"00"];
        [secondsLabel setText:[NSString stringWithFormat:@"%@%i", [secondsLabel.text integerValue]+1>9?@"":@"0",[secondsLabel.text integerValue] + 1]];
        
        if ([[secondsLabel text] integerValue]>59) {
            [secondsLabel setText:@"00"];
            [minutesLabel setText:[NSString stringWithFormat:@"%@%i", [minutesLabel.text integerValue]+1>9?@"":@"0",[minutesLabel.text integerValue] + 1]];
            
            if ([[minutesLabel text] integerValue]>59) {
                [minutesLabel setText:@"00"];
                [hourLabel setText:[NSString stringWithFormat:@"%@%i", [hourLabel.text integerValue]+1>9?@"":@"0",[hourLabel.text integerValue] + 1]];
            }
        }
    }
}

-(IBAction)onReleaseColor:(UIButton*)sender{
    switch (sender.tag) {
        case 1:
            [sender setBackgroundColor:[UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0]];
            [myStartButton removeFromSuperview];
            [self.view addSubview:myStopButton];
            [self.view addSubview:myLapButton];
            [myResetButton removeFromSuperview];
            timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(stopwatch) userInfo:nil repeats:YES];
            break;
        case 2:
            [sender setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1.0]];
            [myStopButton removeFromSuperview];
            [self.view addSubview:myStartButton];
            [timer invalidate];
            timer = nil;
            [self.view addSubview:myResetButton];
            [myLapButton removeFromSuperview];
            break;
        case 3:
            [sender setBackgroundColor:[UIColor lightGrayColor]];
            [milisecondsLabel setText:@"00"];
            [secondsLabel setText:@"00"];
            [minutesLabel setText:@"00"];
            [hourLabel setText:@"00"];
            [lapsTextView setText:@""];
            numberOfLaps = 0;
            break;
        case 4:
            [sender setBackgroundColor:[UIColor lightGrayColor]];
            numberOfLaps +=1;
            newLap = [NSString stringWithFormat:@"%@        %@:%@:%@               Lap: %i",[dateFormat stringFromDate:[NSDate date]], hourLabel.text, minutesLabel.text, secondsLabel.text, numberOfLaps];
            [lapsTextView setText:[NSString stringWithFormat:@"%@ %@", lapsTextView.text, newLap]];
            break;
            
        default:
            
            break;
            


    }
}

-(IBAction)onClickColor:(UIButton*)sender{
    switch (sender.tag) {
        case 1:
            [sender setBackgroundColor:[UIColor colorWithRed:0 green:0.5 blue:0 alpha:1.0]];
            break;
        case 2:
            [sender setBackgroundColor:[UIColor colorWithRed:0.5 green:0 blue:0 alpha:1.0]];
            break;
        case 3:
            [sender setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
            break;
        case 4:
            [sender setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeView:(UIButton *)sender {
    switch (sender.tag) {
        case 5:
            [self.view removeFromSuperview];
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
            
        case 8:
            [self.view removeFromSuperview];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
            worldClockViewController = [[WorldClockViewController alloc] initWithNibName:nil bundle:nil];
            [self.view addSubview:worldClockViewController.view];
            [UIView commitAnimations];
            break;
            break;
        default:
            break;
    }
}

@end
