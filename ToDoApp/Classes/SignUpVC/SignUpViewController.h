//
//  SignUpViewController.h
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/13/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignUpViewControllerDelegate <NSObject>

@optional

- (void) loginSuccess;
- (void) resgisterSuccess;
- (void)dissmissViewControllerSignUp;

@end

@interface SignUpViewController : BaseViewController
{
    IBOutlet UIView *_bgContentView;
    IBOutlet UIView *_contentView;
    IBOutlet UIView *_signUpContentView;
    IBOutlet UITextField *_txtEmail;
    IBOutlet UITextField *_txtPassword;
    IBOutlet UIButton *_btnSignUp;
    IBOutlet UILabel *_lblTerm;
    IBOutlet UILabel *_lblPrivacy;
    __unsafe_unretained id<SignUpViewControllerDelegate> delegate;
}
@property (nonatomic,unsafe_unretained) id<SignUpViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isSignUp;

- (void) checkSignUp:(BOOL)isSignUp;

- (IBAction)singUpTapped:(id)sender;
- (IBAction)termTapped:(id)sender;
- (IBAction)privacyTapped:(id)sender;
@end
