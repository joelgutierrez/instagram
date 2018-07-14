//
//  HomeViewController.h
//  instagram
//
//  Created by Joel Gutierrez on 7/9/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "PostTableViewCell.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, UIScrollViewDelegate>

@end
