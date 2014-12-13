//
//  SignInView.m
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/13/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import "SignInView.h"

@implementation SignInView
@synthesize delegate;

- (id)init{
    self = [super init];
    if (self) {
        self =  [[[NSBundle mainBundle] loadNibNamed:@"SignInView" owner:self options:nil] lastObject];
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    [_txtEmail becomeFirstResponder];
    
    _txtEmail.placeholder = @"";
    _txtPassWord.placeholder = @"";
    
    [_txtEmail addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [_txtEmail addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    _txtEmail.delegate = (id<UITextFieldDelegate>)self;
    _txtEmail.delegate = (id<UITextFieldDelegate>)self;
}

- (void)textChange{
    if ([_txtEmail.text isEqualToString:@""] || [_txtPassWord.text isEqualToString:@""]) {
        _btnSignIn.backgroundColor = [Util getColor:@"D8D8D8"];
    } else{
        _btnSignIn.backgroundColor = [Util getColor:@""];
    }
}

- (IBAction)signInTapped:(id)sender {
    
    [_txtEmail resignFirstResponder];
    [_txtPassWord resignFirstResponder];
    
    // check username empty
    if ([_txtEmail.text length] == 0) {
        
    }
    
    // check password empty
    if ([_txtPassWord.text length] == 0) {
        
    
    }

    
}

- (IBAction)forgotPassWordTapped:(id)sender {

    
    
}

@end
