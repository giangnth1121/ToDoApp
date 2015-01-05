//
//  LoginViewController.m
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/13/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import "LoginViewController.h"
#import "NoteTableViewController.h"
#import "SMPageControl.h"
#import "SignInView.h"
#import "SignUpView.h"

#define LOGIN_FACEBOOK  0
#define LOGIN           1
#define SIGNUP          2
#define kOFFSET_FOR_KEYBOARD 80

@interface LoginViewController ()
{
    BOOL _isSignIn;
    SMPageControl *_pageControl;
    SignInView *_signInView;
    SignUpView *_signUpView;
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
    [self initViewSignIn];
    [self initViewSignUp];
}
- (void)initUI {


    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(resetFrameView:)];
    [self.view addGestureRecognizer:tapRecognizer];
    NSArray *arrayImages = [[NSArray alloc] initWithObjects:@"value-prop-0@2x.png", @"value-prop-1@2x.png", @"value-prop-2@2x.png", @"value-prop-3@2x.png", nil];
    
    UIImageView *imageBackground  = [[UIImageView alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH_PORTRAIT, 0, SCREEN_WIDTH_PORTRAIT* [arrayImages count], SCREEN_HEIGHT_PORTRAIT)];
    //imageBackground.image = [UIImage imageNamed:@"bg@2x.png"];
    imageBackground.image = [UIImage imageNamed:@""];
    [_scrollBackground addSubview:imageBackground];
    _scrollBackground.contentSize = CGSizeMake(SCREEN_WIDTH_PORTRAIT* [arrayImages count], SCREEN_HEIGHT_PORTRAIT);
    _scrollBackground.delegate = self;
    _scrollBackground.pagingEnabled = YES;
    [_scrollBackground addSubview: imageBackground];
    
    _scrollContent.backgroundColor = [UIColor clearColor];
    _scrollContent.pagingEnabled = YES;
    _scrollContent.delegate = self;
    
    _scrollContent.contentSize = CGSizeMake(SCREEN_WIDTH_PORTRAIT*[arrayImages count], SCREEN_HEIGHT_PORTRAIT);
    for (int i = 0; i<[arrayImages count]; i++) {
       // UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH_PORTRAIT*i + 60, 100, 200, 237)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH_PORTRAIT*i-20 , 0, SCREEN_WIDTH_PORTRAIT, SCREEN_HEIGHT_PORTRAIT)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", arrayImages[i]]];
        [_scrollContent addSubview:imgView];
        
    }
    
    _pageControl = [[SMPageControl alloc] init];
    [_pageControl setFrame:CGRectMake(self.view.center.x - 50, SCREEN_HEIGHT_PORTRAIT*0.691, 100, 20)];
    [_pageControl setNumberOfPages:[arrayImages count]];
    [_pageControl setBackgroundColor: [UIColor clearColor]];
    _pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"white_dot.png"];
    _pageControl.pageIndicatorImage = [UIImage imageNamed:@"black_dot.png"];
    [_pageControl sizeForNumberOfPages:10];
    
    [self.view addSubview:_pageControl];
}
- (void) initViewSignIn{
    if (_signInView == nil) {
        _signInView = [[SignInView alloc] init];
        _signInView.delegate = (id<SignInViewDelegate>)self;
        [self setFrameView:_signInView];
        [self.view addSubview:_signInView];
    }
    
}

- (void) initViewSignUp{
    if (_signUpView == nil) {
        _signUpView = [[SignUpView alloc] init];
        _signUpView.delegate = (id<SignUpViewDelegate>)self;
        
        [self setFrameView:_signUpView];
        [self.view addSubview:_signUpView];
    }
}

- (void) setFrameView:(UIView*)view{
    CGRect frame = view.frame;
    frame.origin.x = 0;
    frame.origin.y = SCREEN_HEIGHT_PORTRAIT;
    frame.size.width = SCREEN_WIDTH_PORTRAIT;
    view.frame = frame;
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
    _signInView.hidden = YES;
    _signUpView.hidden = YES;
    _viewContent.hidden = NO;
    [self.view endEditing:YES];
}
#pragma mark - IBAction

