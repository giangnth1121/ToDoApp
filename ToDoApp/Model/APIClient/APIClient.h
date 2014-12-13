//
//  APIClient.h
//  NewWindBase
//
//  Created by newwindsoft  on 8/6/13.
//  Copyright (c) 2013 newwindsoft . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFImageRequestOperation.h"
#import "ResponseObject.h"
#import "SWAPILink.h"
#import "Session.h"
#import "JSONKit.h"
//#import "NSData+Extension.h"
#import "NSData+Base64.h"

//JSON Keys
#define kJSONSuccess					200
#define kJSONCreatedSuccess             201
#define kJSONDeletedSuccess             204

#define kJSONInternalNetworkError       500
#define kJSONParseError					-1
#define kJSONUnauthorizedError			401
#define kJSONForbiddenError				403
#define kJSONPaymentRequiredError		402
#define kJSONPreconditionFailedError	412
#define kJSONRequestTimeoutError		408
#define kJSONConflictError				409
#define kJSONBadRequestError			400
#define kJSONNotFoundError				404
#define kJSONNoInternetConnection       0

@interface APIClient : AFHTTPClient

@property (nonatomic,strong) NSDictionary *contentDic;

+ (APIClient *) sharedClient;


#pragma mark - User
- (void) userLogin:(NSString *)email password:(NSString *)password success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) userFaceBookLogin:(NSString *)email fbId:(NSString *)fbId deviceId:(NSString *)deviceId success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void)userSignUp:(NSString *)email password:(NSString *)password success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void)userSignUpFacebook:(NSString *)email fbId:(NSString *)fbId deviceId:(NSString *)deviceId success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void)userLogOut:(NSString *)uID deviceId:(NSString *)deviceId success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void)registerDevice:(NSString *)deviceId typeID:(NSString *)typeID regID:(NSString *)regID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

#pragma mark - Note
- (void)createNewNote:(NSString *)uID nameNote:(NSString *)nameNote success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void)createNewNoteSub:(NSString *)uID noteID:(NSString *)noteID nameNoteSub:(NSString *)nameNoteSub success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void)getListNote:(NSString *)uID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void)getListNoteSub:(NSString *)uID noteID:(NSString *)noteID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void)deleteNote:(NSString *)uID noteID:(NSString *)noteID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void)deleteNoteSub:(NSString *)uID noteSubID:(NSString *)noteSubID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
@end
