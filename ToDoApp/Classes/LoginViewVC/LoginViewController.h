//
//  LoginViewController.h
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/13/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : BaseViewController <UITextFieldDelegate>{

    IBOutlet UIView *_viewSignUp;
    IBOutlet UIView *_viewSignIn;
    
    IBOutlet UITextField *_txtSignInEmail;
    IBOutlet UITextField *_txtSignInPassWord;
    
    IBOutlet UITextField *_txtSignUpEmail;
    IBOutlet UITextField *_txtSignUpPassWord;
    
}


@property (nonatomic, strong) IBOutlet UIButton *btnSignIn;
@property (nonatomic, strong) IBOutlet UIButton *btnSignUp;
@property (nonatomic, strong) IBOutlet UIButton *btnSignInFacebook;

- (IBAction)showSignInPressed:(id)sender;
- (IBAction)showSignUpPressed:(id)sender;
- (IBAction)signInWithFaceBookPressed:(id)sender;
- (IBAction)signInPressed:(id)sender;
- (IBAction)signUpPressed:(id)sender;

@end
