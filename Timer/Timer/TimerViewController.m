//
//  TimerViewController.m
//  Timer
//
//  Created by Andrés Pesate on 7/13/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "TimerViewController.h"
#import "StopwatchViewController.h"

@interface TimerViewController (){
    
    __weak IBOutlet UIPickerView *numberPicker;
    __weak IBOutlet UILabel *secondsLabel;
    __weak IBOutlet UILabel *minutesLabel;
    __weak IBOutlet UILabel *hoursLabel;
    
    UIButton*   myStartButton;
    UIButton*   myStopButton;
    UIButton*   myResetButton;
    UIButton*   myContinueButton;
    NSTimer*    timer;
 
    StopwatchViewController*    stopwatchViewController;
    SystemSoundID*  soundPlayer;
}
- (IBAction)goBack:(id)sender;
- (IBAction)goToStopwatch:(id)sender;

@end

@implementation TimerViewController

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
    
    //Create Continue Button
    myContinueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myContinueButton setFrame:CGRectMake(20, 333, 132, 43)];
    [myContinueButton setTitle:@"Continue" forState:UIControlStateNormal];
    [myContinueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myContinueButton setBackgroundColor: [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0]];
    [myContinueButton.layer setCornerRadius:8];
    [myContinueButton setTag:1];
    
    [myContinueButton addTarget:self action:@selector(onClickColor:) forControlEvents:UIControlEventTouchDown];
    [myContinueButton addTarget:self action:@selector(onReleaseColor:) forControlEvents:UIControlEventTouchUpInside];
    
    //Create Stop Button
    myStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myStopButton setFrame:CGRectMake(20, 233, 132, 43)];
    [myStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [myStopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    [myResetButton setBackgroundColor: [UIColor lightGrayColor]];
    [myResetButton.layer setCornerRadius:8];
    [myResetButton setTag:3];
    
    [myResetButton addTarget:self action:@selector(onClickColor:) forControlEvents:UIControlEventTouchDown];
    [myResetButton addTarget:self action:@selector(onReleaseColor:) forControlEvents:UIControlEventTouchUpInside];
    
    //Create Start Button
    myStartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myStartButton setFrame:CGRectMake(20, 233, 267, 43)];
    [myStartButton setTitle:@"Start" forState:UIControlStateNormal];
    [myStartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [myStartButton setBackgroundColor: [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0]];
    [myStartButton.layer setCornerRadius:8];
    [myStartButton setTag:4];
    
    [myStartButton addTarget:self action:@selector(onClickColor:) forControlEvents:UIControlEventTouchDown];
    [myStartButton addTarget:self action:@selector(onReleaseColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myStartButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        if(row < 10){
            [hoursLabel setText:[NSString stringWithFormat:@"0%i", row]];
        }else{
            [hoursLabel setText:[NSString stringWithFormat:@"%i", row]];            
        }
    }else if(component == 1){
        if(row < 10){
            [minutesLabel setText:[NSString stringWithFormat:@"0%i", row]];
        }else{
            [minutesLabel setText:[NSString stringWithFormat:@"%i", row]];
        }
    }else{
        if(row < 10){
            [secondsLabel setText:[NSString stringWithFormat:@"0%i", row]];
        }else{
            [secondsLabel setText:[NSString stringWithFormat:@"%i", row ]];
        }
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 24;
    }else{
        return  60;
    }
}


// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%i", row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 100;
    
    return sectionWidth;
}

-(BOOL) countDownValidation{
    if ([hoursLabel.text integerValue] == 0 && [minutesLabel.text integerValue] == 0 && [secondsLabel.text integerValue] == 0) {
        [timer invalidate];
        timer = nil;
        
        [myStartButton setCenter:CGPointMake(myStartButton.center.x, myStartButton.center.y + 100)];
        [self.view addSubview:myStartButton];
        
        [myStopButton setCenter:CGPointMake(myStopButton.center.x, myStopButton.center.y - 100)];
        [myResetButton setCenter:CGPointMake(myResetButton.center.x, myResetButton.center.y - 100)];
        
        [myStopButton removeFromSuperview];
        [myResetButton removeFromSuperview];
        [myContinueButton removeFromSuperview];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.8];
        
        [numberPicker setBounds:CGRectMake(numberPicker.bounds.origin.x, numberPicker.bounds.origin.y + 300, numberPicker.frame.size.width, numberPicker.frame.size.height)];
        [myStartButton setCenter:CGPointMake(myStartButton.center.x, myStartButton.center.y - 100)];
        
        
       /* NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Sound Path" ofType:@"mp3"];
        CFURLRef soundURL = (__bridge CFURLRef)[NSURL fileURLWithPath:soundPath];
        AudioServicesCreateSystemSoundID(soundURL, soundPlayer);
        
        AudioServicesPlaySystemSound(*(soundPlayer));*/

        return YES;
    }
    return NO;
}

