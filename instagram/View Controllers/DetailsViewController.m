//
//  DetailsViewController.m
//  instagram
//
//  Created by Joel Gutierrez on 7/11/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *detailsImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPostDetails];
//    self.detailsTableView.rowHeight = UITableViewAutomaticDimension;
//    self.detailsTableView.estimatedRowHeight = 600;
}

-(void) setPostDetails {
    self.descriptionLabel.text = self.post.caption;
    self.detailsImage.file = self.post[@"image"];
    [self.detailsImage loadInBackground];
    NSDate *createdAtDate = self.post.createdAt;
    [self formatAndSetString:createdAtDate];
}

- (void) formatAndSetString:(NSDate *)createdAtDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    NSString *dateString = [formatter stringFromDate:createdAtDate];
    //NSString *modString = [NSDate shortTimeAgoSinceDate:date];
    self.timeLabel.text = dateString;
}

#pragma mark - actions

- (IBAction)backTap:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
