//
//  LoginViewController.m
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/13/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import "LoginViewController.h"

#define LOGIN_FACEBOOK  0
#define LOGIN           1
#define SIGNUP          2

@interface LoginViewController ()
{

}

@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}
- (void)initUI {
    
    self.btnSignIn.layer.cornerRadius = 5.0f;
    self.btnSignUp.layer.cornerRadius = 5.0f;
    self.btnSignInFacebook.layer.cornerRadius = 5.0f;
    _viewSignIn.hidden = YES;
    _viewSignUp.hidden = YES;
}
- (void)initData {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)signInPressed:(id)sender {

}
- (IBAction)signUpPressed:(id)sender {
    // [Util showMessage:@"Sign Up" withTitle:@""];
   
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     SignUpViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp"];
 
    vc.delegate = (id<SignUpViewControllerDelegate>)self;
    vc.isSignUp = NO;
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)signInWithFaceBookPressed:(id)sender {
    
   // [Util showMessage:@"Sign In FB" withTitle:@""];

}

- (void) resgisterSuccess {
    
//    [self dissmissViewController];
//    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kIS_LOGED];

}



@end
