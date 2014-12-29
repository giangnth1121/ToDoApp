//
//  SignUpView.m
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/17/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import "SignUpView.h"
#import "NoteTableViewController.h"
@implementation SignUpView
@synthesize delegate;
- (id)init{
    self  =  [[[NSBundle mainBundle] loadNibNamed:@"SignUpView" owner:self options:nil] lastObject];
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    
    _lblTerm.attributedText = [Util underLineBottomSignleWithText:_lblTerm.text];
    _lblPrivacy.attributedText = [Util underLineBottomSignleWithText:_lblPrivacy.text];
}
- (void) createAlertWithMessage:(NSString *) mess {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (IBAction)signUpTapped:(id)sender {
    // check email empty
    if ([[_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self createAlertWithMessage:ALERT_EMPTY_EMAIL];
        return;
    }
    
    // check password empty
    if ([[_txtPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self createAlertWithMessage:ALERT_EMPTY_PASSWORD];
        return;
    }
    
    // check password length 6->20
    if ([[_txtPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 6 || [[_txtPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] >20) {
        [self createAlertWithMessage:ALERT_FAIL_PASSWORD];
        return;
    }
    
    // check format email
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:_txtEmail.text] == NO) {
        
        [self createAlertWithMessage:ALERT_FAIL_FORMAT_EMAIL];
        return;
    }
    
    void(^successBlock)(ResponseObject *) = ^void(ResponseObject *responseObject) {
        NSLog(@"responseObject data :%@", responseObject.data);
        if ([[NSString stringWithFormat:@"%@",[responseObject.data objectForKey:KEY_CODE]] isEqualToString:@"0"]) {
            
            NSDictionary *data = [responseObject.data objectForKey:KEY_DATA];
            NSDictionary *profile = [data objectForKey:@"profile"];
            [[NSUserDefaults standardUserDefaults] setObject:stringCheckNull([profile objectForKey:@"uid"]) forKey:user_logged_ids];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:user_logged_type];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kIS_LOGED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            User *userObj = [User createWithId:stringCheckNull([profile objectForKey:@"uid"])];
            [userObj setcontent:profile];
            [DataManager saveAllChanges];
            
            if (self.delegate) {
                [self.delegate resgisterSuccess];
            }
            
            [Util showAlertWithMessage:ALERT_REGISTER_SUCCESS delegate:nil];
            [[Util sharedUtil] hideLoadingView];
        } else {
            
            NSString *message = [responseObject.data objectForKey:KEY_MESSAGE];
            [Util showAlert:ALERT_ERROR message:message delegate:self];
           
        }
        [[Util sharedUtil] hideLoadingView];
    };
    
    void(^failBlock)(ResponseObject *) = ^void(ResponseObject *responseObject) {
        
        [[Util sharedUtil] hideLoadingView];
        [Util showAlertError:ALERT_NETWORK_ERROR];
        
    };
    
    [[Util sharedUtil] showLoadingView];
    [[APIClient sharedClient] userRegister:_txtEmail.text
                                  password:_txtPassWord.text
                                   success:successBlock
                                   failure:failBlock];

}

- (IBAction)showTermTapped:(id)sender {
    if (self.delegate) {
        [self.delegate showTermAndConditionsTapped];
    }
}
- (IBAction)showPrivacyTapped:(id)sender {
    if (self.delegate) {
        [self.delegate showPrivacyTapped];
    }
}


@end
