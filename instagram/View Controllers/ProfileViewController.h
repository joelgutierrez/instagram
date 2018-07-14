//
//  ProfileViewController.h
//  instagram
//
//  Created by Joel Gutierrez on 7/13/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersPostCell.h"
#import "Post.h"

@interface ProfileViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) PFUser *user;

@end
