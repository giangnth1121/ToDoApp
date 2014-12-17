//
//  AppDelegate.m
//  ToDoApp
//
//  Created by NGUYENHAGIANG on 12/12/14.
//  Copyright (c) 2014 NGUYENHAGIANG. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // init resgister notification
    if([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound |
           UIUserNotificationTypeAlert |
           UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge];
    }

    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    // Override point for customization after application launch.
    return YES;
}
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - notification delegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token{
    
    NSLog(@"Inform the server of this device token: %@", token);
    
    //    // send device token to server
    //    // send device token to server
    NSString *stringToken= [NSString stringWithFormat:@"%@",token];
    
    stringToken = [stringToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    stringToken = [stringToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    [Util saveDeviceToken:stringToken];
    
    NSString *strTypeID = @"2";
    int typeID = [strTypeID intValue];
    NSString *strRegID = @"1";
    int regID = [strRegID intValue];
    [[APIClient sharedClient] registerDeviceWithTypeID:typeID
                                                 regID:regID
                                               success:^(ResponseObject *responseObject) {
                                                   
                                                      NSLog(@"register success");
                                               } failure:^(ResponseObject *failureObject) {
                                                   //NSLog(@"register fail:");
                                                   NSLog(@"Register Device error:%@",failureObject.message);
                                               }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0) {
    NSLog(@"register fail: %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"userInfo %@",userInfo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}

#pragma mark-  FB SDK

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {

    NSArray *permissions =
    [NSArray arrayWithObjects:@"email", nil];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                [self populateUserDetails];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SCSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)populateUserDetails {
    
    if (FBSession.activeSession.isOpen) {
        
        [[Util sharedUtil] showLoadingView];
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 NSLog(@"user: %@", user);
                 //Save FB infomation in to NSUserDefaults
                 NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                 
                 NSMutableDictionary *fbAccount = [df objectForKey:uf_FB_ACCOUNT];
                 NSLog(@"fbAccount: %@", fbAccount);
                 if (!fbAccount) {
                     
                     fbAccount = [[NSMutableDictionary alloc]init];
                     _setObjectToDictionary(fbAccount, uf_fb_id, stringCheckNull([user objectForKey:uf_fb_id]));
                     _setObjectToDictionary(fbAccount, uf_fb_email, stringCheckNull([user objectForKey:uf_fb_email]));
                     _setObjectToDictionary(fbAccount, uf_fb_first_name, stringCheckNull([user objectForKey:uf_fb_first_name]));
                     _setObjectToDictionary(fbAccount, uf_fb_last_name, stringCheckNull([user objectForKey:uf_fb_last_name]));
                     _setObjectToDictionary(fbAccount, uf_fb_gender, stringCheckNull([user objectForKey:uf_fb_gender]));
                 }
                 _setObjectToDictionary(fbAccount, uf_fb_accessToken, self.session.accessTokenData.accessToken);
                 
                 [df setObject:fbAccount forKey:uf_FB_ACCOUNT];
                 [df synchronize];
                 
                 [[Util sharedUtil] hideLoadingView];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:SCSessionGetUserSucess object:nil];
                 
             } else {
                 
                 NSString *msg = @"Can't connect to Facebook. Please try again later";
                 UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Login" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [a show];
                 
                 [[Util sharedUtil] hideLoadingView];
             }
         }];
    }
}

- (void) logoutAccount {
    if (FBSession.activeSession.isOpen) {
        [FBSession.activeSession close];
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}
#pragma mark - Impelment FB SDK callback

// will be boolean NO, meaning the URL was not handled by the authenticating application
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}


@end
