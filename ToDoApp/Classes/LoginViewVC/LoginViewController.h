//
//  LoginViewController.h
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/13/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"

@interface LoginViewController : BaseViewController {

    IBOutlet UIView *_viewSignUp;
    IBOutlet UIView *_viewSignIn;
}


@property (nonatomic, strong) IBOutlet UIButton *btnSignIn;
@property (nonatomic, strong) IBOutlet UIButton *btnSignUp;
@property (nonatomic, strong) IBOutlet UIButton *btnSignInFacebook;

- (IBAction)signInPressed:(id)sender;
- (IBAction)signUpPressed:(id)sender;
- (IBAction)signInWithFaceBookPressed:(id)sender;
@end
