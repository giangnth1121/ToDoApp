//
//  Session.m
//  NewWindBase
//
//  Created by newwindsoft  on 8/15/12.
//  Copyright (c) 2012 newwindsoft . All rights reserved.
//

#import "Session.h"
#import "NSObject+Extension.h"

#define SESSION_KEY @"SESSION_DATA"

@implementation Session
@synthesize  userID;
@synthesize  username;
@synthesize  accessToken;
@synthesize  isAuthenticated;
@synthesize  deviceToken;
@synthesize  userInfo;
@synthesize  SessionID;
@synthesize  Password;
@synthesize  Email;

+ (Session *)sharedInstance{

    static Session *_sharedSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedSession = [[Session alloc]init];
    });
    
    return _sharedSession;
}

- (void)createNewSession
{
    self.SessionID = @"";
    self.accessToken = @"";
    self.userID = @"";
    self.Username = @"";
    self.Password = @"";
    self.Email = @"";
    self.Password = @"";
}

#pragma mark - Singleton
+ (Session *)activeSession {
    static Session *__activeSession;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __activeSession = [[Session alloc] init];
        [__activeSession createNewSession];
    });
    return __activeSession;
}

- (id)init {
    if (self = [super init]) {
        //Init
        [self getData];
    }
    
    return self;
}

- (void)initData {
    self.userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    self.userID = nil;
    self.username = nil;
    self.deviceToken = nil;
    self.accessToken = nil;
    self.isAuthenticated = 0;
}

/*
 * Save properties to NSUserDefaults
 */
- (void)save {
	NSDictionary *allDataTmp = [self propertiesDictionary];
    NSMutableDictionary *allData = [[NSMutableDictionary alloc] initWithDictionary:allDataTmp];
	
	for (id key in [allDataTmp allKeys]) {
		id value = [allDataTmp objectForKey:key];
		
		if (!([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSDictionary class]])) {
			[allData removeObjectForKey:key];
			//			DLog(@"Remove key: %@", key);
		}
	}
	
	//Save session
	NSString *sessionKey = [NSString stringWithFormat:@"%@_%@", SESSION_KEY, SESSION_VERSION];
	
    [[NSUserDefaults standardUserDefaults] setObject:allData forKey:sessionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 * Get all properties from NSUserDefaults
 */
- (void)getData {
	NSString *sessionKey = [NSString stringWithFormat:@"%@_%@", SESSION_KEY, SESSION_VERSION];
	
    NSDictionary *allData = [[NSUserDefaults standardUserDefaults] objectForKey:sessionKey];
	
    if (allData && ![allData isEqual:[NSNull null]]) {
		[self initData];
		
        NSArray *keyArray =  [allData allKeys];
        NSInteger count = [keyArray count];
        for (int i=0; i < count; i++) {
            id obj = [allData objectForKey:[keyArray objectAtIndex:i]];
			if ([self respondsToSelector:NSSelectorFromString([keyArray objectAtIndex:i])]) {

				[self setValue:obj forKey:[keyArray objectAtIndex:i]];
			}
        }
    } else {
        //Init some value
        [self initData];
    }
}

//////////////////////////////////////////////////////////////////////
//Implement all Session-related functions here


@end
