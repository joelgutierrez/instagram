//
//  ComposeViewController.m
//  instagram
//
//  Created by Joel Gutierrez on 7/9/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *composeImage;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (weak, nonatomic) IBOutlet UITextView *composeTextField;
@property (strong, nonatomic) IBOutlet UIView *composeView;

@end

@implementation ComposeViewController

BOOL isMoreDataLoading = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initImagePicker];
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

-(void)initImagePicker {
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *reeditedImage = [self resizeImage:editedImage withSize:CGSizeMake(350, 350)];
    self.composeImage.image = reeditedImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - actions

- (IBAction)postTap:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.composeView animated:YES];
    [Post postUserImage:self.composeImage.image withCaption:self.composeTextField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"error: could not post.");
        } else {
            NSLog(@"Successful post.");
            [MBProgressHUD hideHUDForView:self.composeView animated:YES];
            [self.delegate didPost];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (IBAction)imageTapped:(id)sender {
    NSLog(@"image tapped");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

@end

