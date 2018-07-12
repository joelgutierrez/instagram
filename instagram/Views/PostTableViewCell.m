//
//  PostTableViewCell.m
//  instagram
//
//  Created by Joel Gutierrez on 7/10/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import "PostTableViewCell.h"



@implementation PostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void) setPost:(Post *)post {
    _post = post;
    self.photoImageView.file = post[@"image"];
    [self.photoImageView loadInBackground];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@ likes", self.post[@"likeCount"]];
    self.userPF = self.post[@"author"];
    self.topUsernameLabel.text = self.userPF.username;
    [self formatUsernameAndCaption];
}

-(void) formatUsernameAndCaption {
    NSString *usernameToBeBold = self.userPF.username;
    NSString *usernameAndCaption = [NSString stringWithFormat:@"%@ %@", usernameToBeBold, self.post[@"caption"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:usernameAndCaption];
    NSRange boldRange = [usernameAndCaption rangeOfString:usernameToBeBold];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:boldRange];
    [self.usernameAndCaptionLabel setAttributedText:attributedString];
}



@end
