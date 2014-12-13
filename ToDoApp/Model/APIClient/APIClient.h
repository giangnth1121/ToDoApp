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


//Drug Service
/*

- (void)allDrugForNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void)addDrugWithName:(NSString *)name forNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void)editDrug:(NSString *)ids name:(NSString *)name forNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void)deleteDrug:(NSString *)ids forNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
*/
@end
