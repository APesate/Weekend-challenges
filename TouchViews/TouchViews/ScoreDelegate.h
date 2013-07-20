//
//  ScoreDelegate.h
//  TouchViews
//
//  Created by Andrés Pesate on 7/19/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScoreDelegate <NSObject>

-(void) howMuchWasTheScore:(float)score;
-(float) howMuchIsTheScore;

@end
