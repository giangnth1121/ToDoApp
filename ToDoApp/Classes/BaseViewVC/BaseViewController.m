//
//  SWBaseViewController.m
//  SRPLS
//
//  Created by Tan Le on 7/20/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface BaseViewController () {
    
    MBProgressHUD *HUD;
    
}

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return self.isDisplayLeftMenu;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)initUI {}
- (void)updateUI {}
- (void)initData {

}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)setBackButtonWithImage:(NSString*)imageButtonName
              highlightedImage:(NSString*)highlightedImageButtonName
                        target:(id)target action:(SEL)action {
    
    UIImage *temBack = [UIImage imageNamed:imageButtonName];
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpButton setBackgroundImage:[UIImage imageNamed:imageButtonName] forState:UIControlStateNormal];
    [tmpButton setBackgroundImage:[UIImage imageNamed:highlightedImageButtonName] forState:UIControlStateHighlighted];
    [tmpButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    tmpButton.frame = CGRectMake(0, 0, temBack.size.width, temBack.size.height);
    
    [tmpButton setShowsTouchWhenHighlighted:YES];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:tmpButton]];
}

- (void)setRightButtonWithImage:(NSString*)imageButtonName
               highlightedImage:(NSString*)highlightedImageButtonName
                         target:(id)target action:(SEL)action {
    
    UIImage *temEdit = [UIImage imageNamed:imageButtonName];
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpButton setBackgroundImage:[UIImage imageNamed:imageButtonName] forState:UIControlStateNormal];
    [tmpButton setBackgroundImage:[UIImage imageNamed:highlightedImageButtonName] forState:UIControlStateHighlighted];
    [tmpButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    tmpButton.frame = CGRectMake(0, 0, temEdit.size.width, temEdit.size.height);
    [tmpButton setShowsTouchWhenHighlighted:YES];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:tmpButton]];
}
//Back button with title
- (void)setBackButtonWithImage:(NSString*)imageButtonName
                         title:(NSString*)title
              highlightedImage:(NSString*)highlightedImageButtonName
                        target:(id)target action:(SEL)action {
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //tmpButton.frame.size.width = temBack.size.width + tmpButton.frame.size.width;
    [tmpButton setImage:[UIImage imageNamed:imageButtonName] forState:UIControlStateNormal];
    [tmpButton setTitle:title forState:UIControlStateNormal];
    [tmpButton setBackgroundImage:[UIImage imageNamed:highlightedImageButtonName] forState:UIControlStateHighlighted];
    [tmpButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [tmpButton sizeToFit];
    [tmpButton setShowsTouchWhenHighlighted:YES];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:tmpButton]];
}

//Right button with title
- (void)setRightButtonWithImage:(NSString*)imageButtonName
                          title:(NSString*)title
               highlightedImage:(NSString*)highlightedImageButtonName
                         target:(id)target action:(SEL)action {
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //tmpButton.frame.size.width = temBack.size.width + tmpButton.frame.size.width;
    [tmpButton setImage:[UIImage imageNamed:imageButtonName] forState:UIControlStateNormal];
    [tmpButton setTitle:title forState:UIControlStateNormal];
    [tmpButton setBackgroundImage:[UIImage imageNamed:highlightedImageButtonName] forState:UIControlStateHighlighted];
    [tmpButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [tmpButton sizeToFit];
    [tmpButton setShowsTouchWhenHighlighted:YES];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:tmpButton]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
