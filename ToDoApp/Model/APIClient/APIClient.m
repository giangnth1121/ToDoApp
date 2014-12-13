
//
//  APIClient.m
//  NewWindBase
//
//  Created by newwindsoft  on 8/6/13.
//  Copyright (c) 2013 newwindsoft . All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

+ (APIClient *)sharedClient {
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseServer]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self)
    {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    return self;
}

/*
 * Handle Success Operation
 */
- (void)handleSuccess:(id)responseData success:(void (^)(ResponseObject *responseObject))blockSuccess
{
    if (blockSuccess) {
		NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		
        NSError *error = nil;
        NSDictionary *responseDict;
		if (responseData) {
			responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
		} else {
			responseDict = nil;
		}
		ResponseObject *responseObject = [[ResponseObject alloc] init];
		
		if (error) {
			responseObject.data = nil;
			responseObject.message = responseString;
		} else {
			responseObject.data = responseDict;
			responseObject.message = @"Success!";
		}
		
        blockSuccess(responseObject);
    }
}

/*
 * Handle Failed Operation
 */
- (void)handleFailed:(NSError *)error failure:(void (^)(ResponseObject *failureObject))blockFail
{
    if (blockFail) {
        ResponseObject *responseObject = [[ResponseObject alloc] init];
		responseObject.errorCode = (NSInteger)error.code;
		responseObject.data = nil;
		responseObject.message = [error.userInfo objectForKey:@"message"];
		//TrungDQ - Add general info to responseObject
        responseObject.info = error.userInfo;
        blockFail(responseObject);
    }
}


//Process response
- (void)processOperation:(AFHTTPRequestOperation *)operation withData:(id)responseObject success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure
{
	
	if ([operation.response statusCode] != kJSONSuccess && [operation.response statusCode] != kJSONCreatedSuccess && [operation.response statusCode] != kJSONDeletedSuccess) {
		NSError *errorParser = nil;
        NSDictionary *responseDict;
		if (operation.responseData) {
			responseDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&errorParser];
		} else {
			responseDict = nil;
		}
		
		NSString *message = @"";
		if (responseDict && !errorParser) {
			message = [responseDict objectForKey:@"error"];
		} else {
			message = operation.responseString;
		}
		
		NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];
		if ((message == nil) && ([operation.response statusCode] == kJSONForbiddenError)) {
            userInfo = responseDict;
        }
		NSError *error = [[NSError alloc] initWithDomain:operation.request.URL.absoluteString code:operation.response.statusCode userInfo:userInfo];
		[self handleFailed:error failure:blockFailure];
		return;
	}
	[self handleSuccess:responseObject success:blockSuccess];
}

#pragma mark - User

- (void) userLogin:(NSString *)userName password:(NSString *)password success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserLogin;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"account", userName);
    _setObjectToDictionary(params, @"password", password);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) userLoginHidden:(NSString *)uID token:(NSString *)token success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserLoginHidden;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"uid", uID);
    _setObjectToDictionary(params, @"token_value", token);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) userRegister:(NSString *)userName password:(NSString *)password email:(NSString *)email dataImage:(NSData *)data success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserRegister;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"email", email);
    _setObjectToDictionary(params, @"username", userName);
    _setObjectToDictionary(params, @"password", password);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
//    [self postPath:path parameters:params data:data mimeType:@"image/jpeg" name:@"avatar" fileName:@"avatar.jpg" success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
//    }];
    
}

