//
//  HomeViewController.m
//  instagram
//
//  Created by Joel Gutierrez on 7/9/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *timelineView;
@property (strong, nonatomic) NSArray *postsArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDataSourceAndDelegate];
    [self fetchTimeLinePosts];
    [self createRefreshControl];
    self.timelineView.rowHeight = UITableViewAutomaticDimension;
    self.timelineView.estimatedRowHeight = 350;
}

#pragma mark - networking

- (void)fetchTimeLinePosts {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.postsArray = posts;
            [self.timelineView reloadData];
        }
        else {
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void) createRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTimeLinePosts) forControlEvents:UIControlEventValueChanged];
    [self.timelineView insertSubview:self.refreshControl atIndex:0];
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
