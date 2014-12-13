//
//  SignInView.h
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/13/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignInViewDelegate <NSObject>

@optional
- (void) createAccount;
- (void) loginSuccess;
- (void) dissmissViewControllerSignIn;
- (void)hiddenKeyBoard :(UITextField *)textField;

@end

@interface SignInView : UIView
{
    IBOutlet UIView *_signInView;
    IBOutlet UITextField *_txtEmail;
    IBOutlet UITextField *_txtPassWord;
    IBOutlet UIButton *_btnSignIn;
    
     __unsafe_unretained id<SignInViewDelegate> delegate;
}
@property (nonatomic,unsafe_unretained) id<SignInViewDelegate> delegate;
- (IBAction)forgotPassWordTapped:(id)sender;
- (IBAction)signInTapped:(id)sender;
@end