- (void) userChangeAvatarWithDataImage:(NSData *)data success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserChangeAvatar;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User *user = [User currentUser];
    
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    
    [self postPath:path parameters:params data:data mimeType:@"image/jpeg" name:@"avatar" fileName:[NSString stringWithFormat:@"avatar%@.jpg",timestamp] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) userFaceBookLogin:(NSString *)accessToken fbId:(NSString *)fbId deviceId:(NSString *)deviceId success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkUserFacebookLogin;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"access_token", accessToken);
    _setObjectToDictionary(params, @"fbid", fbId);
    _setObjectToDictionary(params, @"device_id", deviceId);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void) userFaceBookRegister:(NSString *)fbId deviceId:(NSString *)deviceId userName:(NSString *)userName email:(NSString *)email success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    /*
     '+email
     +fbid
     +username
     +full_name
     +device_id
     */
    
    NSString *path = kLinkUserFacebookRegister;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    _setObjectToDictionary(params, @"fbid", fbId);
    _setObjectToDictionary(params, @"device_id", deviceId);
    _setObjectToDictionary(params, @"username", userName);
    _setObjectToDictionary(params, @"email", email);
    _setObjectToDictionary(params, @"full_name", userName);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void) userEditProfile:(NSDictionary *)dictProfile success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserEditProfile;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User *user = [User currentUser];
    
    _setObjectToDictionary(params, KEY_UID, user.uid);
    _setObjectToDictionary(params, KEY_FULL_NAME, user.full_name);
    _setObjectToDictionary(params, KEY_AVATAR, user.avatar);
    _setObjectToDictionary(params, KEY_SEX, [dictProfile objectForKey:KEY_SEX]);
    _setObjectToDictionary(params, KEY_LOCATION_ID, [dictProfile objectForKey:KEY_LOCATION_ID]);
    _setObjectToDictionary(params, KEY_BIRTHDAY, [dictProfile objectForKey:KEY_BIRTHDAY]);
    _setObjectToDictionary(params, KEY_SHOW_AGE, [dictProfile objectForKey:KEY_SHOW_AGE]);
    _setObjectToDictionary(params, KEY_SHOW_NAME, [dictProfile objectForKey:KEY_SHOW_NAME]);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);

    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) userGetProfile:(NSString *)uid success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserGetProfile;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User *user = [User currentUser];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"seller_id", uid);

    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) userForgotPassword:(NSString *)email success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserRegister;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"email", email);
    
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) userChangePassword:(NSString *)oldPass newPass:(NSString *)newPass success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserChangePassword;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"uid", [[Util getInfoUser] objectForKey:KEY_UID]);
    _setObjectToDictionary(params, @"password", oldPass);
    _setObjectToDictionary(params, @"new_password", newPass);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) userGetLocationWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserGetLocation;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) userGetListFollowingWithSellerID:(NSString *)sellerID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserFollowing;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User *user = [User currentUser];
    
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    _setObjectToDictionary(params, @"seller_id", sellerID);
    _setObjectToDictionary(params, @"uid", user.uid);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) userGetListFollowerWithSellerID:(NSString *)sellerID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserFollower;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
     User *user = [User currentUser];
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    _setObjectToDictionary(params, @"seller_id", sellerID);
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) userGetItemsWithUser:(NSString *)userID page:(NSString *)page Success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserGetUserItems;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
     User *user = [User currentUser];
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"owner_id", userID);
    _setObjectToDictionary(params, @"page", page);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) postFeedback:(NSDictionary *)dictInfo  Withsuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{

    NSString *path = kLinkUserPostFeedback;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"uid",[dictInfo objectForKey:KEY_UID]);
    _setObjectToDictionary(params, @"seller_id",[dictInfo objectForKey:KEY_RECEIVER_ID]);
    _setObjectToDictionary(params, @"type",[dictInfo objectForKey:KEY_TYPE]);
    _setObjectToDictionary(params, @"content",[dictInfo objectForKey:KEY_CONTENT]);

    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void) userGetFeedBack :(NSDictionary*)dictInfo WithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    NSString *path = kLinkUserGetFeedback;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"seller_id", [dictInfo objectForKey:KEY_UID]);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];

}

- (void) userFollowUser :(NSString*)followerid type:(NSString *)type success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkUserRegisterFollowUser;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User *user = [User currentUser];
    
    _setObjectToDictionary(params, @"uid", user.uid);
    _setObjectToDictionary(params, @"followerid", followerid);
    _setObjectToDictionary(params, @"type", type);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) userFollowBrand:(NSString*)brandID type:(NSString *)type success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkUserRegisterFollowBrand;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User *user = [User currentUser];
    
    _setObjectToDictionary(params, @"uid", user.uid);
    _setObjectToDictionary(params, @"brand_id", brandID);
    _setObjectToDictionary(params, @"type", type);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) userSearchUserWithKey:(NSString*)key success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *responseObject))blockFailure {
    
    NSString *path = kLinkUserSearchUser;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"key", key);
 
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void)sendReportUser:(NSString *)sellerID content:(NSString *)content withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void (^)(ResponseObject * failureObject))blockFailure {
    
    NSString *path = kLinkUserReportItem;
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"seller_id", sellerID);
    _setObjectToDictionary(params, @"content", content);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
        
    }];
}

- (void)getQuantityInfoWithSuccess:(void(^)(ResponseObject *responseObject))blockSuccess failure:(void(^)(ResponseObject *failureObject)) blockFailure{
    NSString *path = kLinkUserGetQuantity_info;
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
        
    }];
}

- (void)loutOutWithSuccess:(void(^)(ResponseObject *responseObject))blockSuccess failure:(void(^)(ResponseObject *failureObject)) blockFailure{
    NSString *path = kLinkUserLogout;
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
        
    }];
}

#pragma mark - Message

- (void)checkConversationProductWithUserID:(NSString *)uid productID:(NSString *)productID success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure{
    
    NSString *path = kLinkMessagecheckConversationProduct;
    
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"user2_id", uid);
    _setObjectToDictionary(params, @"product_id", productID);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
        
    }];
    
}

