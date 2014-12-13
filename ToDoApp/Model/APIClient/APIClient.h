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

- (void) userLogin:(NSString *)userName password:(NSString *)password success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) userLoginHidden:(NSString *)uID token:(NSString *)token success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) userRegister:(NSString *)userName password:(NSString *)password email:(NSString *)email dataImage:(NSData *)data success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) userChangeAvatarWithDataImage:(NSData *)data success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) userFaceBookLogin:(NSString *)accessToken fbId:(NSString *)fbId deviceId:(NSString *)deviceId success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) userFaceBookRegister:(NSString *)fbId deviceId:(NSString *)deviceId userName:(NSString *)userName email:(NSString *)email success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) userEditProfile:(NSDictionary *)dictProfile success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailur;
- (void) userGetProfile:(NSString *)uid success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) userForgotPassword:(NSString *)email success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) userChangePassword:(NSString *)oldPass newPass:(NSString *)newPass success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) userGetLocationWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) userGetListFollowingWithSellerID:(NSString *)sellerID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) userGetListFollowerWithSellerID:(NSString *)sellerID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) userGetItemsWithUser:(NSString *)userID page:(NSString *)page Success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) postFeedback:(NSDictionary *)dictInfo Withsuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
    
- (void) userGetFeedBack :(NSDictionary*)dictInfo WithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *responseObject))blockFailure;

- (void) userSearchUserWithKey:(NSString*)key success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *responseObject))blockFailure;

- (void)sendReportUser:(NSString *)sellerID content:(NSString *)content withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void (^)(ResponseObject * failureObject))blockFailure;

- (void)getQuantityInfoWithSuccess:(void(^)(ResponseObject *responseObject))blockSuccess failure:(void(^)(ResponseObject *failureObject)) blockFailure;

- (void)loutOutWithSuccess:(void(^)(ResponseObject *responseObject))blockSuccess failure:(void(^)(ResponseObject *failureObject)) blockFailure;
#pragma mark - Message

- (void)checkConversationProductWithUserID:(NSString *)uid productID:(NSString *)productID success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure;
- (void)createConversationWithUserID:(NSString *)uid productID:(NSString *)productID success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure;
- (void)deleteConversationWithUserID:(NSString *)conID success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure;
- (void)getListConversationPage:(NSInteger)page WithSuccess: (void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure;
- (void)getListMessage:(NSString *)conID success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure;
- (void)getListOrderMessage:(NSString *)orderID messagePage:(int)pageIndex success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure;
- (void)postMessage:(NSString *)conID type:(NSInteger)type content:(NSString *)content success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure;
- (void)postOrderMessage:(NSString *)orderID type:(NSInteger)type content:(NSString *)content success:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure;
- (void) postMessageImage:(NSMutableArray *)arrData conID:(NSString *)conID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) postOrderMessageImage:(NSMutableArray *)arrData orderID:(NSString *)orderID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

#pragma mark - Feed

- (void) getListFeedWithPage:(NSInteger)page success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) getListFavouriteWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) getNotification: (NSInteger) page WithSuccess:(void(^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) feedFavorireProduct:(NSString *) productID type:(NSString *)type success:(void(^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) getProductComments :(NSString*) productID  page :(NSInteger) page success:(void(^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) commentProduct :(NSDictionary*) dict   success:(void(^)(ResponseObject* responseObject)) blockSuccess failure:(void(^)(ResponseObject *failureObject)) blockFailure;
- (void) userFollowUser :(NSString*)followerid type:(NSString *)type success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) userFollowBrand:(NSString*)brandID type:(NSString *)type success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) getSelectedMySize:(void(^)(ResponseObject* responseObject)) blockSuccess failure:(void(^)(ResponseObject *failureObject)) blockFailure;
- (void) postSelectedMySizeWithUseInFeed:(BOOL)flag clothing:(NSString *)strClothing shoes:(NSString *)strShoes success:(void(^)(ResponseObject* responseObject)) blockSuccess failure:(void(^)(ResponseObject *failureObject)) blockFailure;
- (void) viewedNotifyID:(NSString*)notify_ID WithSuccess:(void(^)(ResponseObject* responseObject)) blockSuccess failure:(void (^)(ResponseObject *failureObject)) blockFailure;
#pragma mark - Product

- (void) getCategoriesWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) getProductByCategoryID:(NSString *)catID pageIndex:(NSInteger)page success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) getBrandWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) getConditionWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) getColorsWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) postProduct:(NSDictionary *)dictInfo imageData:(NSMutableArray *)arrayData arrayImageName:(NSMutableArray *)arrayImgName  success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) editProduct:(NSDictionary *)dictInfo arrayData:(NSMutableArray *)arrayData success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) getCateoriesSize:(NSString *)catID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure ;

