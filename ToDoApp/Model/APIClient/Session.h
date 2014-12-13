//
//  Session.h
//  NewWindBase
//
//  Created by newwindsoft  on 8/15/12.
//  Copyright (c) 2012 newwindsoft . All rights reserved.
//

#import <Foundation/Foundation.h>

#define SESSION_VERSION @"22012013"

@interface Session : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, assign) BOOL isAuthenticated;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSMutableDictionary *userInfo;
@property (nonatomic, strong) NSString *SessionID;
@property (nonatomic, strong) NSString *Password;
@property (nonatomic, strong) NSString *Email;

+ (Session *)sharedInstance;
+ (Session *)activeSession;
- (void)save;
- (void)getData;
////////////////////////////////////////////////////
//Define all Session-related functions here
@end
