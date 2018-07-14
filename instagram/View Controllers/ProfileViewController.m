//
//  ProfileViewController.m
//  instagram
//
//  Created by Joel Gutierrez on 7/13/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import "ProfileViewController.h"


@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UICollectionView *usersPostsCollectionView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *postsCount;
@property (strong, nonatomic) NSArray *usersPosts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = PFUser.currentUser;
    self.usersPosts = [[NSMutableArray alloc] init];
    [self createRefreshControl];
    [self fetchUsersPosts];
    [self setDataSourceAndDelegate];
    [self setCollectionViewLayout];
    [self setUsersProfilePic];
}

#pragma mark - Setup

- (void)setUsersProfilePic {
    self.profilePic.file = self.user[@"profilePic"];
    [self.profilePic loadInBackground];
    self.profilePic.userInteractionEnabled = YES;
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height/2;
    self.profilePic.clipsToBounds = YES;
}

- (void)setPostCount {
    self.postsCount.text = [NSString stringWithFormat:@"%ld", self.usersPosts.count];
}

- (void) setDataSourceAndDelegate {
    self.usersPostsCollectionView.delegate = self;
    self.usersPostsCollectionView.dataSource = self;
}

- (void) setCollectionViewLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.5;
    layout.minimumLineSpacing = 1.5;
    self.usersPostsCollectionView.collectionViewLayout = layout;
}

- (void) createRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchUsersPosts) forControlEvents:UIControlEventValueChanged];
    [self.usersPostsCollectionView insertSubview:self.refreshControl atIndex:0];
}

#pragma mark - CollectionView protocol

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UsersPostCell *cell = [self.usersPostsCollectionView dequeueReusableCellWithReuseIdentifier:@"usersPostCell" forIndexPath:indexPath];
    cell.post = self.usersPosts[indexPath.item];
    [cell setupCell];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.usersPosts.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (CGFloat)self.view.frame.size.width/3-1.5;
    return CGSizeMake(width, width);
}

#pragma mark - Networking

- (void)fetchUsersPosts {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author = %@", self.user];
    PFQuery *postQuery = [Post queryWithPredicate:predicate];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [self displayInitialPosts:postQuery];
}

-(void) displayInitialPosts:(PFQuery *)postQuery {
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.usersPosts = posts;
            [self setPostCount];
            [self.usersPostsCollectionView reloadData];
        }
        else {
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - ImagePickerVC

-(void)initImagePicker {
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *reeditedImage = [self resizeImage:editedImage withSize:CGSizeMake(350, 350)];
    
    self.user[@"profilePic"] = [Post getPFFileFromImage:reeditedImage];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"here");
    }];
    self.profilePic.file = self.user[@"profilePic"];
    [self.profilePic loadInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Actions
- (IBAction)profilePicTapped:(id)sender {
    [self initImagePicker];
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

@end
