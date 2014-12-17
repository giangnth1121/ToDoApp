//
//  AppDelegate.h
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/12/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SlideNavigationController *rootNav;
@property (strong, nonatomic) FBSession *session;//Containt FB session.

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;//Open FB session
- (void)populateUserDetails;//Get FB Account info
- (void) logoutAccount;
@end