- (void)createConversationWithUserID:(NSString *)uid productID:(NSString *)productID success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure{
    
    NSString *path = kLinkMessageCreateConversation;
    
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"user2_id", uid);
    _setObjectToDictionary(params, @"product_id", productID);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
        
    }];
    
}
- (void)deleteConversationWithUserID:(NSString *)conID success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure{
    
    NSString *path = kLinkMessageDeleteConversation;
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"con_id",conID );
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
        
    }];
    
}
- (void)getListConversationPage:(NSInteger)page WithSuccess: (void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure{
    
    NSString *path = kLinkMessageGetListConversation;
    
    User *user = [User currentUser];
    NSString *numberPage = [NSString stringWithFormat:@"%i",page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"page", numberPage);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
        
    }];
    
}

- (void)getListMessage:(NSString *)conID success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure{
    
    NSString *path = kLinkMessageGetListMessage;
    
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"con_id", conID);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
        
    }];
    
}

- (void)getListOrderMessage:(NSString *)orderID messagePage:(int)pageIndex success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure {
    NSString *path = kLinkMessageGetOrderMessage;
    
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"order_id", orderID);
    _setObjectToDictionary(params, @"page", [[NSNumber numberWithInt:pageIndex] stringValue]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
        
    }];
}

- (void)postMessage:(NSString *)conID type:(NSInteger)type content:(NSString *)content success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure{
    
    NSString *path = kLinkMessagePostMessage;
    
    User *user = [User currentUser];
    
    NSString *stringType = [NSString stringWithFormat:@"%ld",(long)type];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"con_id", conID);
    _setObjectToDictionary(params, @"message", content);
    _setObjectToDictionary(params, @"type", stringType);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
        
    }];
}

- (void)postOrderMessage:(NSString *)orderID type:(NSInteger)type content:(NSString *)content success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure {
    NSString *path = kLinkMessagePostOrderMessage;
    
    User *user = [User currentUser];
    NSString *stringType = [NSString stringWithFormat:@"%ld",(long)type];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"order_id", orderID);
    _setObjectToDictionary(params, @"content", content);
    _setObjectToDictionary(params, @"type", stringType);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
        
    }];
}

