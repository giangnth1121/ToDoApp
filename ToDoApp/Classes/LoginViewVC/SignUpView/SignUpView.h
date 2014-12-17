//
//  SignUpView.h
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/17/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignUpViewDelegate <NSObject>

@optional

- (void) resgisterSuccess;
- (void) showPrivacyTapped;
- (void) showTermAndConditionsTapped;

@end

@interface SignUpView : UIView
{
    IBOutlet UITextField *_txtEmail;
    IBOutlet UITextField *_txtPassWord;
    IBOutlet UIButton *_btnSignUp;
    
    __weak IBOutlet UILabel *_lblTerm;
    __weak IBOutlet UILabel *_lblPrivacy;
    __unsafe_unretained id<SignUpViewDelegate>delegate;
}

@property(nonatomic, unsafe_unretained) id <SignUpViewDelegate> delegate;
- (IBAction)signUpTapped:(id)sender;
- (IBAction)showTermTapped:(id)sender;
- (IBAction)showPrivacyTapped:(id)sender;

@end
