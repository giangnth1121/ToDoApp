
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
- (void) userLogin:(NSString *)email password:(NSString *)password success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkUserLogin;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"account", email);
    _setObjectToDictionary(params, @"password", password);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}
- (void) userFaceBookLogin:(NSString *)email fbId:(NSString *)fbId deviceId:(NSString *)deviceId success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkUserFacebookLogin;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"email", email);
    _setObjectToDictionary(params, @"fbid", fbId);
    _setObjectToDictionary(params, @"device_id", deviceId);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];

    
}
- (void)userRegister:(NSString *)email password:(NSString *)password success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkUserSignUp;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"email", email);
    _setObjectToDictionary(params, @"password", password);
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    NSLog(@"%@",params);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
        NSLog(@" error:%@",error);
    }];
    
}
- (void)userSignUpFacebook:(NSString *)email fbId:(NSString *)fbId deviceId:(NSString *)deviceId success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkUserSignUpFacebook;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"email", email);
    _setObjectToDictionary(params, @"fbid", fbId);
    _setObjectToDictionary(params, @"device_id", deviceId);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}
- (void)userLogOut:(NSString *)uID deviceId:(NSString *)deviceId success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkUserLogout;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"uid", uID);
    _setObjectToDictionary(params, @"device_id", deviceId);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}
- (void)registerDeviceWithTypeID:(int)typeID regID:(int)regID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = KLinkRegisterDevice;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *strTypeID = [NSString stringWithFormat:@"%ld",(long)typeID];
    NSString *strRegID = [NSString stringWithFormat:@"%ld",(long)regID];
    
    _setObjectToDictionary(params, @"device_id", UNIQUEIDENTIFIER_FOR_VENDOR);
    _setObjectToDictionary(params, @"dtype_id", strTypeID);
    _setObjectToDictionary(params, @"reg_id", strRegID);
    
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

#pragma mark - Note
- (void)createNewNote:(NSString *)uID nameNote:(NSString *)nameNote success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkNoteCreateNote;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"uid", uID);
    _setObjectToDictionary(params, @"name", nameNote);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
    
}
- (void)createNewNoteSub:(NSString *)uID noteID:(NSString *)noteID nameNoteSub:(NSString *)nameNoteSub success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkNoteCreateNoteSub;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"uid", uID);
    _setObjectToDictionary(params, @"note_id", noteID);
    _setObjectToDictionary(params, @"name", nameNoteSub);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}
- (void)getListNote:(NSString *)uID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkNoteGetListNote;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"uid", uID);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}
- (void)getListNoteSub:(NSString *)uID noteID:(NSString *)noteID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkNoteGetListNoteSub;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"uid", uID);
    _setObjectToDictionary(params, @"note_id", noteID);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}
- (void)deleteNote:(NSString *)uID noteID:(NSString *)noteID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkNoteGetListNoteSub;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"uid", uID);
    _setObjectToDictionary(params, @"note_id", noteID);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}
- (void)deleteNoteSub:(NSString *)uID noteSubID:(NSString *)noteSubID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure {
    
    NSString *path = kLinkNoteGetListNoteSub;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _setObjectToDictionary(params, @"uid", uID);
    _setObjectToDictionary(params, @"id", noteSubID);
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self processOperation:operation withData:responseObject success:blockSuccess failure:blockFailure];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self processOperation:operation withData:nil success:blockSuccess failure:blockFailure];
    }];
}
@end
