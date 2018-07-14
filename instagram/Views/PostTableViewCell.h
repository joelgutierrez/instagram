//
//  PostTableViewCell.h
//  instagram
//
//  Created by Joel Gutierrez on 7/10/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ParseUI.h"
#import "DateTools.h"

@interface PostTableViewCell : UITableViewCell

@property (strong, nonatomic) PFUser *userPF;
@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameAndCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *topUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
