//
//  HomeViewController.m
//  instagram
//
//  Created by Joel Gutierrez on 7/9/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *timelineView;
@property (strong, nonatomic) NSMutableArray *postsArray;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDataSourceAndDelegate];
    [self fetchTimeLinePosts];
    [self createRefreshControl];
    [self setTimelineLayout];
    self.timelineView.delegate = self;
}

-(void)setTimelineLayout {
    self.timelineView.rowHeight = UITableViewAutomaticDimension;
    self.timelineView.estimatedRowHeight = 600;
}

#pragma mark - networking

- (void)fetchTimeLinePosts {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"createdAt"];
    [self fetchDataAsynch:postQuery];
}

- (void) createRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTimeLinePosts) forControlEvents:UIControlEventValueChanged];
    [self.timelineView insertSubview:self.refreshControl atIndex:0];
}

-(void) fetchDataAsynch:(PFQuery *)postQuery {
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.postsArray = [[NSMutableArray alloc] initWithArray:posts];
            [self.timelineView reloadData];
        }
        else {
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

# pragma mark - scroll view delagate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.timelineView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.timelineView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.timelineView.isDragging) {
            self.isMoreDataLoading = YES;
            [self infiniteScroll];
        }
    }
}

-(void)infiniteScroll {
    Post *post = self.postsArray[self.postsArray.count-1];
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"createdAt"];
    [postQuery whereKey:@"createdAt" lessThan:post.createdAt];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            NSLog(@"Successful scrolling update!");
            NSMutableArray *rows = [[NSMutableArray alloc] init];
            for(Post *p in posts) {
                [self.postsArray addObject:p];
                NSIndexPath *newrow = [NSIndexPath indexPathForRow:self.postsArray.count-1 inSection:0];
                [rows addObject:newrow];
            }
            [self.timelineView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationNone];
        }
        else {
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - table view protocol

- (void) setDataSourceAndDelegate {
    self.timelineView.delegate = self;
    self.timelineView.dataSource = self;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostTableViewCell *cell = [self.timelineView dequeueReusableCellWithIdentifier:@"PostTableViewCell"];
    Post *post = self.postsArray[indexPath.row];
    cell.post = post;
    return cell;
}

#pragma mark - ComposeViewControllerDelegate protocol

- (void)didPost {
    [self fetchTimeLinePosts];
}

#pragma mark - actions

- (IBAction)logoutTap:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"error: unsuccessful log out");
        } else {
            NSLog(@"successful log out");
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            appDelegate.window.rootViewController = loginViewController;
        }
    }];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navController = [segue destinationViewController];
    if([segue.identifier isEqualToString:@"composeSegue"]) {
        ComposeViewController* composeController = (ComposeViewController*)[navController topViewController];
        composeController.delegate = self;
    } else {
        DetailsViewController* detailsController = (DetailsViewController*)[navController topViewController];
        PostTableViewCell *postCell = sender;
        detailsController.post = postCell.post;
    }
}

@end
