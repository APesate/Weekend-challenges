//
//  ViewController.m
//  App.net
//
//  Created by Andrés Pesate on 7/26/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    __weak IBOutlet UITableView *postTableView;
    
    //postInfo
    NSMutableArray*     usernamesArray;
    NSMutableArray*     postTextsArray;
    NSMutableArray*     userimageArray;
    NSMutableArray*     postDateArray;
    NSMutableArray*     usersIDArray;
    NSArray*            postDictionaryArray;
    UIRefreshControl*   refreshControl;
    NSDate*             lastDate;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeObjects];
	[self getPost];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Initialize Methods

-(void)initializeObjects{
    usernamesArray = [NSMutableArray arrayWithCapacity:25];
    postTextsArray = [NSMutableArray arrayWithCapacity:25];
    userimageArray = [NSMutableArray arrayWithCapacity:25];
    usersIDArray = [NSMutableArray arrayWithCapacity:25];
    postDateArray = [NSMutableArray arrayWithCapacity:25];
    postDictionaryArray = [NSArray array];
    
    lastDate = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
    
    postTableView.layer.cornerRadius = 10;

    UITableViewController* tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = postTableView;
    
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
    return [usernamesArray count];
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
    
    cell.usernameText.text = [usernamesArray objectAtIndex:indexPath.row];
    cell.postText.text = [postTextsArray objectAtIndex:indexPath.row];
    cell.postDate.text = [NSString stringWithFormat:@"%@", [self getDateString:[postDateArray objectAtIndex:indexPath.row]]];
    cell.userAvatar.image = [userimageArray objectAtIndex:indexPath.row];
    
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
    [self performSegueWithIdentifier:@"toUserDetails" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark SearchMechanism

- (void)getPost{
    
    NSURL* url = [NSURL URLWithString:@"https://alpha-api.app.net/stream/0/posts/stream/global"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(!error){
            
            NSDictionary* resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            postDictionaryArray = [NSArray arrayWithArray:[resultsDictionary objectForKey:@"data"]];
            
            __block int index = 0;
            
            [postDictionaryArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
                
                NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
                NSDate* date = [dateFormat dateFromString:[obj objectForKey:@"created_at"]];
                
                if([lastDate compare:date] == NSOrderedAscending){
                    [usernamesArray insertObject:[[obj objectForKey:@"user"] objectForKey:@"username"] atIndex: index];
                    [usersIDArray insertObject:[[obj objectForKey:@"user"] objectForKey:@"id"] atIndex: index];
                    [postTextsArray insertObject:[obj objectForKey:@"text"] atIndex: index];
                    [userimageArray insertObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[obj objectForKey:@"user"] objectForKey:@"avatar_image"] objectForKey:@"url"]]]] atIndex: index];
                    [postDateArray insertObject:[obj objectForKey:@"created_at"] atIndex: index];
                    [postTableView reloadData];
                    index += 1;
                }
            }];
            
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
            lastDate = [dateFormat dateFromString:[postDateArray objectAtIndex:0]];
            
            [refreshControl endRefreshing];
        }else{
            NSLog(@"There was an error! %@", error.description);
        }
    }];
}

#pragma mark SegueInstructions

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UserDetailsViewController* userDetailsViewController = segue.destinationViewController;
    userDetailsViewController.username = [usernamesArray objectAtIndex:[postTableView indexPathForSelectedRow].row];
    userDetailsViewController.userAvatar = [userimageArray objectAtIndex:[postTableView indexPathForSelectedRow].row];
    userDetailsViewController.userID = [usersIDArray objectAtIndex:[postTableView indexPathForSelectedRow].row];
}
@end
