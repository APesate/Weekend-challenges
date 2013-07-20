//
//  MyView.h
//  TouchViews
//
//  Created by Andrés Pesate on 7/18/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchDelegate.h"

@interface MyView : UIView

@property (strong, nonatomic) id <MatchDelegate> delegate;
@property (strong, nonatomic) UIColor* cardColor;
@property (strong, nonatomic) UIImage* faceDownImage;
@property BOOL isFaceDown;

@end