- (IBAction)showSignInViewTapped:(id)sender {
   
    _signUpView.hidden = YES;
    _viewContent.hidden = YES;
    _signInView.hidden = NO;
    
    [self setFrameViewForActionTapped:_signInView];
    NSLog(@"%f", _signInView.bounds.size.width);
    
}
- (IBAction)showSignUpViewTapped:(id)sender{
    
    _signInView.hidden = YES;
    _viewContent.hidden = YES;
    _signUpView.hidden = NO;
    
    [self setFrameViewForActionTapped:_signUpView];
}
- (IBAction)signInWithFaceBookTapped:(id)sender {
    
   // [Util showMessage:@"Sign In FB" withTitle:@""];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.session.isOpen) {
        
        [appDelegate populateUserDetails];
    }
    else {
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}

- (void)setFrameViewForActionTapped:(UIView*)view{
    CGRect frame = view.frame;
    frame.origin.y = SCREEN_HEIGHT_PORTRAIT;
    view.frame = frame;
    frame.origin.y = SCREEN_HEIGHT_PORTRAIT - view.bounds.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView animateWithDuration:0.3 animations:nil];
    view.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - KeyBoard
-(void)keyboardWillShow :(NSNotification *)notification{
    // Animate the current view out of the way
    [self setViewMovedUp:_signInView];
    [self setViewMovedUp:_signUpView];
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
   
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point;
    point.y = 0;
    point.x =  _scrollContent.contentOffset.x/2;
    
    [_scrollBackground setContentOffset:point];
    
    int page = _scrollContent.contentOffset.x / SCREEN_WIDTH_PORTRAIT;
    [_pageControl setCurrentPage:page];
}

#pragma mark -  Sign Up View Delegate
- (void)loginSuccess{
    
    NoteTableViewController *noteTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TableIdentifier"];
    //noteTVC.uID = self.uID;
    //NSLog(@"uId:%ld",(long)self.uID);
    [self.navigationController pushViewController:noteTVC animated:YES];
}

- (void) resgisterSuccess{
    [self loginSuccess];
}

#pragma mark - Autologin

- (void)autologinAcount {
    
    User *currentUser = [User currentUser];
    if (currentUser) {
        
        [[APIClient sharedClient] userLogin:currentUser.email password:[[NSUserDefaults standardUserDefaults] objectForKey:user_vinted_logged_password] success:^(ResponseObject *responseObject) {
            
            if ([[NSString stringWithFormat:@"%@",[responseObject.data objectForKey:KEY_CODE]] isEqualToString:@"0"]) {
                
                //[SWUtil saveInfoUser:[[responseObject.data objectForKey:KEY_DATA] objectForKey:KEY_PROFILE]];
                
                //Save current user
                NSDictionary *data = [responseObject.data objectForKey:KEY_DATA];
                NSDictionary *profile = [data objectForKey:@"profile"];
                
                User *userObj = [User createWithId:stringCheckNull([profile objectForKey:@"uid"])];
                [userObj setcontent:profile];
                [DataManager saveAllChanges];
                
                [[NSUserDefaults standardUserDefaults] setObject:stringCheckNull([profile objectForKey:@"uid"]) forKey:user_logged_ids];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:user_logged_type];
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kIS_LOGED];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self loginSuccess];
            }
            
        } failure:^(ResponseObject *failureObject) {
            
            
        }];
        
    }
}

- (void)autologinFBAccount {
    
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *fbInfomation = [udf objectForKey:uf_FB_ACCOUNT];
    NSString *access_token = [fbInfomation  objectForKey:uf_fb_accessToken];
    NSString *fbid = [fbInfomation objectForKey:uf_fb_id];
    NSString *device_id = UNIQUEIDENTIFIER_FOR_VENDOR;
    
    [[APIClient sharedClient] userFaceBookLogin:access_token fbId:fbid deviceId:device_id success:^(ResponseObject *responseObject) {
        
        if ([stringCheckNull([responseObject.data objectForKey:@"code"]) integerValue] == 0) {
            
            NSDictionary *dict = [responseObject.data objectForKey:@"data"];
            if ([stringCheckNull([dict objectForKey:@"confirmed"]) integerValue] == 0) {//Present Register form
                
            }
            else {//Logedin and update UI for LeftMenu
                
                NSDictionary *profile = [dict objectForKey:@"profile"];
                NSString *userId = stringCheckNull([profile objectForKey:@"uid"]);
                
                User *userObj = [User createWithId:userId];
                [userObj setcontent:profile];
                [DataManager saveAllChanges];
                
                //Save current user to userdefault
                [[NSUserDefaults standardUserDefaults] setObject:userId forKey:user_logged_ids];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:user_logged_type];
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kIS_LOGED];
            }
        }
        
    } failure:^(ResponseObject *failureObject) {
        
        
    }];
}

@end
