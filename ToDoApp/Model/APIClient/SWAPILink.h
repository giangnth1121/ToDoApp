//
//  SWAPILink.h
//  SwiftArchitecture
//
//  Created by Tan Le on 6/21/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#ifndef SwiftArchitecture_SWAPILink_h
#define SwiftArchitecture_SWAPILink_h

#define kUser_id                                @"user_id"
#define kSession_id                             @"session_id"
#define kBaseServer                             @"http://vapemail.us/srpls_api/"

// API User
#define kLinkUserLogin                          @"user/login"
#define kLinkUserLoginHidden                    @"user/loginHidden"
#define kLinkUserRegister                       @"user/register"
#define kLinkUserFacebookLogin                  @"user/facebookLogin"
#define kLinkUserFacebookRegister               @"user/registerFacebook"
//#define kLinkUserFacebookRegister               @"user/testapi"
#define kLinkUserEditProfile                    @"user/editProfile"
#define kLinkUserGetProfile                     @"user/getProfile"
#define kLinkUserChangePassword                 @"user/changePassword"
#define kLinkUserForgotPassword                 @"user/forgotPassword"
#define kLinkUserFollower                       @"user/getFollower"
#define kLinkUserFollowing                      @"user/getFollowing"
#define kLinkUserFeedBack                       @"user/feedback"
#define kLinkUserGetLocation                    @"user/getlocation"
#define kLinkUserGetUserItems                   @"user/getItems"
#define kLinkUserPostFeedback                   @"user/postFeedback"
#define kLinkUserGetFeedback                    @"user/getFeedBack"
#define kLinkUserChangeAvatar                   @"user/changeAvatar"
#define kLinkUserRegisterFollowUser             @"user/followUser"
#define kLinkUserRegisterFollowBrand            @"user/followBrand"
#define kLinkUserSearchUser                     @"user/searchUser"
#define kLinkUserReportItem                     @"user/report"
#define kLinkUserGetQuantity_info               @"user/getQuantityInfo"
#define kLinkUserLogout                         @"user/logout"

//API message
#define kLinkMessagecheckConversationProduct    @"message/checkConversationProduct"
#define kLinkMessageCreateConversation          @"message/createConversation"
#define kLinkMessageGetListConversation         @"message/getListConversation"
#define kLinkMessageGetListMessage              @"message/getListMessage"
#define kLinkMessagePostMessage                 @"message/postMessage"
#define kLinkMessageDeleteConversation          @"message/deleteConversation"
#define kLinkMessageGetOrderMessage             @"buy/getOrderMessage"
#define kLinkMessagePostOrderMessage            @"buy/postOrderMessage"

// API Feed
#define kLinkGetFeed                            @"feed/getFeeds"
#define kLinkGetListFavoriteProduct             @"feed/getListFavoriteProduct"
#define kLinkGetNotification                    @"feed/getNotification"
#define kLinkFeedFavoriteProduct                @"feed/favoriteProduct"
#define kLinkGetProductComment                  @"feed/getProductComment"
#define kLinkCommentProduct                     @"feed/commentProduct"
#define kLinkGetSelectedMySize                  @"feed/getUseInFeed"
#define kLinkPostSelectedMySize                 @"feed/postUseInFeed"
#define kLinkViewedNotify                       @"feed/viewedNotify"

// API Product
#define kLinkProductGetCategories               @"product/getCategories"
#define kLinkProductGetByCatID                  @"product/getProductsByCate"
#define kLinkProductGetBrand                    @"product/getBrands"
#define kLinkProductGetCondition                @"product/getConditions"
#define kLinkProductGetColors                   @"product/getColors"
#define kLinkProductPostProduct                 @"product/postProduct"
#define kLinkProductEditProduct                 @"product/editProduct"
#define kLinkProductGetCategoriesSize           @"product/getCategorySizes"
#define kLinkProductGetProductDetail            @"product/getProductDetail"
#define kLinkProductGetProductRelated           @"product/getProductRelated"
#define kLinkProductGetProductBrand             @"product/getProductByBrand"
#define kLinkProductGetBrandInfo                @"product/getBrandInfo"
#define kLinkProductSearchBrand                 @"product/searchBrand"
#define kLinkProductSearchProduct               @"product/searchProduct"
#define kLinkProductGetMemberItems              @"product/getMemberItems"
#define kLinkProductChangeStatusProduct         @"product/changeStatusProduct"
#define kLinkProductReportItem                  @"product/report"
#define kLinkProductMarkassold                  @"product/markassold"

//#define kLinkUserChangeAvatar @"user/testapi"

// API Setting
#define kLinkSettingGetCreditCard               @"setting/getCreditCard"
#define kLinkSettingPostCreditCard              @"setting/postCreditCard"
#define kLinkSettingDeleteCreditCard            @"setting/deleteCreditCard"
#define kLinkSettingGetAddress                  @"setting/getAddress"
#define kLinkSettingPostAddress                 @"setting/postAddress"
#define kLinkSettingPushNotify                  @"setting/getSettingPushNotify"
#define kLinkSettingEmailNotify                 @"setting/getSettingEmailNotify"
#define kLinkSettingChangeSettingPushNotify     @"setting/changeSettingPushNotify"
#define kLinkSettingChangeSettingEmailNotify    @"setting/changeSettingEmailNotify"
#define kLinkSettingGetNotifyMemberFavorited    @"setting/getNotifyMemberFavorited"
#define kLinkSettingChangeNotifyMemberFavorited @"setting/changeNotifyMemberFavorited"
#define kLinkSettingGetCityByZipcode            @"setting/getCityByZipcode"
#define kLinkSettingGetListLocation             @"setting/getListLocation"
#define kLinkPrivacy                            @"http://vapemail.us/html/privacy.html"
#define kLinkHelp                               @"http://vapemail.us/html/help.html"
#define kLinkTermAndCondition                   @"http://vapemail.us/html/terms.html"

#define kLinkPushRegisterDeviceToken            @"push/pushDeviceToken"

#define kLinkPostPaymentInfomation              @"buy/payment"
#define kLinkGetPayouts                         @"buy/getPayouts"
#define kLinkGetOrder                           @"buy/getOrders"

#endif
