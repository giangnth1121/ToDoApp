//
//  LoginViewController.h
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/13/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : BaseViewController <UITextFieldDelegate, UIScrollViewDelegate>{

    __weak IBOutlet UIScrollView *_scrollBackground;
    __weak IBOutlet UIScrollView *_scrollContent;
    
    IBOutlet UIView *_viewContent;
}

@property (nonatomic, strong) IBOutlet UIButton *btnSignIn;
@property (nonatomic, strong) IBOutlet UIButton *btnSignUp;
@property (nonatomic, strong) IBOutlet UIButton *btnSignInFacebook;
@property (nonatomic, assign) NSInteger uID;

- (IBAction)showSignInViewTapped:(id)sender;
- (IBAction)showSignUpViewTapped:(id)sender;
- (IBAction)signInWithFaceBookTapped:(id)sender;

- (void)autologinAcount;
- (void)autologinFBAccount;
@end
