//
//  ViewController.m
//  TouchViews
//
//  Created by Andrés Pesate on 7/18/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    __weak IBOutlet UILabel *pairsLeftLabel;
    __weak IBOutlet UILabel *missesLabel;
    __weak IBOutlet UILabel *minutesLabel;
    __weak IBOutlet UILabel *secondsLabel;
    __weak IBOutlet UILabel *scoreLabel;
    UIButton*   pauseButton;
    UIView*     goodGuess;
    UIView*     missMatch;
    PauseViewController* pauseViewController;
    MyView*     firstSelection;
    NSMutableArray* cardsArray; //Array that contains all of MyViews
    NSArray*        imagesArray; //Array that contains all of the images availables
    NSTimer*        timer;
    BOOL    firstTurn;
    BOOL    timerRun;
    BOOL    canPickCard;

}


@end

@implementation ViewController

@synthesize delegate, score;

typedef void(^animationBlock)(BOOL);

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initObjects];
    [self createViews];
    [self makePairs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark    Initialize Objects

-(void) initObjects{
    cardsArray = [NSMutableArray arrayWithCapacity:16];
    
    imagesArray = @[[[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Andres Castillo.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Antonio Grimaldo.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Brad Woodard.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Brandon Passley.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Brian Dinh.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Don Bora.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Eddie Kang.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Jeremy Herrero.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Jess Sturme.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Joel Arcos.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Juliana Caccavo.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Kin Divisual.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Margarita Escaño.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Maxim Wheatley.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Norm Gershon.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Ryan Striker.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Stephan Duggan.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Thom Duncan.jpg"]],
                    [[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"Umut Kanbak.jpg"]]];
    
    pauseViewController = [[PauseViewController alloc] initWithNibName:nil bundle:nil];
    pauseViewController.delegate = self;
    firstTurn = YES;
    canPickCard = YES;
    timerRun = NO;
    
    pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pauseButton setFrame:CGRectMake(220, 440, 69, 44)];
    [pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    [pauseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [[pauseButton titleLabel] setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20]];
    [pauseButton setBackgroundColor: [UIColor cyanColor]];
    [pauseButton.layer setCornerRadius:8];
    [pauseButton addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchDown];
    [pauseButton addTarget:self action:@selector(onReleaseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseButton];
    
    goodGuess = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - 30, self.view.center.y - 50, 180, 174)];
    [goodGuess setBackgroundColor:[[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"ThumbUp.png"]]];
    [goodGuess setAlpha:0];
    
    missMatch = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - 30, self.view.center.y - 50, 179, 179)];
    [missMatch setBackgroundColor:[[UIColor alloc] initWithPatternImage:[self makeFrameForImage:@"ThumbDown.png"]]];
    [missMatch setAlpha:0];
}

-(UIImage *) makeFrameForImage:(NSString *)imageName{
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:CGRectMake(0, 0, 69, 70)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

-(void) createViews{
    int x = 0, y = 0;
    
    for (int i = 0; i< 16; i++) {
        [cardsArray addObject:[[MyView alloc] initWithFrame:CGRectMake(10 + x, 80 + y, 69, 70)]];
        [((MyView *)[cardsArray objectAtIndex:i]) setDelegate:self];
        [self.view addSubview:[cardsArray objectAtIndex:i]];
        
        if(x >= 228){
            x = 0;
            y += 84;
        }else{
            x += 76;
        }
    }
}

-(void)timePass{
     [secondsLabel setText:[NSString stringWithFormat:@"%@%i", [secondsLabel.text integerValue]+1>9?@"":@"0",[secondsLabel.text integerValue] + 1]];
    if([secondsLabel.text integerValue] == 60){
        [secondsLabel setText:@"00"];
        [minutesLabel setText:[NSString stringWithFormat:@"%@%i", [minutesLabel.text integerValue]+1>9?@"":@"0",[minutesLabel.text integerValue] + 1]];
    }
}

-(void)makePairs{
    int j = 0, x = 0;
    BOOL repeated = NO;
    NSNumber* imageNumber = 0;
    NSMutableArray* selectedImages = [NSMutableArray arrayWithCapacity:8];
    
    for(int i = 1; i <= 8; i++){
        //Make the selection of two random cards in the cardsArray
        do{
            j = arc4random()%16;
        }while (((MyView *)[cardsArray objectAtIndex:j]).tag != 0);
        
        do{
            x = arc4random()%16;
        }while (((MyView *)[cardsArray objectAtIndex:x]).tag != 0 || j==x);
        NSLog(@"Pair %i: %i - %i", i, j, x);
    
        //Make the selection of a random image in the imagesArray
        do {
            imageNumber = [NSNumber numberWithInt:arc4random()%19];
            
            for (int i = 0; i < ((NSInteger)[selectedImages count]); i++ ) {
                if([[selectedImages objectAtIndex:i] isEqualToNumber:imageNumber]){
                    repeated = YES;
                    break;
                }else{
                    repeated = NO;
                }
            }
        } while (repeated);
        
        [selectedImages addObject:imageNumber];
        
        ((MyView *)[cardsArray objectAtIndex:j]).tag = i;
        ((MyView *)[cardsArray objectAtIndex:j]).cardColor = [imagesArray objectAtIndex:[imageNumber integerValue]];
        
        ((MyView *)[cardsArray objectAtIndex:x]).tag = i;
        ((MyView *)[cardsArray objectAtIndex:x]).cardColor = [imagesArray objectAtIndex:[imageNumber integerValue]];
    }
    
}

#pragma mark ChangeCardsStatus

-(void)changeStatus:(MyView *)senderView{
    [self flipAnimation:firstSelection];
    [self flipAnimation:senderView];
    canPickCard = YES;
    senderView.isFaceDown = YES;
    firstSelection.isFaceDown = YES;
}


-(void) flipAnimation:(MyView *)senderView{
    [UIView animateWithDuration:0.8 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:senderView cache:YES];
        [UIView commitAnimations];
        
        if(![senderView isFaceDown]){
            [senderView setBackgroundColor:[[UIColor alloc] initWithPatternImage:senderView.faceDownImage]];
        }else{
            senderView.backgroundColor = senderView.cardColor;
        }    }];
}