// get info product - brand
- (void) getProductDetailByID:(NSString *)productID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) getProductBrandInfo:(NSString *)brandID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

// get item product - brand
- (void) getProductRelatedWithID:(NSString *)productID page:(NSInteger) page userID:(NSString *)userID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
- (void) getProductBrandWithBrandID:(NSString *)brandID page:(NSInteger) page success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) getMemberItems:(NSString *)productID page:(NSInteger) page userID:(NSString *)userID success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) searchBrand:(NSString *)stringKey  success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void) searchProduct:(NSDictionary *)dictInfoSearch pageIndex:(NSInteger)page success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailur;

- (void)changeStatusProduct: (NSString *) productID status:(NSString *)status withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void (^)(ResponseObject * failureObject))blockFailure;

- (void)sendReportProduct:(NSString *)productID content:(NSString *)content withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void (^)(ResponseObject * failureObject))blockFailure;

- (void)changeStatusAsSold:(NSString *) productID asSold:(NSString *)status withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void (^)(ResponseObject * failureObject))blockFailure;

#pragma mark - setting
- (void) getCreditCardsWithSuccess:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void)postCreditCard: (NSDictionary *)dictInfoCreditCard WithSuccess:(void (^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject * failureObject)) blockFailure;

- (void)deleteCreditCard:(NSString*)card_id WithSuccess:(void(^)(ResponseObject* responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure;

- (void)getAddressWithSuccess:(void (^)(ResponseObject *responseObject)) blockSuccess failure:(void (^)(ResponseObject* failureObject)) blockFailure;

- (void)postAddress:(NSDictionary*)dictAddress  WithSuccess:(void(^)(ResponseObject* responseObject)) blockSuccess failure:(void(^)(ResponseObject* failureObject)) blockFailure;


-(void)getSettingPushNotifyWithSuccess:(void(^)(ResponseObject * responseObject)) blockSuccess failure:(void(^)(ResponseObject * responseObject)) blockFailure;

- (void)getSettingEmailNotifyWithSuccess: (void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject *responseObject)) blockFailure;

- (void)changeSettingPushNotify: (NSDictionary*)dictNotify withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void (^)(ResponseObject * failureObject)) blockFailure;

- (void)changeSettingEmailNotify:(NSDictionary *)dict withSuccess:(void(^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject *failureObject)) blockFailure;

- (void)getNotifyMemberFavoritedWithSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void(^)(ResponseObject*failureObject)) blockFailure;

- (void)changeNotifyMemberFavorited:(NSDictionary*) dict withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void(^)(ResponseObject*failureObject)) blockFailure;

- (void)getCityByZipCode:(NSString*)zipcode withSuccess:(void(^)(ResponseObject*responseObject)) blockSuccess failure:(void(^)(ResponseObject*failureObject))blockFailure;

- (void)getListLocationWithKey:(NSString*)key withSuccess:(void(^)(ResponseObject*responseObject))blockSuccess failure:(void(^)(ResponseObject*failureObject))blockFailure;

#pragma mark - push
- (void) registerDeviceTokenWithSuccess:(void(^)(ResponseObject*responseObject))blockSuccess failure:(void(^)(ResponseObject*failureObject))blockFailure;

#pragma-
#pragma mark - Payment
- (void)postPaymentInfomation: (NSDictionary *)dictInfoCreditCard WithSuccess:(void (^)(ResponseObject *responseObject)) blockSuccess failure:(void(^)(ResponseObject * failureObject)) blockFailure;
- (void)getPayoutsWithSuccess:(void(^)(ResponseObject*responseObject))blockSuccess failure:(void(^)(ResponseObject*failureObject))blockFailure;
- (void)getOrders:(NSString *)nCurPage withSuccess:(void(^)(ResponseObject*responseObject))blockSuccess failure:(void(^)(ResponseObject*failureObject))blockFailure;
//Drug Service
/*

- (void)allDrugForNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void)addDrugWithName:(NSString *)name forNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void)editDrug:(NSString *)ids name:(NSString *)name forNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;

- (void)deleteDrug:(NSString *)ids forNric:(NSString *)nric success:(void (^)(ResponseObject *responseObject))blockSuccess failure:(void (^)(ResponseObject *failureObject))blockFailure;
*/
@end
