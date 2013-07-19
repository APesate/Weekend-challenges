//
//  ViewController.m
//  TouchViews
//
//  Created by Andrés Pesate on 7/18/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    BOOL    firstTurn;
    BOOL    timerRun;
    BOOL    canPickCard;
    MyView*     firstSelection;
    NSMutableArray* cardsArray;
    NSArray*        colorsArray;
    NSTimer*        timer;
    __weak IBOutlet UILabel *pairsLeftLabel;
    __weak IBOutlet UILabel *missesLabel;
    __weak IBOutlet UILabel *minutesLabel;
    __weak IBOutlet UILabel *secondsLabel;
}
- (IBAction)resetBoard:(id)sender;

@end

@implementation ViewController
typedef void(^animationBlock)(BOOL);
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initObjects];
    [self setViewsDelegates];
    [self makePairs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initObjects{
    cardsArray = [NSMutableArray arrayWithCapacity:16];
    colorsArray = @[[UIColor redColor], [UIColor blueColor], [UIColor blackColor], [UIColor yellowColor], [UIColor purpleColor], [UIColor brownColor], [UIColor orangeColor], [UIColor greenColor]];
    firstTurn = YES;
    canPickCard = YES;
    timerRun = NO;
}

-(void)timePass{
     [secondsLabel setText:[NSString stringWithFormat:@"%@%i", [secondsLabel.text integerValue]+1>9?@"":@"0",[secondsLabel.text integerValue] + 1]];
    if([secondsLabel.text integerValue] == 60){
        [secondsLabel setText:@"00"];
        [minutesLabel setText:[NSString stringWithFormat:@"%@%i", [minutesLabel.text integerValue]+1>9?@"":@"0",[minutesLabel.text integerValue] + 1]];
    }
}

-(void) setViewsDelegates{
    for (UIView* subview in self.view.subviews){
        if([subview isKindOfClass:[MyView class]]){
            ((MyView*)subview).delegate = self;
            [cardsArray addObject:subview];
        }
    }
}

-(void)makePairs{
    int j = 0, x = 0;
    
    for(int i = 1; i <= 8; i++){
        do{
            j = arc4random()%16;
        }while (((MyView *)[cardsArray objectAtIndex:j]).tag != 0);
        
        do{
            x = arc4random()%16;
        }while (((MyView *)[cardsArray objectAtIndex:x]).tag != 0 || j==x);
        NSLog(@"Pair %i: %i - %i", i, j, x);
        
        ((MyView *)[cardsArray objectAtIndex:j]).tag = i;
        ((MyView *)[cardsArray objectAtIndex:j]).cardColor = [colorsArray objectAtIndex:(i - 1)];
        
        ((MyView *)[cardsArray objectAtIndex:x]).tag = i;
        ((MyView *)[cardsArray objectAtIndex:x]).cardColor = [colorsArray objectAtIndex:(i - 1)];
    }
    
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
                    [self secondSelectionAnimation:firstSelection];
                    firstSelection.isFaceDown = NO;
                    firstTurn = NO;
                }else{
                    //timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(changeColor:) userInfo:senderView repeats:YES];
                    [self secondSelectionAnimation:senderView];
                    canPickCard = NO;
                    senderView.isFaceDown = NO;
                    
                    if(!(firstSelection.tag == senderView.tag)){
                        missesLabel.text = [NSString stringWithFormat:@"%i", [missesLabel.text integerValue] + 1];
                        [self performSelector:@selector(changeColor:) withObject:senderView afterDelay:1.0f];
                    }else{
                        pairsLeftLabel.text = [NSString stringWithFormat:@"%i", [pairsLeftLabel.text integerValue] - 1];
                        senderView.isFaceDown = NO;
                        firstSelection.isFaceDown = NO;
                        canPickCard = YES;
                        
                        if ([pairsLeftLabel.text integerValue] == 0) {
                            [self resetGame];
                        }
                    }
                    firstTurn = YES;
                }
            }else{
            NSLog(@"Can't Pick Card");
        }
    }else{
        NSLog(@"Is Face UP");
    }
}

-(void)changeColor:(MyView *)senderView{
    [self secondSelectionAnimation:firstSelection];
    [self secondSelectionAnimation:senderView];
    canPickCard = YES;
    senderView.isFaceDown = YES;
    firstSelection.isFaceDown = YES;
}


-(void) secondSelectionAnimation:(MyView *)senderView{
    [UIView animateWithDuration:0.8 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:senderView cache:YES];
        [UIView commitAnimations];
        
        if(![senderView isFaceDown]){
            [senderView setBackgroundColor:[[UIColor alloc] initWithPatternImage:senderView.faceDownImage]];
        }else{
            senderView.backgroundColor = senderView.cardColor;
        }    }];
}

-(void) resetGame{
    NSMutableArray* animationBlocks = [NSMutableArray new];
    
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.6 animations:^{
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
        card.backgroundColor = card.cardColor;
        [animationBlocks addObject:^(BOOL finished){;
            [UIView animateWithDuration:0.6 animations:^{
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:card cache:YES];
                [UIView commitAnimations];
                [card setBackgroundColor:[[UIColor alloc] initWithPatternImage:card.faceDownImage]];
            } completion: getNextAnimation()];
        }];
        card.isFaceDown = YES;
        card.tag = 0;
    }
    [UIView animateWithDuration:0.6 delay:1 options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         getNextAnimation();}
                     completion:^(BOOL finished){
                         getNextAnimation()(YES);
                     }];
    
    [self makePairs];
    missesLabel.text = @"0";
    pairsLeftLabel.text = @"8";
    secondsLabel.text = @"00";
    minutesLabel.text = @"00";
    timerRun = NO;
    [timer invalidate];
    
}
- (IBAction)resetBoard:(id)sender {
    [self resetGame];
}
@end