- (void) postMessageImage:(NSMutableArray *)arrData conID:(NSString *)conID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkMessagePostMessage;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User *user = [User currentUser];
    
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"con_id", conID);
    _setObjectToDictionary(params, @"message", @"");
    _setObjectToDictionary(params, @"type", @"2");
    
    NSMutableArray *arrayName = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arrData count]; i++) {
        [arrayName addObject:[NSString stringWithFormat:@"imageMess%d",i]];
    }
    
    [self postPathWithMultiImage:path parameters:params data:arrData mimeType:@"image/jpeg" name:arrayName success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) postOrderMessageImage:(NSMutableArray *)arrData orderID:(NSString *)orderID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    NSString *path = kLinkMessagePostOrderMessage;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User *user = [User currentUser];
    
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"order_id", orderID);
    _setObjectToDictionary(params, @"content", @"");
    _setObjectToDictionary(params, @"type", @"2");
    
    NSMutableArray *arrayName = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arrData count]; i++) {
        [arrayName addObject:[NSString stringWithFormat:@"imageMess%d",i]];
    }
    
    [self postPathWithMultiImage:path parameters:params data:arrData mimeType:@"image/jpeg" name:arrayName success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

#pragma mark - Feed

- (void) getListFeedWithPage:(NSInteger)page success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkGetFeed;
    
    User *user = [User currentUser];
    
    NSString *str =  [NSString stringWithFormat:@"%d",(int)page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params,@"page",str);
    
    NSString *logedIn = [[NSUserDefaults standardUserDefaults] objectForKey:kIS_LOGED];
    if ([logedIn isEqualToString:@"YES"]){
        _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    }
    
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) getListFavouriteWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkGetListFavoriteProduct;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    User *user = [User currentUser];
    _setObjectToDictionary(params, @"uid",[user.uid stringValue]);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) getNotification: (NSInteger) page WithSuccess:(void(^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkGetNotification;
    
    User *user = [User currentUser];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *numberPage =  [NSString stringWithFormat:@"%d",(int)page];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    _setObjectToDictionary(params, @"page", numberPage);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) feedFavorireProduct:(NSString *) productID type:(NSString *)type success:(void(^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkFeedFavoriteProduct;
    
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"product_id", productID);
    _setObjectToDictionary(params, @"type", type);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) getProductComments :(NSString*) productID  page :(NSInteger) page success:(void(^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkGetProductComment;
    
    NSString *numberPage =  [NSString stringWithFormat:@"%d",(int)page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"product_id", productID);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    _setObjectToDictionary(params, @"page", numberPage);

    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void) commentProduct :(NSDictionary*) dict   success:(void(^)(ResponseObject* responseObject)) blockSuccess failure:(void(^)(ResponseObject *failureObject)) blockFailure{
    NSString *path = kLinkCommentProduct;
    
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"product_id", [dict objectForKey:KEY_PRODUCT_ID]);
    _setObjectToDictionary(params, @"content", [dict objectForKey:KEY_CONTENT]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void) getSelectedMySize:(void(^)(ResponseObject* responseObject)) blockSuccess failure:(void(^)(ResponseObject *failureObject)) blockFailure{
    
    NSString *path = kLinkGetSelectedMySize;
    
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void) postSelectedMySizeWithUseInFeed:(BOOL)flag clothing:(NSString *)strClothing shoes:(NSString *)strShoes success:(void(^)(ResponseObject* responseObject)) blockSuccess failure:(void(^)(ResponseObject *failureObject)) blockFailure{
    
    NSString *path = kLinkPostSelectedMySize;
    
    NSString *strUseInFeed = @"0";
    if (flag) {
        strUseInFeed = @"1";
    }
    
    User *user = [User currentUser];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"use_in_feed", strUseInFeed);
    _setObjectToDictionary(params, @"size_clothing", strClothing);
    _setObjectToDictionary(params, @"size_shoes", strShoes);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void) viewedNotifyID:(NSString*)notify_ID WithSuccess:(void(^)(ResponseObject* responseObject)) blockSuccess failure:(void (^)(ResponseObject *failureObject)) blockFailure{
    
    NSString *path = kLinkViewedNotify;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"notify_id", notify_ID);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

#pragma mark - Product

- (void) getCategoriesWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkProductGetCategories;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) getProductByCategoryID:(NSString *)catID pageIndex:(NSInteger)page success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkProductGetByCatID;
    
    NSString *stringPage = [NSString stringWithFormat:@"%d",(int)page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User *user = [User currentUser];
    _setObjectToDictionary(params, @"uid", [user.uid  stringValue]);
    _setObjectToDictionary(params, @"cat_id", catID);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    _setObjectToDictionary(params, @"page", stringPage);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) getBrandWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {

    NSString *path = kLinkProductGetBrand;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) getConditionWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkProductGetCondition;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) getColorsWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkProductGetColors;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) postProduct:(NSDictionary *)dictInfo imageData:(NSMutableArray *)arrayData arrayImageName:(NSMutableArray *)arrayImgName  success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkProductPostProduct;
    
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"uid",[user.uid stringValue]);
    _setObjectToDictionary(params, @"cat_id",[dictInfo objectForKey:KEY_CAT_ID]);
    _setObjectToDictionary(params, @"title",[dictInfo objectForKey:KEY_TITLE]);
    _setObjectToDictionary(params, @"brand_id",[dictInfo objectForKey:KEY_BRAND_ID]);
    _setObjectToDictionary(params, @"description",[dictInfo objectForKey:KEY_DESCRIPTION]);
    _setObjectToDictionary(params, @"size_id",[dictInfo objectForKey:KEY_SIZE_ID]);
    _setObjectToDictionary(params, @"condition_id",[dictInfo objectForKey:KEY_CONDITION_ID]);
    _setObjectToDictionary(params, @"color_id1", [dictInfo objectForKey:KEY_COLOR_ID1]);
    _setObjectToDictionary(params, @"color_id2",[dictInfo objectForKey:KEY_COLOR_ID2]);
    _setObjectToDictionary(params, @"selling_price",[dictInfo objectForKey:KEY_SELLING_PRICE ]);
    _setObjectToDictionary(params, @"original_price", [dictInfo objectForKey:KEY_ORIGINAL_PRICE]);
    _setObjectToDictionary(params, @"package_size", [dictInfo objectForKey:KEY_PACKAGE_SIZE]);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    _setObjectToDictionary(params, @"images", @"images");
    _setObjectToDictionary(params, @"is_sell",[dictInfo objectForKey:KEY_IS_SELL]);
    _setObjectToDictionary(params, @"is_swap",[dictInfo objectForKey:KEY_IS_SWAP]);
    _setObjectToDictionary(params, @"is_give",[dictInfo objectForKey:KEY_IS_GIVE]);
    _setObjectToDictionary(params, @"zipcode",[dictInfo objectForKey:KEY_ZIPCODE]);
    
    [self postPathWithMultiImage:path parameters:params data:arrayData mimeType:@"image/jpeg" name:arrayImgName success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];

}

