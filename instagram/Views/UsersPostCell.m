//
//  UsersPostCell.m
//  instagram
//
//  Created by Joel Gutierrez on 7/13/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import "UsersPostCell.h"

@implementation UsersPostCell

-(void)setupCell {
    [self setupPostImage];
}

-(void)setupPostImage {
    self.usersPostImage.file = self.post.image;
    [self.usersPostImage loadInBackground];
}

@end
