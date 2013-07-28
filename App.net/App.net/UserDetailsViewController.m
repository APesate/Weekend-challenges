//
//  UserDetailsViewController.m
//  App.net
//
//  Created by Andrés Pesate on 7/27/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "UserDetailsViewController.h"

@interface UserDetailsViewController (){

    __weak IBOutlet UIImageView *avatarImageView;
    __weak IBOutlet UIImageView *coverImage;
    __weak IBOutlet UILabel *usernameLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UITableView *userPostTableView;
    UIRefreshControl*   refreshControl;
    NSMutableArray*     postTextsArray;
    NSMutableArray*     postDateArray;
    NSArray*            postDictionaryArray;
    NSDate*             lastDate;
}

@end

@implementation UserDetailsViewController
@synthesize userAvatar, username, userID;

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
	[self initObjects];
    [self getPost];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark InitObjects

-(void) initObjects{
    usernameLabel.text = self.username;
    avatarImageView.image = self.userAvatar;
    
    postTextsArray = [NSMutableArray arrayWithCapacity:25];
    postDateArray = [NSMutableArray arrayWithCapacity:25];
    
    lastDate = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
    
    userPostTableView.layer.cornerRadius = 10;
    
    UITableViewController* tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = userPostTableView;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getPost) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor colorWithRed:0.2 green:0.3 blue:1.0 alpha:1.0];
    tableViewController.refreshControl = refreshControl;
}

-(NSString *)getDateString:(NSString *)reciveDate{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    NSDate* date = [dateFormat dateFromString:reciveDate];
    NSTimeInterval finalDate = [date timeIntervalSinceNow];
    finalDate *= -1;
    
    if(finalDate < 5){
        return @"now";
    }else{
        if (finalDate >= 60) {
            finalDate /= 60;
            
            if (finalDate >= 60) {
                finalDate /= 60;
                
                if (finalDate >= 24) {
                    finalDate /= 24;
                    return [NSString stringWithFormat:@"%.0f Days Ago", finalDate];
                }else{
                    return [NSString stringWithFormat:@"%.0f Hours Ago", finalDate];
                }
            }else{
                return [NSString stringWithFormat:@"%.0f Minutes Ago", finalDate];
            }
        }else{
            return [NSString stringWithFormat:@"%.0f Seconds Ago", finalDate];
        }
    }
}

#pragma mark UITableViewDataSource

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [postDictionaryArray count];
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(PostsCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* cellIdentifier;
    
    cellIdentifier = @"post";
    
    PostsCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PostsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
    }
    
    [cell setPostTextFramSize:[postTextsArray objectAtIndex:indexPath.row]];
    
    cell.usernameText.text = username;
    cell.postText.text = [postTextsArray objectAtIndex:indexPath.row];
    cell.postDate.text = [NSString stringWithFormat:@"%@", [self getDateString:[postDateArray objectAtIndex:indexPath.row]]];
    cell.userAvatar.image = userAvatar;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row <= [postTextsArray count] - 1){
        return [(NSString *)[postTextsArray objectAtIndex:indexPath.row] sizeWithFont:[UIFont fontWithName:@"Courier" size:14] constrainedToSize:CGSizeMake(260.0f, 70.0f) lineBreakMode:NSLineBreakByCharWrapping].height + 40;
    }else{
        return 70;
    }
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark SearchForInformation

- (void)getPost{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://alpha-api.app.net/stream/0/users/%@/posts", userID]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(!error){
            
            __block int index = 0;
            
            NSDictionary* resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            postDictionaryArray = [NSArray arrayWithArray:[resultsDictionary objectForKey:@"data"]];
            
            [postDictionaryArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
                
                NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
                NSDate* date = [dateFormat dateFromString:[obj objectForKey:@"created_at"]];
                
                 if([lastDate compare:date] == NSOrderedAscending){
                    [postTextsArray insertObject:[obj objectForKey:@"text"] atIndex:index];
                    [postDateArray insertObject:[obj objectForKey:@"created_at"] atIndex:index];
                    [userPostTableView reloadData];
                     index += 1;
                }
            }];
            
            descriptionLabel.text = [[[[postDictionaryArray objectAtIndex:0] objectForKey:@"user"] objectForKey:@"description"] objectForKey:@"text"];
            coverImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[[postDictionaryArray objectAtIndex:0] objectForKey:@"user"] objectForKey:@"cover_image"] objectForKey:@"url"]]]];
            
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
            lastDate = [dateFormat dateFromString:[postDateArray objectAtIndex:0]];
            
            [refreshControl endRefreshing];
        }else{
            NSLog(@"There was an error! %@", error.description);
        }
    }];
}
#pragma mark RemoveView

-(void) viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

@end