- (void) editProduct:(NSDictionary *)dictInfo arrayData:(NSMutableArray *)arrayData success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkProductEditProduct;
    
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"uid",[user.uid stringValue]);
    _setObjectToDictionary(params, @"cat_id",[dictInfo objectForKey:KEY_CAT_ID]);
    _setObjectToDictionary(params, @"title",[dictInfo objectForKey:KEY_TITLE]);
    _setObjectToDictionary(params, @"brand_id",[dictInfo objectForKey:KEY_BRAND_ID]);
    _setObjectToDictionary(params, @"description",[dictInfo objectForKey:KEY_DESCRIPTION]);
    _setObjectToDictionary(params, @"size_id",[dictInfo objectForKey:KEY_SIZE_ID]);
    _setObjectToDictionary(params, @"condition_id",[dictInfo objectForKey:KEY_CONDITION_ID]);
    _setObjectToDictionary(params, @"color_id1", [dictInfo objectForKey:KEY_COLOR_ID1]);
    _setObjectToDictionary(params, @"color_id2",[dictInfo objectForKey:KEY_COLOR_ID2]);
    _setObjectToDictionary(params, @"selling_price",[dictInfo objectForKey:KEY_SELLING_PRICE ]);
    _setObjectToDictionary(params, @"original_price", [dictInfo objectForKey:KEY_ORIGINAL_PRICE]);
    _setObjectToDictionary(params, @"package_size", [dictInfo objectForKey:KEY_PACKAGE_SIZE]);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    _setObjectToDictionary(params, @"images", @"images");
    _setObjectToDictionary(params, @"is_sell",[dictInfo objectForKey:KEY_IS_SELL]);
    _setObjectToDictionary(params, @"is_swap",[dictInfo objectForKey:KEY_IS_SWAP]);
    _setObjectToDictionary(params, @"is_give",[dictInfo objectForKey:KEY_IS_GIVE]);
    _setObjectToDictionary(params, @"zipcode",[dictInfo objectForKey:KEY_ZIPCODE]);
    _setObjectToDictionary(params, @"product_id", [dictInfo objectForKey:KEY_PRODUCT_ID]);
    
    NSString *stringListType = @"";
    NSString *stringListIndex = @"";
    NSMutableArray *arrayImgName = [[NSMutableArray alloc] init];
    for (int i = 0;  i < [arrayData count]; i++) {
        if (i == [arrayData count] - 1) {
            stringListType = [stringListType stringByAppendingString:@"2"];
            stringListIndex = [stringListIndex stringByAppendingString:[NSString stringWithFormat:@"%d",i]];
            
        }
        else {
            stringListType = [stringListType stringByAppendingString:@"2,"];
            stringListIndex = [stringListIndex stringByAppendingString:[NSString stringWithFormat:@"%d,",i]];
        }
        
        [arrayImgName addObject:[NSString stringWithFormat:@"image%d.jpg",i]];
    }
    
    _setObjectToDictionary(params, @"edit_image", @"1");
    _setObjectToDictionary(params, @"list_type",stringListType);
    _setObjectToDictionary(params, @"list_index", stringListIndex);
    
    [self postPathWithMultiImage:path parameters:params data:arrayData mimeType:@"image/jpeg" name:arrayImgName success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
//    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
//    }];
    
}


- (void) getCateoriesSize:(NSString *)catID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkProductGetCategoriesSize;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"cat_id", catID);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) getProductDetailByID:(NSString *)productID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkProductGetProductDetail;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"product_id", productID);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    NSString *logedIn = [[NSUserDefaults standardUserDefaults] objectForKey:kIS_LOGED];
    if ([logedIn isEqualToString:@"YES"]) {
        User *user = [User currentUser];
        _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    }

    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) getProductBrandInfo:(NSString *)brandID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkProductGetBrandInfo;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"brand_id", brandID);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    NSString *logedIn = [[NSUserDefaults standardUserDefaults] objectForKey:kIS_LOGED];
    if ([logedIn isEqualToString:@"YES"]) {
        User *user = [User currentUser];
        _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    }
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) getProductRelatedWithID:(NSString *)productID page:(NSInteger) page userID:(NSString *)userID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkProductGetProductRelated;
    
    User *user = [User currentUser];
    NSString *numberPage =  [NSString stringWithFormat:@"%ld",(long)page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"product_id", productID);
    _setObjectToDictionary(params, @"page",numberPage);
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) getMemberItems:(NSString *)productID page:(NSInteger) page userID:(NSString *)userID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkProductGetMemberItems;
    
    User *user = [User currentUser];
    NSString *numberPage =  [NSString stringWithFormat:@"%ld",(long)page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"product_id", productID);
    _setObjectToDictionary(params, @"page",numberPage);
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}



