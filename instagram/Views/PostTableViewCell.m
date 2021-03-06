//
//  PostTableViewCell.m
//  instagram
//
//  Created by Joel Gutierrez on 7/10/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

-(void) setPost:(Post *)post {
    _post = post;
    self.photoImageView.file = post[@"image"];
    [self.photoImageView loadInBackground];
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@ likes", self.post[@"likeCount"]];
    self.userPF = self.post[@"author"];
    self.topUsernameLabel.text = self.userPF.username;
    [self formatUsernameAndCaption];
    [self formatTimeStamp:self.post.createdAt];
    self.profilePic.file = self.userPF[@"profilePic"];
    [self.profilePic loadInBackground];
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height/2;
    self.profilePic.clipsToBounds = YES;
}

#pragma mark - formatting

-(void) formatUsernameAndCaption {
    NSString *usernameToBeBold = self.userPF.username;
    NSString *usernameAndCaption = [NSString stringWithFormat:@"%@ %@", usernameToBeBold, self.post[@"caption"]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:usernameAndCaption];
    NSRange boldRange = [usernameAndCaption rangeOfString:usernameToBeBold];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:boldRange];
    [self.usernameAndCaptionLabel setAttributedText:attributedString];
}

- (void) formatTimeStamp:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    NSString *modString = [NSDate shortTimeAgoSinceDate:date];
    NSString *fullString = [modString stringByAppendingString:@" ago"];
    self.timeLabel.text = fullString;
}

@end
