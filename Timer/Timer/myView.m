//
//  myView.m
//  Timer
//
//  Created by Andrés Pesate on 7/12/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "myView.h"

@interface myView ()

@end

@implementation myView

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

- (void)drawRect:(CGRect)rect
{
    NSLog(@"MyView:drawRect...");
    
    CGContextRef X = UIGraphicsGetCurrentContext();
    
    CGRect bounds =  CGContextGetClipBoundingBox(X);
    CGPoint center = CGPointMake((bounds.size.width / 2), (bounds.size.height / 2));
    
    NSLog(@"--> (drawRect) bounds:'%@'", NSStringFromCGRect(bounds));
    
    // fill background rect dark blue
    CGContextSetRGBFillColor(X, 0,0,0.3, 1.0);
    CGContextFillRect(X, bounds);
    
    // circle
    CGContextSetRGBFillColor(X, 0,0,0.6, 1.0);
    CGContextFillEllipseInRect(X, bounds);
    
    // fat rounded-cap line from origin to center of view
    CGContextSetRGBStrokeColor(X, 0,0,1, 1.0);
    CGContextSetLineWidth(X, 30);
    CGContextSetLineCap(X, kCGLineCapRound);
    CGContextBeginPath(X);
    CGContextMoveToPoint(X, 0,0);
    CGContextAddLineToPoint(X, center.x, center.y);
    CGContextStrokePath(X);
    
    // Draw the text NoXIB in red
    char* text = "Hello World!";
    CGContextSelectFont(X, "Helvetica Bold", 24.0f, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(X, kCGTextFill);
    CGContextSetRGBFillColor(X, 0.8f, 0.3f, 0.1f,  1.0f);
    CGAffineTransform xform = CGAffineTransformMake(
                                                    1.0f,  0.0f,
                                                    0.0f, -1.0f,
                                                    0.0f,  0.0f   );
    CGContextSetTextMatrix(X, xform);
    CGContextShowTextAtPoint(X, center.x, center.y, text, strlen(text));
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