-(void) timerCountDown{
    
    if(!self.countDownValidation){
        [secondsLabel setText:[NSString stringWithFormat:@"%@%i", ([secondsLabel.text integerValue] - 1)<10?@"0":@"",([secondsLabel.text integerValue] - 1)]];
        if ([secondsLabel.text isEqualToString:@"0-1"]) {
            [minutesLabel setText:[NSString stringWithFormat:@"%@%i", ([minutesLabel.text integerValue] - 1)<10?@"0":@"",([minutesLabel.text integerValue] - 1)]];
            [secondsLabel setText:@"59"];
        }
        if ([minutesLabel.text isEqualToString:@"0-1"]) {
            [hoursLabel setText:[NSString stringWithFormat:@"%@%i", ([hoursLabel.text integerValue] - 1)<10?@"0":@"",([hoursLabel.text integerValue] - 1)]];
            [minutesLabel setText:@"59"];
        }
    }
}

-(IBAction)onReleaseColor:(UIButton*)sender{
    switch (sender.tag) {
        case 1:
            [sender setBackgroundColor:[UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0]];
            [myContinueButton removeFromSuperview];
            [self.view addSubview:myStopButton];
            [self.view addSubview:myResetButton];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
            break;
        case 2:
            [sender setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1.0]];
            [myStopButton removeFromSuperview];
            [self.view addSubview:myContinueButton];
            [timer invalidate];
            timer = nil;
            break;
        case 3:
            [sender setBackgroundColor:[UIColor lightGrayColor]];
            
            if([numberPicker selectedRowInComponent:0] < 10){
                [hoursLabel setText:[NSString stringWithFormat:@"0%i", [numberPicker selectedRowInComponent:0]]];
            }else{
                [hoursLabel setText:[NSString stringWithFormat:@"%i", [numberPicker selectedRowInComponent:0]]];
            }
            if([numberPicker selectedRowInComponent:1] < 10){
                [minutesLabel setText:[NSString stringWithFormat:@"0%i", [numberPicker selectedRowInComponent:1]]];
            }else{
                [minutesLabel setText:[NSString stringWithFormat:@"%i", [numberPicker selectedRowInComponent:1]]];
            }
            if([numberPicker selectedRowInComponent:2] < 10){
                [secondsLabel setText:[NSString stringWithFormat:@"0%i", [numberPicker selectedRowInComponent:2]]];
            }else{
                [secondsLabel setText:[NSString stringWithFormat:@"%i", [numberPicker selectedRowInComponent:2]]];
            }

            [timer invalidate];
            timer = nil;
            
            [myStartButton setCenter:CGPointMake(myStartButton.center.x, myStartButton.center.y + 100)];
            [self.view addSubview:myStartButton];
            
            [myStopButton setCenter:CGPointMake(myStopButton.center.x, myStopButton.center.y - 100)];
            [myResetButton setCenter:CGPointMake(myResetButton.center.x, myResetButton.center.y - 100)];
            
            [myStopButton removeFromSuperview];
            [myResetButton removeFromSuperview];
            [myContinueButton removeFromSuperview];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.8];
            
            [numberPicker setBounds:CGRectMake(numberPicker.bounds.origin.x, numberPicker.bounds.origin.y + 300, numberPicker.frame.size.width, numberPicker.frame.size.height)];
            [myStartButton setCenter:CGPointMake(myStartButton.center.x, myStartButton.center.y - 100)];
            
            [UIView commitAnimations];
            
            break;
        case 4:
            [sender setBackgroundColor:[UIColor colorWithRed:0 green:0.8 blue:0 alpha:1.0]];
            if ([hoursLabel.text integerValue] != 00 || [minutesLabel.text integerValue] != 00 || [secondsLabel.text integerValue] != 00) {
                [myStartButton removeFromSuperview];
                [self.view addSubview:myStopButton];
                [self.view addSubview:myResetButton];
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];

                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.8];
                
                [numberPicker setBounds:CGRectMake(numberPicker.bounds.origin.x, numberPicker.bounds.origin.y - 300, numberPicker.frame.size.width, numberPicker.frame.size.height)];
                [myStopButton setCenter:CGPointMake(myStopButton.center.x, myStopButton.center.y + 100)];
                [myResetButton setCenter:CGPointMake(myResetButton.center.x, myResetButton.center.y + 100)];
                
                [UIView commitAnimations];
                
                //[numberPicker removeFromSuperview];
            }
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
            [sender setBackgroundColor:[UIColor colorWithRed:0 green:0.5 blue:0 alpha:1.0]];
            break;
            
        default:
            break;
    }
}

- (IBAction)goBack:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)goToStopwatch:(id)sender {
    [self.view removeFromSuperview];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    stopwatchViewController = [[StopwatchViewController alloc] initWithNibName:nil bundle:nil];
    [self.view addSubview:stopwatchViewController.view];
    [UIView commitAnimations];
}
@end
