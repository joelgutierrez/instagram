//
//  UsersPostCell.h
//  instagram
//
//  Created by Joel Gutierrez on 7/13/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "Post.h"

@interface UsersPostCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *usersPostImage;
@property (strong, nonatomic) Post *post;

-(void)setupCell;

@end
