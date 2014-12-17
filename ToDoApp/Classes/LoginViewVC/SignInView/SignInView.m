//
//  SignInView.m
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/17/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import "SignInView.h"

@implementation SignInView
@synthesize delegate;

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SignInView" owner:self options:nil] lastObject];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    _txtPassWord.delegate = self;
    _txtEmail.delegate = self;
    
}

- (void) createAlertWithMessage:(NSString *) mess {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - Action Sign In
- (IBAction)signInTapped:(id)sender {
    
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
        
        if ([[NSString stringWithFormat:@"%@",[responseObject.data objectForKey:KEY_CODE]] isEqualToString:@"0"]) {
            [Util saveInfoUser:[[responseObject.data objectForKey:KEY_DATA] objectForKey:KEY_PROFILE]];
            
            //Save current user
            NSDictionary *data = [responseObject.data objectForKey:KEY_DATA];
            NSDictionary *profile = [data objectForKey:@"profile"];
            [[NSUserDefaults standardUserDefaults] setObject:stringCheckNull([profile objectForKey:@"uid"]) forKey:user_logged_ids];
            [[NSUserDefaults standardUserDefaults] setObject:_txtPassWord.text forKey:user_vinted_logged_password];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:user_logged_type];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kIS_LOGED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            User *userObj = [User createWithId:stringCheckNull([data objectForKey:@"uid"])];
            [userObj setcontent:profile];
            [DataManager saveAllChanges];
            
            if (self.delegate) {
                [self.delegate loginSuccess];
            }
        } else {
            NSString *message = [responseObject.data objectForKey:KEY_MESSAGE];
            [Util showAlert:ALERT_ERROR message:message delegate:self];
        }
        [[Util sharedUtil] hideLoadingView];
        
    };
    void(^failBlock)(ResponseObject *) = ^void(ResponseObject *responseObject) {
        [Util showAlertError:ALERT_NETWORK_ERROR];
        [[Util sharedUtil] hideLoadingView];
    };
    
    [[Util sharedUtil] showLoadingView];
    [[APIClient sharedClient] userLogin:_txtEmail.text
                               password:_txtPassWord.text
                                success:successBlock
                                failure:failBlock];
}

@end
