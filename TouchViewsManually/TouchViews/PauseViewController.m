//
//  PauseViewController.m
//  TouchViews
//
//  Created by Andrés Pesate on 7/19/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "PauseViewController.h"

@interface PauseViewController ()
- (IBAction)resumeGame:(id)sender;
- (IBAction)resetGame:(id)sender;
- (IBAction)goToMainMenu:(id)sender;

@end

@implementation PauseViewController

@synthesize delegate;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resumeGame:(id)sender {
    [delegate resumeGame];
    [self.view removeFromSuperview];
}

- (IBAction)resetGame:(id)sender {
    [delegate resetGame];
    [self.view removeFromSuperview];
}

- (IBAction)goToMainMenu:(id)sender {
    [delegate gotoMainMenu];
    [self.view removeFromSuperview];
}
@end
