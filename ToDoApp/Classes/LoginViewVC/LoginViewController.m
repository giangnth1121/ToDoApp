//
//  LoginViewController.m
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/13/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import "LoginViewController.h"
#import "TableViewController.h"

#define LOGIN_FACEBOOK  0
#define LOGIN           1
#define SIGNUP          2
#define kOFFSET_FOR_KEYBOARD 80

@interface LoginViewController ()
{
    BOOL _isSignIn;
}

@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}
- (void)initUI {
    
    self.btnSignIn.layer.cornerRadius = 5.0f;
    self.btnSignUp.layer.cornerRadius = 5.0f;
    self.btnSignInFacebook.layer.cornerRadius = 5.0f;
    _txtSignInEmail.delegate = self;
    _txtSignInPassWord.delegate = self;
    _txtSignUpEmail.delegate = self;
    _txtSignUpPassWord.delegate = self;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(resetFrameView:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    _viewSignUp.hidden = YES;
    _viewSignIn.hidden = YES;
}
- (void)initData {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action
- (void) createAlertWithMessage:(NSString *) mess {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)resetFrameView:(id)sender {
    _viewSignIn.hidden = YES;
    _viewSignUp.hidden = YES;
    [self.view endEditing:YES];
}
#pragma mark - IBAction
- (IBAction)showSignInPressed:(id)sender {
   
    _viewSignIn.frame = CGRectMake(0,SCREEN_HEIGHT_PORTRAIT +_viewSignIn.bounds.size.height, _viewSignIn.bounds.size.width, _viewSignIn.bounds.size.height);
    _viewSignIn.hidden = NO;
     CGRect frame = _viewSignIn.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView animateWithDuration:0.5 animations:nil];
    frame.origin.y = SCREEN_HEIGHT_PORTRAIT- _viewSignIn.bounds.size.height ;
    _viewSignIn.frame = frame;
    [UIView commitAnimations];
    
}
- (IBAction)showSignUpPressed:(id)sender {
    
    _viewSignUp.frame = CGRectMake(0,SCREEN_HEIGHT_PORTRAIT +_viewSignUp.bounds.size.height, _viewSignUp.bounds.size.width, _viewSignUp.bounds.size.height);
    _viewSignUp.hidden = NO;
    CGRect frame = _viewSignUp.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView animateWithDuration:0.5 animations:nil];
    frame.origin.y = SCREEN_HEIGHT_PORTRAIT- _viewSignUp.bounds.size.height ;
    _viewSignUp.frame = frame;
    [UIView commitAnimations];
}
- (IBAction)signInWithFaceBookPressed:(id)sender {
    
   // [Util showMessage:@"Sign In FB" withTitle:@""];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.session.isOpen) {
        
        [appDelegate populateUserDetails];
    }
    else {
        
        [appDelegate openSessionWithAllowLoginUI:YES];
    }

}
- (IBAction)signInPressed:(id)sender {
    // check email empty
    if ([[_txtSignInEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self createAlertWithMessage:ALERT_EMPTY_EMAIL];
        return;
    }
    
    // check password empty
    if ([[_txtSignInPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self createAlertWithMessage:ALERT_EMPTY_PASSWORD];
        return;
    }
    
    // check password length 6->20
    if ([[_txtSignInPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 6 || [[_txtSignUpPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] >20) {
        [self createAlertWithMessage:ALERT_FAIL_PASSWORD];
        return;
    }
    
    // check format email
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:_txtSignInEmail.text] == NO) {
        
        [self createAlertWithMessage:ALERT_FAIL_FORMAT_EMAIL];
        return;
    }
    
    void(^successBlock)(ResponseObject *) = ^void(ResponseObject *responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",[responseObject.data objectForKey:KEY_CODE]] isEqualToString:@"0"]) {
            
        }
        
    };
    void(^failBlock)(ResponseObject *) = ^void(ResponseObject *responseObject) {
        
        [[Util sharedUtil] hideLoadingView];
        [Util showMessage:nil withTitle:ALERT_NETWORK_ERROR];
    };
    
    
    [[Util sharedUtil] showLoadingView];
    [[APIClient sharedClient] userLogin:_txtSignInEmail.text
                               password:_txtSignInPassWord.text
                                success:successBlock
                                failure:failBlock];



}
- (IBAction)signUpPressed:(id)sender {

    // check email empty
    if ([[_txtSignUpEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self createAlertWithMessage:ALERT_EMPTY_EMAIL];
        return;
    }
    
    // check password empty
    if ([[_txtSignUpPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        [self createAlertWithMessage:ALERT_EMPTY_PASSWORD];
        return;
    }
    
    // check password length 6->20
    if ([[_txtSignUpPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 6 || [[_txtSignUpPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] >20) {
        [self createAlertWithMessage:ALERT_FAIL_PASSWORD];
        return;
    }
    
    // check format email
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:_txtSignUpEmail.text] == NO) {
        
        [self createAlertWithMessage:ALERT_FAIL_FORMAT_EMAIL];
        return;
    }
    
    void(^successBlock)(ResponseObject *) = ^void(ResponseObject *responseObject) {
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
            
            TableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TableIdentifier"];
            [self.navigationController pushViewController:controller animated:YES];
            [Util showMessage:nil withTitle:ALERT_REGISTER_SUCCESS];
        }
        
    };
    
    void(^failBlock)(ResponseObject *) = ^void(ResponseObject *responseObject) {
        
        [[Util sharedUtil] hideLoadingView];
        [Util showMessage:nil withTitle:ALERT_NETWORK_ERROR];
        
    };
    [[Util sharedUtil] showLoadingView];
    [[APIClient sharedClient] userRegister:_txtSignUpEmail.text
                                  password:_txtSignUpPassWord.text
                                   success:successBlock
                                   failure:failBlock];
}
#pragma mark - KeyBoard
-(void)keyboardWillShow :(NSNotification *)notification{
    // Animate the current view out of the way
    [self setViewMovedUp:_viewSignIn];
    [self setViewMovedUp:_viewSignUp];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    

}
-(void)setViewMovedUp:(UIView *)viewMovedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = viewMovedUp.frame;
  
    rect.origin.y =  SCREEN_HEIGHT_PORTRAIT- viewMovedUp.bounds.size.height -HEIGHT_KEYBOARD;
    
    viewMovedUp.frame = rect;
    
    [UIView commitAnimations];
}


#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:_txtSignInEmail])
    {
      
    }
}


@end
