//
//  MyView.m
//  TouchViews
//
//  Created by Andrés Pesate on 7/18/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "MyView.h"

@implementation MyView

@synthesize delegate, cardColor, isFaceDown, faceDownImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Code for when you init through the IB file
        //[self setIsFaceDown:YES];
        isFaceDown = YES;
        
        UIGraphicsBeginImageContext(self.frame.size);
        [[UIImage imageNamed:@"Question Mark.jpg"] drawInRect:self.bounds];
       faceDownImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setBackgroundColor:[[UIColor alloc] initWithPatternImage:faceDownImage]];
    }
    return self;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [delegate didChooseView:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

//Not for Cancel the touch, is when the system cancels the touch event
-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