- (void) getProductBrandWithBrandID:(NSString *)brandID page:(NSInteger) page success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkProductGetProductBrand;
    
    NSString *numberPage =  [NSString stringWithFormat:@"%ld",(long)page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User *user = [User currentUser];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"brand_id", brandID);
    _setObjectToDictionary(params, @"page",numberPage);

    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) searchBrand:(NSString *)stringKey  success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkProductSearchBrand;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"key", stringKey);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void) searchProduct:(NSDictionary *)dictInfoSearch pageIndex:(NSInteger)page success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {

    NSString *path = kLinkProductSearchProduct;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *stringPage = [NSString stringWithFormat:@"%d",page];
    
    User *user = [User currentUser];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, KEY_KEY_SERARCH  , [dictInfoSearch objectForKey:KEY_KEY_SERARCH]);
    _setObjectToDictionary(params, KEY_FROM_PRICE   , [dictInfoSearch objectForKey:KEY_FROM_PRICE]);
    _setObjectToDictionary(params, KEY_TO_PRICE     , [dictInfoSearch objectForKey:KEY_TO_PRICE]);
    _setObjectToDictionary(params, KEY_SIZE_TYPE    , [dictInfoSearch objectForKey:KEY_SIZE_TYPE]);
    _setObjectToDictionary(params, KEY_SIZE_IDS     , [dictInfoSearch objectForKey:KEY_SIZE_IDS]);
    _setObjectToDictionary(params, KEY_COLOR_IDS    , [dictInfoSearch objectForKey:KEY_COLOR_IDS]);
    _setObjectToDictionary(params, KEY_LOCATION_IDS , [dictInfoSearch objectForKey:KEY_LOCATION_IDS]);
    _setObjectToDictionary(params, KEY_CONDITION_IDS, [dictInfoSearch objectForKey:KEY_CONDITION_IDS]);
    _setObjectToDictionary(params, KEY_BRAND_IDS    , [dictInfoSearch objectForKey:KEY_BRAND_IDS]);
    _setObjectToDictionary(params, KEY_IS_SELL    , [dictInfoSearch objectForKey:KEY_IS_SELL]);
    _setObjectToDictionary(params, KEY_IS_SWAP    , [dictInfoSearch objectForKey:KEY_IS_SWAP]);
    _setObjectToDictionary(params, KEY_IS_GIVE   , [dictInfoSearch objectForKey:KEY_IS_GIVE]);
 
    _setObjectToDictionary(params, @"page", stringPage);

    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void)changeStatusProduct: (NSString *) productID status:(NSString *)status withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void (^)(ResponseObject * failureObject))blockFailure{
    
    NSString *path = kLinkProductChangeStatusProduct;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"product_id", productID);
    _setObjectToDictionary(params, @"status", status);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)sendReportProduct:(NSString *)productID content:(NSString *)content withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void (^)(ResponseObject * failureObject))blockFailure {
    NSString *path = kLinkProductReportItem;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User *user = [User currentUser];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"product_id", productID);
    _setObjectToDictionary(params, @"content", content);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)changeStatusAsSold:(NSString *) productID asSold:(NSString *)status withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void (^)(ResponseObject * failureObject))blockFailure{
    
    NSString *path = kLinkProductMarkassold;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"product_id", productID);
    _setObjectToDictionary(params, @"as_sold", status);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

#pragma mark - setting

- (void) getCreditCardsWithSuccess:(void (^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject * failureObject)) blockFailure{
    NSString *path = kLinkSettingGetCreditCard;
    
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    User *user = [User currentUser];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];

}

