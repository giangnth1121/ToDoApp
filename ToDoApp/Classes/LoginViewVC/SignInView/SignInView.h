//
//  SignInView.h
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/17/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SignInViewDelegate <NSObject>

@optional

- (void) loginSuccess;
- (void) dissmissViewControllerSignIn;

@end

@interface SignInView : UIView <UITextFieldDelegate>
{
    IBOutlet UITextField *_txtEmail;
    IBOutlet UITextField *_txtPassWord;
    IBOutlet UIButton *_btnSignIn;
    
    __unsafe_unretained id<SignInViewDelegate>delegate;
}

@property (nonatomic, unsafe_unretained) id <SignInViewDelegate> delegate;
@property (nonatomic, assign) NSInteger uID;
- (IBAction)signInTapped:(id)sender;

@end
