//
//  SignUpViewController.m
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/13/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignInView.h"

@interface SignUpViewController ()
{
    UIImage *nav_bg;
    SignInView *signInView;
}
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

- (void) checkSignUp:(BOOL)isSignUp{
    _bgContentView.hidden = YES;
    signInView.hidden =  YES;
    if (isSignUp) {
        _bgContentView.hidden = NO;
    } else{
        signInView.hidden = NO;
    }
}

- (void)initUI {
    
    signInView = [[SignInView alloc] init];
    signInView.frame = self.view.frame;
    signInView.delegate = (id<SignInViewDelegate>)self;
    [_signUpContentView addSubview:signInView];
    
    _bgContentView.center = CGPointMake(SCREEN_WIDTH_PORTRAIT/2, SCREEN_HEIGHT_PORTRAIT/2);
    _contentView.center = CGPointMake(SCREEN_WIDTH_PORTRAIT/2, SCREEN_HEIGHT_PORTRAIT/2);
    _contentView.layer.masksToBounds = YES;
    
    _btnSignUp.userInteractionEnabled = NO;
    
    
    if ([[UIDevice currentDevice].systemVersion integerValue] >= 7) {
        
        nav_bg = [UIImage resizableImage:[UIImage imageNamed:@"nav_ios7"]];
    }
    else{
        nav_bg = [UIImage resizableImage:[UIImage imageNamed:@"navbar_bg"]];
    }
     [self checkSignUp:self.isSignUp];
}

- (void) createAlertWithMessage:(NSString *) mess {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)singUpTapped:(id)sender {
    
    // check email empty
    if ([[_txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self createAlertWithMessage:ALERT_EMPTY_EMAIL];
    }
    
    
    // check password empty
    if ([[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self createAlertWithMessage:ALERT_EMPTY_PASSWORD];
    }
    
    // check password length 6->20
    if ([[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 6 || [[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] >20) {
         [self createAlertWithMessage:ALERT_FAIL_PASSWORD];
  
    }
    
 
    // check format email
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:_txtEmail.text] == NO) {

         [self createAlertWithMessage:ALERT_FAIL_FORMAT_EMAIL];
    }
    
    void(^successBlock)(ResponseObject *) = ^void(ResponseObject *responseObject) {
        if ([[NSString stringWithFormat:@"%@",[responseObject.data objectForKey:KEY_CODE]] isEqualToString:@"0"]) {
            
            //            [SWUtil saveInfoUser:[[responseObject.data objectForKey:KEY_DATA] objectForKey:KEY_PROFILE]];
            
            //Save current user
            NSDictionary *data = [responseObject.data objectForKey:KEY_DATA];
            NSDictionary *profile = [data objectForKey:@"profile"];
            [[NSUserDefaults standardUserDefaults] setObject:stringCheckNull([profile objectForKey:@"uid"]) forKey:user_logged_ids];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:user_logged_type];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kIS_LOGED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (self.delegate) {
                [self.delegate resgisterSuccess];
            }
            
            User *userObj = [User createWithId:stringCheckNull([profile objectForKey:@"uid"])];
            [userObj setcontent:profile];
            [DataManager saveAllChanges];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        
        }
    };
    void(^failBlock)(ResponseObject *) = ^void(ResponseObject *responseObject) {
        
        [[Util sharedUtil] hideLoadingView];
        [Util showMessage:nil withTitle:ALERT_NETWORK_ERROR];
    };
    
    
    [[Util sharedUtil] showLoadingOnView:self.view withLable:@"Loading.."];
    [[APIClient sharedClient] userSignUp:_txtEmail.text
                                password:_txtPassword.text
                                 success:successBlock
                                 failure:failBlock];

}
- (IBAction)termTapped:(id)sender {
    
}
- (IBAction)privacyTapped:(id)sender {
    
}
- (void) dissmissViewControllerSignIn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- SignInView Delegate
- (void)loginSuccess{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    if (self.delegate) {
        [self.delegate loginSuccess];
    }
}

- (void)hiddenKeyBoard:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (void)createAccount{
    _bgContentView.hidden = NO;
    [UIView transitionFromView:signInView
                        toView:_bgContentView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:nil];
}

@end