#pragma mark    MatchDelegate
-(void)didChooseView:(MyView *)senderView{
    
    if(!timerRun){
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timePass) userInfo:nil repeats:YES];
        timerRun = YES;
    }
    
    if(senderView.isFaceDown){
        if(canPickCard){
            if(firstTurn){
                firstSelection = senderView;
                [self flipAnimation:firstSelection];
                firstSelection.isFaceDown = NO;
                firstTurn = NO;
            }else{
                //timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(changeColor:) userInfo:senderView repeats:YES];
                [self flipAnimation:senderView];
                canPickCard = NO;
                senderView.isFaceDown = NO;
                
                if(!(firstSelection.tag == senderView.tag)){
                    missesLabel.text = [NSString stringWithFormat:@"%i", [missesLabel.text integerValue] + 1];
                    [self performSelector:@selector(changeStatus:) withObject:senderView afterDelay:1.0f];
                    score -= 100;
                    [UIView animateWithDuration:1.0 animations:^{
                        [self.view addSubview:missMatch];
                        [missMatch setAlpha:1.0];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:1.0 animations:^{
                            [missMatch setAlpha:0.0];
                        } completion:^(BOOL finished){
                            [missMatch removeFromSuperview];
                        }];
                    }];
                }else{
                    [UIView animateWithDuration:1.0 animations:^{
                        [self.view addSubview:goodGuess];
                        [goodGuess setAlpha:1.0];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:1.0 animations:^{
                            [goodGuess setAlpha:0.0];
                        } completion:^(BOOL finished){
                            [goodGuess removeFromSuperview];
                        }];
                    }];
                    pairsLeftLabel.text = [NSString stringWithFormat:@"%i", [pairsLeftLabel.text integerValue] - 1];
                    senderView.isFaceDown = NO;
                    firstSelection.isFaceDown = NO;
                    canPickCard = YES;
                    score += 1000;
                    
                    if ([pairsLeftLabel.text integerValue] == 0) {
                        score *= 1 + ((([minutesLabel.text integerValue] * 60) + [secondsLabel.text integerValue]) / 100);
                        [self resetGame];
                    }
                }
                
                [scoreLabel setText:[NSString stringWithFormat:@"%.0f", score]];
                firstTurn = YES;
            }
        }else{
            NSLog(@"Can't Pick Card");
        }
    }else{
        NSLog(@"Is Face UP");
    }
}

#pragma mark    GameStatusDelegate

-(void) resumeGame{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timePass) userInfo:nil repeats:YES];
}

-(void) resetGame{
    NSMutableArray* animationBlocks = [NSMutableArray new];
    
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.5 animations:^{
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[cardsArray objectAtIndex:0] cache:YES];
            [UIView commitAnimations];
            [((MyView *)[cardsArray objectAtIndex:0]) setBackgroundColor:[[UIColor alloc] initWithPatternImage:((MyView*)[cardsArray objectAtIndex:0]).faceDownImage]];
        } completion: NULL];
    }];
    
    animationBlock (^getNextAnimation)() = ^{
        animationBlock block = animationBlocks.count ? (animationBlock)[animationBlocks objectAtIndex:0] : nil;
        if (block){
            [animationBlocks removeObjectAtIndex:0];
            return block;
        }else{
            return ^(BOOL finished){};
        }
    };
    
    for (MyView* card in cardsArray) {
        [card setBackgroundColor: card.cardColor];
        [animationBlocks addObject:^(BOOL finished){;
            [UIView animateWithDuration:0.5 animations:^{
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:card cache:YES];
                [UIView commitAnimations];
                [card setBackgroundColor:[[UIColor alloc] initWithPatternImage:card.faceDownImage]];
            } completion: getNextAnimation()];
        }];
        card.isFaceDown = YES;
        card.tag = 0;
    }
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         getNextAnimation();}
                     completion:^(BOOL finished){
                         getNextAnimation()(YES);
                     }];
    
    [self makePairs];
    if(!([pairsLeftLabel.text integerValue] == 0)){
        score = 0;
        scoreLabel.text = @"0000";
    }
    
    missesLabel.text = @"0";
    pairsLeftLabel.text = @"8";
    secondsLabel.text = @"00";
    minutesLabel.text = @"00";
    [delegate howMuchWasTheScore:score];
    timerRun = NO;
    [timer invalidate];
    
}

-(void)gotoMainMenu{
    [self resetGame];
    scoreLabel.text = [NSString stringWithFormat:@"%@", [delegate howMuchIsTheScore] == 0?@"0000":[NSString stringWithFormat:@"%.0f", [delegate howMuchIsTheScore]]];
    [self.view removeFromSuperview];
}

#pragma mark ButtonAcions

-(IBAction)onClickAction:(id)sender{
    [pauseButton setBackgroundColor:[UIColor colorWithRed:0.3 green:0.7 blue:1 alpha:1.0]];
}

-(IBAction)onReleaseAction:(id)sender{
    [self.view addSubview:pauseViewController.view];
    [timer invalidate];
    [pauseButton setBackgroundColor:[UIColor cyanColor]];
}

@end
