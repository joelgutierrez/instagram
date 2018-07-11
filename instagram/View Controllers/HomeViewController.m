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
@property (strong, nonatomic) NSMutableArray *postsArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDataSourceAndDelegate];
    [self fetchTimeLinePosts];
    [self createRefreshControl];
}

#pragma mark - network call

- (void)fetchTimeLinePosts {
    //TODO: fix function
    // fetch data asynchronously
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

//TODO: implement functions
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //TODO: make cell
    PostTableViewCell *cell = [self.timelineView dequeueReusableCellWithIdentifier:@"PostTableViewCell"];
    Post *post = self.postsArray[indexPath.row];
    cell.post = post;
    
    return cell;
}

#pragma mark - compose post protocol

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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navController = [segue destinationViewController];
    ComposeViewController* composeController = (ComposeViewController*)[navController topViewController];
    composeController.delegate = self;
}

@end
