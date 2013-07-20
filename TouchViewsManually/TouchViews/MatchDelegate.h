//
//  MatchDelegate.h
//  TouchViews
//
//  Created by Andrés Pesate on 7/18/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MyView;
@protocol MatchDelegate <NSObject>

-(void)didChooseView:(MyView *)senderView;

@end
