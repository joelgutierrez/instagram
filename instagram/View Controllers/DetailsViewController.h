//
//  DetailsViewController.h
//  instagram
//
//  Created by Joel Gutierrez on 7/11/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ParseUI.h"
#import "Parse/Parse.h"
#import "DateTools.h"

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) Post *post;

@end
