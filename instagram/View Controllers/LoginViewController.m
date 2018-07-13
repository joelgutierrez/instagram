//
//  LoginViewController.m
//  instagram
//
//  Created by Joel Gutierrez on 7/9/18.
//  Copyright © 2018 Joel Gutierrez. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginButton.layer.borderWidth = 0.3;
}

#pragma mark - fields checks

-(void) createEmptyUsernameWarning {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Empty username" preferredStyle:(UIAlertControllerStyleAlert)];
    [self createWarningActions:alert];
    [self presentViewController:alert animated:YES completion:^{}];
}

-(void) createEmptyPasswordWarning {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Empty password" preferredStyle:(UIAlertControllerStyleAlert)];
    [self createWarningActions:alert];
    [self presentViewController:alert animated:YES completion:^{}];
}

-(void) createWarningActions:(UIAlertController *)alert {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel button clicked");
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ok button clicked");
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
}

- (BOOL) isPasswordFieldEmpty:(NSString *)password {
    if([self.passwordField.text isEqual:@""]){
        [self createEmptyPasswordWarning];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isUsernameFieldEmpty:(NSString *)username {
    if ([self.usernameField.text isEqual:@""]) {
        [self createEmptyUsernameWarning];
        return YES;
    } else {
        return NO;
    }
}

-(BOOL) emptyFields:(NSString *)username password:(NSString *)password {
    return [self isUsernameFieldEmpty:username] || [self isPasswordFieldEmpty:password];
}

#pragma mark - login

- (IBAction)loginTap:(id)sender {
    [self loginUser];
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    if([self emptyFields:username password:password]) {
        return;
    }

    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

#pragma mark - sign up
- (IBAction)signupTap:(id)sender {
    [self registerUser];
}

- (void)registerUser {
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    if([self emptyFields:newUser.username password:newUser.password]) {
        return;
    }
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

#pragma mark - actions

- (IBAction)viewTap:(id)sender {
    [self.passwordField resignFirstResponder];
    [self.usernameField resignFirstResponder];
}


@end
