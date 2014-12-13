//
//  User+Creator.h
//  SRPLS
//
//  Created by Tan Le on 8/22/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import "User.h"

@interface User (Creator)

+ (User *)createWithId:(NSString *)ids;
+ (User *)currentUser;
- (void)setcontent:(NSDictionary *)content;

@end
