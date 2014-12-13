//
//  User.h
//  SRPLS
//
//  Created by Tan Le on 8/22/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

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
@property (nonatomic, retain) NSString * zipcode;
@end