- (void)getPayoutsWithSuccess:(void(^)(ResponseObject*responseObject))blockSuccess failure:(void(^)(ResponseObject*failureObject))blockFailure {
    NSString *path = kLinkGetPayouts;
    
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    User *user = [User currentUser];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)getOrders:(NSString *)nCurPage withSuccess:(void(^)(ResponseObject*responseObject))blockSuccess failure:(void(^)(ResponseObject*failureObject))blockFailure
{
    NSString *path = kLinkGetOrder;
    
    NSMutableDictionary*params = [NSMutableDictionary dictionary];
    User *user = [User currentUser];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"page", nCurPage);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)postCreditCard: (NSDictionary *)dictInfoCreditCard WithSuccess:(void (^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject * failureObject)) blockFailure{

    NSString *path = kLinkSettingPostCreditCard;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    User *user = [User currentUser];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"name", [dictInfoCreditCard objectForKey:KEY_NAME]);
    _setObjectToDictionary(params, @"card_number", [dictInfoCreditCard objectForKey:KEY_CARD_NUMBER]);
    _setObjectToDictionary(params, @"cvv_number", [dictInfoCreditCard objectForKey:KEY_CVV_NUMBER]);
    _setObjectToDictionary(params, @"expiration", [dictInfoCreditCard objectForKey:KEY_EXPIRATION]);
    _setObjectToDictionary(params, @"line1", [dictInfoCreditCard objectForKey:KEY_LINE1]);
    _setObjectToDictionary(params, @"line2", [dictInfoCreditCard objectForKey:KEY_LINE2]);
    _setObjectToDictionary(params, @"zipcode", [dictInfoCreditCard objectForKey:KEY_ZIPCODE]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)postPaymentInfomation: (NSDictionary *)dictInfoCreditCard WithSuccess:(void (^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject * failureObject)) blockFailure {
    NSString *path = kLinkPostPaymentInfomation;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    User *user = [User currentUser];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"product_id", [dictInfoCreditCard objectForKey:KEY_PRODUCT_ID]);
    _setObjectToDictionary(params, @"con_id", [dictInfoCreditCard objectForKey:KEY_CON_ID]);
    _setObjectToDictionary(params, @"zipcode", [dictInfoCreditCard objectForKey:KEY_ZIPCODE]);
    _setObjectToDictionary(params, @"price", [dictInfoCreditCard objectForKey:KEY_SELLING_PRICE]);
    _setObjectToDictionary(params, @"shiping_price", [dictInfoCreditCard objectForKey:KEY_SHIPPING_PRICE]);
    _setObjectToDictionary(params, @"tax", [dictInfoCreditCard objectForKey:KEY_PRODUCT_TAX]);
    _setObjectToDictionary(params, @"card_number", [dictInfoCreditCard objectForKey:KEY_CARD_NUMBER]);
    _setObjectToDictionary(params, @"payment_address", [dictInfoCreditCard objectForKey:KEY_LINE1]);
    NSLog(@"params: %@", params);
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)deleteCreditCard:(NSString*)card_id WithSuccess:(void(^)(ResponseObject* responseObject)) blockSuccess failure:(void(^)(ResponseObject * failureObject)) blockFailure{
    NSString *path = kLinkSettingDeleteCreditCard;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"card_id", card_id);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)getAddressWithSuccess:(void (^)(ResponseObject *responseObject)) blockSuccess failure:(void (^)(ResponseObject* failureObject)) blockFailure{

    NSString *path = kLinkSettingGetAddress;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    User *user = [User currentUser];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)postAddress:(NSDictionary*)dictAddress  WithSuccess:(void(^)(ResponseObject* responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure{
    NSString *path = kLinkSettingPostAddress;
    
    User *user = [User currentUser];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"line1", [dictAddress objectForKey:KEY_LINE1]);
    _setObjectToDictionary(params, @"line2", [dictAddress objectForKey:KEY_LINE2]);
    _setObjectToDictionary(params, @"zipcode", [dictAddress objectForKey:KEY_ZIPCODE]);
    _setObjectToDictionary(params, @"address_name", [dictAddress objectForKey:KEY_ADDRESS_NAME]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

-(void)getSettingPushNotifyWithSuccess:(void(^)(ResponseObject * responseObject)) blockSuccess failure:(void(^)(ResponseObject * failureObject))blockFailure{
    
    NSString *path = kLinkSettingPushNotify;
    User* user = [User currentUser];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", user.uid);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)getSettingEmailNotifyWithSuccess: (void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject *failureObject))blockFailure{
    
    NSString *path = kLinkSettingEmailNotify;
    User* user = [User currentUser];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", user.uid);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];

}

- (void)changeSettingPushNotify: (NSDictionary*)dictNotify withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void (^)(ResponseObject * failureObject))blockFailure{
    
    NSString *path = kLinkSettingChangeSettingPushNotify;
    User* user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"enable", [dictNotify objectForKey:KEY_ENABLE]);
    _setObjectToDictionary(params, @"new_message", [dictNotify objectForKey:KEY_NEW_MESSAGE]);
    _setObjectToDictionary(params, @"item_comments", [dictNotify objectForKey:KEY_ITEM_COMMENTS]);
    _setObjectToDictionary(params, @"new_feedback", [dictNotify objectForKey:KEY_NEW_FEEDBACK]);
    _setObjectToDictionary(params, @"discounted_items", [dictNotify objectForKey:KEY_DISCOUNTED_ITEMS]);
    _setObjectToDictionary(params, @"favorited_items", [dictNotify objectForKey:KEY_FAVORITED_ITEMS]);
    _setObjectToDictionary(params, @"new_followers", [dictNotify objectForKey:KEY_NEW_FOLLOWERS]);
    _setObjectToDictionary(params, @"new_items", [dictNotify objectForKey:KEY_NEW_ITEMS]);
    _setObjectToDictionary(params, @"catalog_news", [dictNotify objectForKey:KEY_CATALOG_NEWS]);
    _setObjectToDictionary(params, @"my_mentions", [dictNotify objectForKey:KEY_MY_MENTIONS]);
    _setObjectToDictionary(params, @"limit_each", [dictNotify objectForKey:KEY_LIMIT_EACH]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)changeSettingEmailNotify:(NSDictionary *)dict withSuccess:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject *failureObject))blockFailure{
    NSString *path = kLinkSettingChangeSettingEmailNotify;
    User* user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    _setObjectToDictionary(params, @"enable", [dict objectForKey:KEY_ENABLE]);
    _setObjectToDictionary(params, @"new_message", [dict objectForKey:KEY_NEW_MESSAGE]);
    _setObjectToDictionary(params, @"item_comments", [dict objectForKey:KEY_ITEM_COMMENTS]);
    _setObjectToDictionary(params, @"new_feedback", [dict objectForKey:KEY_NEW_FEEDBACK]);
    _setObjectToDictionary(params, @"discounted_items", [dict objectForKey:KEY_DISCOUNTED_ITEMS]);
    _setObjectToDictionary(params, @"favorited_items", [dict objectForKey:KEY_FAVORITED_ITEMS]);
    _setObjectToDictionary(params, @"new_followers", [dict objectForKey:KEY_NEW_FOLLOWERS]);
    _setObjectToDictionary(params, @"new_items", [dict objectForKey:KEY_NEW_ITEMS]);
    _setObjectToDictionary(params, @"catalog_news", [dict objectForKey:KEY_CATALOG_NEWS]);
    _setObjectToDictionary(params, @"my_mentions", [dict objectForKey:KEY_MY_MENTIONS]);
    _setObjectToDictionary(params, @"limit_each", [dict objectForKey:KEY_LIMIT_EACH]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)getNotifyMemberFavoritedWithSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void(^)(ResponseObject*failureObject)) blockFailure{
    
    NSString *path = kLinkSettingGetNotifyMemberFavorited;
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    
    NSLog(@"show user: %@", user);
    NSLog(@"show user id: %@", [user.uid stringValue]);
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)changeNotifyMemberFavorited:(NSDictionary*) dict withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void(^)(ResponseObject*failureObject)) blockFailure{
    
    NSString *path = kLinkSettingChangeNotifyMemberFavorited;
    User *user = [User currentUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"uid", [user.uid  stringValue]);
    _setObjectToDictionary(params, @"notify_members_favorited", [dict objectForKey:KEY_NOTIFY_MEMBERS_FAVORITED ]);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

- (void)getCityByZipCode:(NSString*)zipcode withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void(^)(ResponseObject*failureObject))blockFailure{

    NSString *path = kLinkSettingGetCityByZipcode;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"zipcode", zipcode);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

