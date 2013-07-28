//
//  PostsCell.h
//  App.net
//
//  Created by Andrés Pesate on 7/26/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsCell : UITableViewCell

@property (strong, nonatomic) UILabel* usernameText;
@property (strong, nonatomic) UILabel* postText;
@property (strong, nonatomic) UILabel* postDate;
@property (strong, nonatomic) UIImageView* userAvatar;

-(void) setPostTextFramSize:(NSString *)postText;

@end
