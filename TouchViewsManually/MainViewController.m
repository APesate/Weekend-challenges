//
//  MainViewController.m
//  TouchViews
//
//  Created by Andrés Pesate on 7/19/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (){
    ViewController* viewController;
    __weak IBOutlet UILabel *actualScoreLabel;
}
- (IBAction)startGame:(id)sender;
- (IBAction)exitGame:(id)sender;

@end

@implementation MainViewController

@synthesize finalScore;

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
    
    viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    ScoreDelegate

-(void) howMuchWasTheScore:(float)score{
    [self setFinalScore:(self.finalScore + score)];
    [actualScoreLabel setText:[NSString stringWithFormat:@"%i", finalScore]];
}

-(float) howMuchIsTheScore{
    return finalScore;
}

- (IBAction)startGame:(id)sender {
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
        [self.view addSubview:viewController.view];
    } completion:NULL];
}

- (IBAction)exitGame:(id)sender {
}
@end