- (void)getListLocationWithKey:(NSString*)key withSuccess:(void(^)(ResponseObject*responseObject))blockSuccess failure:(void(^)(ResponseObject*failureObject))blockFailure{

    
    NSString *path = kLinkSettingGetListLocation;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"key", key);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}

#pragma mark - Push

- (void) registerDeviceTokenWithSuccess:(void(^)(ResponseObject*responseObject))blockSuccess failure:(void(^)(ResponseObject*failureObject))blockFailure {
    
    NSString *path = kLinkPushRegisterDeviceToken;
    
    NSString *stringToken = [Util getDeviceToken];
    
    if ([Util checkNullValues:stringToken]) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    _setObjectToDictionary(params, @"device_token", stringToken);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    NSString *logedIn = [[NSUserDefaults standardUserDefaults] objectForKey:kIS_LOGED];
    if ([logedIn isEqualToString:@"YES"]) {
        User *user = [User currentUser];
        _setObjectToDictionary(params, @"uid", [user.uid stringValue]);
    }


    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}

/*

- (void)addDrugWithName:(NSString *)name forNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{

    NSString *path = kAddDrug_Service;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"name", name);
    _setObjectToDictionary(params, @"token", [Session sharedInstance].accessToken);
    _setObjectToDictionary(params, @"nric",nric);
    
    NSString *json = [params JSONString];
    NSMutableDictionary *sendParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:json, @"drug_allergies_add", nil];
    
    [self postPath:path parameters:sendParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];

}

- (void)editDrug:(NSString *)ids name:(NSString *)name forNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{

    NSString *path = kEditDrug_Service;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"id",ids);
    _setObjectToDictionary(params, @"nric",nric);
    _setObjectToDictionary(params, @"name", name);
    _setObjectToDictionary(params, @"token", [Session sharedInstance].accessToken);
    
    NSString *json = [params JSONString];
    NSMutableDictionary *sendParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:json, @"drug_allergies_edit", nil];
    
    [self postPath:path parameters:sendParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];

}

- (void)deleteDrug:(NSString *)ids forNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure{

    NSString *path = kDeleteDrug_Service;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"id",ids);
    _setObjectToDictionary(params, @"nric",nric);
    _setObjectToDictionary(params, @"token", [Session sharedInstance].accessToken);
    
    NSString *json = [params JSONString];
    NSMutableDictionary *sendParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:json, @"drug_allergies_delete", nil];
    
    [self postPath:path parameters:sendParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}
*/
@end
