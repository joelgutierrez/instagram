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


@interface PostTableViewCell : UITableViewCell

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;



@end
