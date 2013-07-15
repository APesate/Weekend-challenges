//
//  AlarmViewController.m
//  Timer
//
//  Created by Andrés Pesate on 7/13/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "AlarmViewController.h"
#import "TimerViewController.h"
#import "StopwatchViewController.h"
#import "WorldClockViewController.h"

@interface AlarmViewController (){
    
    __weak IBOutlet UILabel *minutesLabel;
    __weak IBOutlet UILabel *hoursLabel;
    
    UIPickerView *alarmPicker;
    UIButton*   myModifyButton;
    UIButton*   mySaveButton;
    UIButton*   myOnOffButton;
    
    StopwatchViewController*              stopwatchViewController;
    TimerViewController*        timerViewController;
    WorldClockViewController*   worldClockViewController;
}
- (IBAction)changeView:(id)sender;

@end

@implementation AlarmViewController

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
    
    //Create Modify Button
    myModifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myModifyButton setFrame:CGRectMake(65, 340, 80, 43)];
    [myModifyButton.layer setCornerRadius:8];
    [myModifyButton setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0]];
    [myModifyButton setTitle:@"Modify" forState:UIControlStateNormal];
    [myModifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[myModifyButton titleLabel]setFont:[UIFont fontWithName:@"AmericanTypewriter" size:18]];
    [myModifyButton setTag:1];
    
    [myModifyButton addTarget:self action:@selector(onClickEvent:) forControlEvents:UIControlEventTouchDown];
    [myModifyButton addTarget:self action:@selector(onReleaseEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:myModifyButton];
    
    //Create Save Button
    mySaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mySaveButton setTitle:@"Save" forState:UIControlStateNormal];
    [mySaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[mySaveButton titleLabel]setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:18]];
    [mySaveButton setFrame:CGRectMake(65, 340, 80, 43)];
    [mySaveButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0]];
    [mySaveButton.layer setCornerRadius:8];
    [mySaveButton setTag:2];
    
    [mySaveButton addTarget:self action:@selector(onClickEvent:) forControlEvents:UIControlEventTouchDown];
    [mySaveButton addTarget:self action:@selector(onReleaseEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    //Create On<->Off Button
    myOnOffButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myOnOffButton setFrame:CGRectMake(170, 340, 80, 43)];
    [myOnOffButton setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]];
    [myOnOffButton setTitle:@"OFF" forState:UIControlStateNormal];
    [myOnOffButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[myOnOffButton titleLabel]setFont:[UIFont fontWithName:@"Courier" size:22]];
    [myOnOffButton.layer setCornerRadius:8];
    [myOnOffButton setTag:3];
    
    [myOnOffButton addTarget:self action:@selector(onClickEvent:) forControlEvents:UIControlEventTouchDown];
    [myOnOffButton addTarget:self action:@selector(onReleaseEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:myOnOffButton];
    
    alarmPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 590, 320, 216)];
    alarmPicker.delegate = self;
    alarmPicker.showsSelectionIndicator = YES;
    [self.view addSubview:alarmPicker];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 24;
    }else{
        return  60;
    }
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
    }
}


// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%i", row];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 150;
    
    return sectionWidth;
}

-(IBAction)onClickEvent:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            [myModifyButton setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
            break;
        case 2:
            [mySaveButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0]];
            break;
        case 3:
            if([[[myOnOffButton titleLabel] text] isEqualToString:@"OFF"]){
                [myOnOffButton setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
            }else{
                [myOnOffButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0]];
            }
            break;
            
        default:
            break;
    }
}

-(IBAction)onReleaseEvent:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
            [myModifyButton setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0]];
            [myModifyButton removeFromSuperview];
            [self.view addSubview:mySaveButton];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.8];
            

            [alarmPicker setFrame:CGRectMake(alarmPicker.bounds.origin.x, alarmPicker.bounds.origin.y + 290, alarmPicker.frame.size.width, alarmPicker.frame.size.height)];
            [mySaveButton setCenter:CGPointMake(mySaveButton.center.x, mySaveButton.center.y - 100)];
            [myOnOffButton setCenter:CGPointMake(myOnOffButton.center.x, myOnOffButton.center.y - 100)];
            
            [UIView commitAnimations];

            [myModifyButton setCenter:CGPointMake(myModifyButton.center.x, myModifyButton.center.y - 100)];
            
            break;
        case 2:
            [mySaveButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0]];
            [mySaveButton removeFromSuperview];
            [self.view addSubview:myModifyButton];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.8];
            
            
            [alarmPicker setFrame:CGRectMake(alarmPicker.bounds.origin.x, alarmPicker.bounds.origin.y + 590, alarmPicker.frame.size.width, alarmPicker.frame.size.height)];
            [myModifyButton setCenter:CGPointMake(myModifyButton.center.x, myModifyButton.center.y + 100)];
            [myOnOffButton setCenter:CGPointMake(myOnOffButton.center.x, myOnOffButton.center.y + 100)];
            
            [UIView commitAnimations];
            
            [mySaveButton setCenter:CGPointMake(mySaveButton.center.x, mySaveButton.center.y + 100)];
            break;
        case 3:
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.8];
            if([[[myOnOffButton titleLabel] text] isEqualToString:@"OFF"]){
                [myOnOffButton setBackgroundColor:[UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0]];
                [myOnOffButton setTitle:@"ON" forState:UIControlStateNormal];
                [[myOnOffButton titleLabel]setFont:[UIFont fontWithName:@"Courier-Bold" size:22]];
                [myOnOffButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                [myOnOffButton setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0]];
                [myOnOffButton setTitle:@"OFF" forState:UIControlStateNormal];
                [myOnOffButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [[myOnOffButton titleLabel]setFont:[UIFont fontWithName:@"Courier" size:22]];
            }
            [UIView commitAnimations];
            break;
            
        default:
            break;
    }
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
            worldClockViewController = [[WorldClockViewController alloc] initWithNibName:nil bundle:nil];
            [self.view addSubview:worldClockViewController.view];
            [UIView commitAnimations];
            break;
        default:
            break;
    }
}
@end
