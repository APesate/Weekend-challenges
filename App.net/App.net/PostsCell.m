//
//  PostsCell.m
//  App.net
//
//  Created by Andrés Pesate on 7/26/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "PostsCell.h"

@implementation PostsCell

@synthesize userAvatar, usernameText, postText, postDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        usernameText = [[UILabel alloc] init];
        [usernameText setFont:[UIFont fontWithName:@"Georgia-Bold" size:16]];
        [usernameText setTextColor:[UIColor darkGrayColor]];
        [usernameText setTextAlignment:NSTextAlignmentLeft];
        [usernameText setBackgroundColor:[UIColor clearColor]];
        
        postText = [[UILabel alloc] init];
        [postText setFont:[UIFont fontWithName:@"Courier" size:14]];
        [postText setTextColor:[UIColor grayColor]];
        [postText setTextAlignment:NSTextAlignmentLeft];
        [postText setBackgroundColor:[UIColor clearColor]];
        [postText setNumberOfLines:0];
        
        postDate = [[UILabel alloc] init];
        [postDate setFont:[UIFont fontWithName:@"CourierNewPSMT" size:10]];
        [postDate setTextColor:[UIColor darkGrayColor]];
        [postDate setTextAlignment:NSTextAlignmentLeft];
        [postDate setBackgroundColor:[UIColor clearColor]];
        
        userAvatar = [[UIImageView alloc] init];
        
        [self.contentView addSubview:usernameText];
        [self.contentView addSubview:postText];
        [self.contentView addSubview:postDate];
        [self.contentView addSubview:userAvatar];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    
    usernameText.frame = CGRectMake(boundsX+50 ,0, 310, 25);
    postDate.frame = CGRectMake(boundsX+200 ,0, 310, 25);
    userAvatar.frame = CGRectMake(boundsX+5 ,5, 40, 40);

}

-(void) setPostTextFramSize:(NSString *)text{
    postText.frame = CGRectMake(50 ,25, 230, [text sizeWithFont:[UIFont fontWithName:@"Courier" size:14] constrainedToSize:CGSizeMake(260.0f, 70.0f) lineBreakMode:NSLineBreakByCharWrapping].height);
}

@end
