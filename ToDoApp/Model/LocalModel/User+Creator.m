//
//  User+Creator.m
//  SRPLS
//
//  Created by Tan Le on 8/22/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import "User+Creator.h"

@implementation User (Creator)

+ (User *)createWithId:(NSString *)ids {

    NSArray *users = [User findByAttribute:@"uid" withValue:[NSNumber numberWithInteger:[ids integerValue]]];
    if ([users count]) {
        
        return [users objectAtIndex:0];
    }
    else {
    
        User *user = [User createEntity];
        user.uid = [NSNumber numberWithInteger:[ids integerValue]];
        return user;
    }
}

+ (User *)currentUser {
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:user_logged_ids];    
    User *userobj = [User findFirstByAttribute:@"uid" withValue:[NSNumber numberWithInt:[uid integerValue]]];
    
    return userobj;
}
/*
 @property (nonatomic, retain) NSString * avatar;
 @property (nonatomic, retain) NSNumber * balance;
 @property (nonatomic, retain) NSNumber * uid;
 @property (nonatomic, retain) NSNumber * type;
 @property (nonatomic, retain) NSNumber * show_name;
 @property (nonatomic, retain) NSNumber * show_age;
 @property (nonatomic, retain) NSNumber * sex;
 @property (nonatomic, retain) NSNumber * positive;
 @property (nonatomic, retain) NSNumber * neutral;
 @property (nonatomic, retain) NSNumber * negative;
 @property (nonatomic, retain) NSString * location_name;
 @property (nonatomic, retain) NSNumber * location_id;
 @property (nonatomic, retain) NSString * last_login;
 @property (nonatomic, retain) NSString * joined;
 @property (nonatomic, retain) NSNumber * items;
 @property (nonatomic, retain) NSString * introduce;
 @property (nonatomic, retain) NSNumber * has_password;
 @property (nonatomic, retain) NSString * full_name;
 @property (nonatomic, retain) NSNumber * following;
 @property (nonatomic, retain) NSNumber * follower;
 @property (nonatomic, retain) NSString * fbid;
 @property (nonatomic, retain) NSString * email;
 @property (nonatomic, retain) NSNumber * degree;
 @property (nonatomic, retain) NSString * birth_day;
 @property (nonatomic, retain) NSString * username;
 */
- (void)setcontent:(NSDictionary *)content {
    
    self.avatar = stringCheckNull([content objectForKey:@"avatar"]);
    self.balance = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"balance"]) integerValue]];
    self.uid = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"uid"]) integerValue]];
    self.type = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"type"]) integerValue]];
    self.show_name = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"show_name"]) integerValue]];
    self.show_age = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"show_age"]) integerValue]];
    self.sex = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"sex"]) integerValue]];
    self.positive = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"positive"]) integerValue]];
    self.neutral = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"neutral"]) integerValue]];
    self.negative = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"negative"]) integerValue]];
    self.location_name = stringCheckNull([content objectForKey:@"location_name"]);//city
    self.location_id = [NSNumber numberWithInt:[stringCheckNull([content objectForKey:@"location_id"]) integerValue]];
    self.last_login = stringCheckNull([content objectForKey:@"last_login"]);
    self.joined = stringCheckNull([content objectForKey:@"joined"]);
    self.items = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"items"]) integerValue]];
    self.introduce = stringCheckNull([content objectForKey:@"introduce"]);
    self.has_password = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"has_password"]) integerValue]];
    self.full_name = stringCheckNull([content objectForKey:@"full_name"]);
    self.follower = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"follower"]) integerValue]];
    self.following = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"following"]) integerValue]];
    self.fbid = stringCheckNull([content objectForKey:@"fbid"]);
    self.email = stringCheckNull([content objectForKey:@"email"]);
    self.degree = [NSNumber numberWithInteger:[stringCheckNull([content objectForKey:@"degree"]) integerValue]];
    self.birth_day = stringCheckNull([content objectForKey:@"birth_day"]);
    self.username = stringCheckNull([content objectForKey:@"username"]);
    self.zipcode = stringCheckNull([content objectForKey:@"zipcode"]);
}

@end
