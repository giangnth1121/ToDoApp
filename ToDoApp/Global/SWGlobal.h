//
//  SWGlobal.h
//  SwiftArchitecture
//
//  Created by Tan Le on 6/21/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#ifndef SwiftArchitecture_SWGlobal_h
#define SwiftArchitecture_SWGlobal_h

#define UPER_DATA_COUNT 10
#define dataHasChanged @"dataHasChanged"
#define CacheFoder @"CacheFoder"

#define TYPE_MESSAGE_DETAIL_CHAT 0
#define TYPE_MESSAGE_DETAIL_IMAGE 1
#define TYPE_MESSAGE_DETAIL_OFFER 2

/*
 * Defile key related to NSUserDefault
 */

#define kIS_LOGED  @"ISLOGED"

/*---USerDefault for FB Infomation keys---*/
#define uf_FB_ACCOUNT @"uf_FB_Account_Infomation"
#define uf_fb_accessToken @"fb_accessToken"
#define uf_fb_id @"id"
#define uf_fb_first_name @"first_name"
#define uf_fb_last_name @"last_name"
#define uf_fb_name @"name"
#define uf_fb_gender @"gender"
#define uf_fb_email @"email"

#define user_logged_ids @"userLoggedId"
#define user_logged_type @"userLoggedType"  //vinted:1, social:0
#define user_vinted_logged_password @"loggedPassword"
/*
 *Define Hexa Color
 */

#define grayText @"bababa"

/*
 *Define NSNotificationCenter
*/
#define kNotificationNumberMessageUnRead @"numberMessageUnRead"
#define kNotificationNumberNotifyUnRead @"numberNotifyUnRead"
#define kNotificationChangeAvatar @"ChangeAvatar"
#define kNotificationReloadFeed @"ReloadFeed"
#define kNotification_UpdateLeftMenu @"RefreshLeftMenuAfterLogin_Out"
#define kNotification_TheFirstRun   @"getStarted"
#define SCSessionStateChangedNotification   @"com.facebook.SRPLS:SCSessionStateChangedNotification"
#define SCSessionGetUserSucess              @"com.facebook.SRPLS:SCSessionGetUserSuccess"

#define kNotificationTypeMessage @"ReceiveMessage"
#define kNotificationTypeComment @"UserComment"
#define kNotificationTypeFavouriteItem @"FavoriteItem"
#define kNotificationTypeFollowSeller @"FollowSeller"
#define kNotificationTypeAddProduct @"AddProduct"

#define PUSH_TYPE_MESSAGE 1
#define PUSH_TYPE_COMMENT 2
#define PUSH_TYPE_FAVOURITE 3
#define PUSH_TYPE_FOLLOWSELLER 4
#define PUSH_TYPE_ADDPRODUCT 5

// key data
#define KEY_INFO @"info"
#define KEY_CATEGORY @"category"
#define KEY_CATEGORIES @"categories"
#define KEY_FEEDS @"feeds"
#define KEY_FEEDBACKS @"feedbacks"
#define KEY_PRODUCTS @"products"
#define KEY_CONDITION @"condition"
#define KEY_CONDITIONS @"conditions"
#define KEY_BRANDS @"brands"
#define KEY_COLORS @"colors"
#define KEY_COLOR1 @"color1"
#define KEY_COLOR2 @"color2"
#define KEY_PRODUCT @"product"
#define KEY_PRODUCTS @"products"
#define KEY_PRODUCT_IMAGE   @"product_image"
#define KEY_BRAND_INFO @"brand_info"
#define KEY_BRAND @"brand"
#define KEY_DATA @"data"
#define KEY_PROFILE @"profile"
#define KEY_NOTICES @"notices"
#define KEY_MESSAGE @"message"
#define KEY_BALANCE @"balance"
#define KEY_BITRHDAY @"birth_day"
#define KEY_DEGREE @"degree"
#define KEY_EMAIL @"email"
#define KEY_FBID @"fbid"
#define KEY_FOLLOWER @"follower"
#define KEY_FOLLOWING @"following"
#define KEY_FULL_NAME @"full_name"
#define KEY_INTRODUCE @"introduce"
#define KEY_ITEMS @"items"
#define KEY_JOINED @"joined"
#define KEY_AVG_RESPONSE @"avg_response"
#define KEY_LAST_LOIN @"last_login"
#define KEY_NORMAL @"normal"
#define KEY_NEGATIVE @"negative"
#define KEY_NEUTRAL @"neutral"
#define KEY_POSITIVE @"positive"
#define KEY_SEX @"sex"
#define KEY_SHOW_AGE @"show_age"
#define KEY_SHOW_NAME @"show_name"
#define KEY_STATUS @"status"
#define KEY_AS_SOLD @"as_sold"
#define KEY_TOKEN_VALUE @"token_value"
#define KEY_USENAME @"username"
#define KEY_CONVERSATIONS @"conversations"
#define KEY_CONVERSATION_UNREAD @"conversation_unread"
#define KEY_NOTIFY_UNREAD   @"notify_unread"
#define KEY_CODE @"code"
#define KEY_UID @"uid"
#define KEY_FULL_NAME @"full_name"
#define KEY_AVATAR @"avatar"
#define KEY_SEX @"sex"
#define KEY_CITY @"city"
#define KEY_LOCATION @"location"
#define KEY_LOCATION_ID @"location_id"
#define KEY_LOCATION_NAME @"location_name"
#define KEY_CITY @"city"
#define KEY_CITIES @"cities"
#define KEY_BIRTHDAY @"birth_day"
#define KEY_SHOW_AGE @"show_age"
#define KEY_LAST_USER_INFO @"last_user_info"
#define KEY_QUANTITY_INFO  @"quantity_info"

#define KEY_SELLER @"seller"
#define KEY_NAME @"name"
#define KEY_SIZE_TYPE @"size_type"
#define KEY_ICON @"icon"
#define KEY_FEED_ID @"feed_id"
#define KEY_TYPE @"type"
#define KEY_CONTENT @"content"
#define KEY_BRAND_ID @"brand_id"
#define KEY_BRAND_NAME @"brand_name"
#define KEY_BRAND_UPPER @"brand_upper"
#define KEY_FLLOWER @"follower"
#define KEY_ITEMS @"items"
#define KEY_IMAGES @"images"
#define KEY_IMAGE @"image"
#define KEY_IMAGE_ID @"image_id"
#define KEY_FOLLOWED @"followed"
#define KEY_TIMESTAMP @"timestamp"
#define KEY_PRODUCT_ID @"product_id"
#define KEY_OWNWE @"owner"
#define KEY_OWNWE_ID @"owner_id"
#define KEY_CAT_ID @"cat_id"
#define KEY_TITLE @"title"
#define KEY_PRODUCT_TITLE   @"product_title"
#define KEY_DESCRIPTION @"description"
#define KEY_ADDED @"added"
#define KEY_VIEWS @"views"
#define KEY_SIZE @"size"
#define KEY_SIZE_LIST @"size_list"
#define KEY_SIZE_ID @"size_id"
#define KEY_CONDITION_ID @"condition_id"
#define KEY_COLOR_ID1 @"color_id1"
#define KEY_COLOR_ID2 @"color_id2"
#define KEY_SHIPPING_PRICE @"shipping_price"
#define KEY_SOLD @"sold"
#define KEY_IS_SELL @"is_sell"
#define KEY_IS_SWAP @"is_swap"
#define KEY_IS_GIVE @"is_give"
#define KEY_ZIPCODE @"zipcode"

#define KEY_PUSH_SETTING    @"push_setting"
#define KEY_EMAI_SETTING    @"email_setting"
#define KEY_ENABLE          @"enable"
#define KEY_NEW_MESSAGE     @"new_message"
#define KEY_ITEM_COMMENTS   @"item_comments"
#define KEY_NEW_FEEDBACK    @"new_feedback"
#define KEY_DISCOUNTED_ITEMS    @"discounted_items"
#define KEY_FAVORITED_ITEMS     @"favorited_items"
#define KEY_NEW_FOLLOWERS   @"new_followers"
#define KEY_NEW_ITEMS       @"new_items"
#define KEY_CATALOG_NEWS    @"catalog_news"
#define KEY_MY_MENTIONS     @"my_mentions"
#define KEY_LIMIT_EACH      @"limit_each"
#define KEY_NOTIFY_MEMBERS_FAVORITED    @"notify_members_favorited"
#define KEY_NOTIFY_ID       @"notify_id"
#define KEY_NOTIFY_UNREAD   @"notify_unread"
#define KEY_SHIPPING_PRICE @"shipping_price"
#define KEY_SELLING_PRICE @"selling_price"
#define KEY_ORIGINAL_PRICE @"original_price"
#define KEY_PACKAGE_SIZE @"package_size"
#define KEY_LIKES @"likes"
#define KEY_COMMENTS @"comments"
#define KEY_FAVOURITED @"favorited"
#define KEY_FAVOURITES @"favorites"
#define KEY_LAST_COMMENT @"last_comment"
#define KEY_LAST_MESSAGE    @"last_message"
#define KEY_LAST_TIME   @"last_time"
#define KEY_LAST_USER   @"last_user"
#define KEY_COLOR_ID @"color_id"
#define KEY_COLOR_CODE @"color_code"
#define KEY_COLOR_NAME @"color_name"
#define KEY_UNREAD  @"unread"
#define KEY_SELLER_INFO @"seller_info"

#define KEY_RECEIVER_ID @"receiver_id"

#define KEY_KEY_SERARCH @"key"
#define KEY_FROM_PRICE @"from_price"
#define KEY_TO_PRICE @"to_price"
#define KEY_SIZE_TYPE @"size_type"
#define KEY_SIZE_IDS @"size_ids"
#define KEY_COLOR_IDS @"color_ids"
#define KEY_LOCATION_IDS @"location_ids"
#define KEY_CONDITION_IDS @"condition_ids"
#define KEY_BRAND_IDS @"brand_ids"
#define KEY_USE_IN_FEED @"use_in_feed"
#define KEY_SIZE_CLOTHING @"size_clothing"
#define KEY_SIZE_SHOES @"size_shoes"

#define KEY_CARD   @"card"
#define KEY_CARD_NUMBER @"card_number"
#define KEY_CVV_NUMBER  @"cvv_number"
#define KEY_EXPIRATION  @"expiration"
#define KEY_CARD_ID     @"card_id"

#define KEY_LINE1       @"line1"
#define KEY_LINE2       @"line2"
#define KEY_ADDRESS_NAME    @"address_name"
#define KEY_CON_ID      @"con_id"
#define KEY_ADDRESS     @"address"
#define KEY_ZIPCODE     @"zipcode"
#define KEY_PRODUCT_TAX @"tax"
#define KEY_ORDER       @"orders"
#define KEY_ORDER_ID    @"order_id"
#define KEY_PRODUCT_INFO @"product_info"

#define KEY_EDIT_IMAGE @"edit_image"
#define KEY_LIST_TYPE @"list_type"
#define KEY_LIST_INDEX @"list_index"

//Add by LongNH start
#define KEY_CHANGE_CREDIT_CARD @"KEY_CHANGE_CREDIT_CARD"
#define KEY_CHANGE_ADDRESS      @"KEY_CHANGE_ADDRESS"
#define FLOAT_COLOR_VALUE(n) (n)/255.0
#define kCreditCardLength 16
#define kCreditCardLengthPlusSpaces (kCreditCardLength + 3)
#define kExpirationLength 4
#define kExpirationLengthPlusSlash  kExpirationLength + 1
#define kCVV2Length 4
#define kZipLength 5

#define kCreditCardObscureLength (kCreditCardLength - 4)

#define kGetStart @"getStart"
#define kSpace @" "
#define kSlash @"/"
#define kCardNumberErrorAlert 1001
#define kCardExpirationErrorAlert 1002
//LongNH Add end

#define KEY_LIST_LOCATION @"list_location"
#pragma mark - define all message alert

#define OOPS @"Oops..."
#define ALERT_EMPTY_USERNAME @"Username is empty"
#define ALERT_EMPTY_PASSWORD @"Password is empty"
#define ALERT_FAIL_PASSWORD @"The password must be at 6-20 characters long"
#define ALERT_EMPTY_NEWPASSWORD @"New Password is empty"
#define ALERT_EMPTY_CONFIRM_NEWPASSWORD @"Confirm Password is empty"
#define ALERT_EMPTY_EMAIL @"Email is empty"
#define ALERT_PASS_NOT_SIMILAR_CONFIRMPASS @"Password not equal confirm password"
#define ALERT_FAIL_FORMAT_EMAIL @"Email fail"

#define ALERT_LOGIN_SUCCESS @"Login Success"
#define ALERT_LOGIN_FAIL @"Username or password wrong"

#define ALERT_EDIT_PROFILE_SUCCESS @"Edit Profile Success"
#define ALERT_EDIT_PROFILE_FAIL @"Edit Profile Fail"

#define ALERT_REGISTER_SUCCESS @"Register Success"
#define ALERT_REGISTER_FAIL @"Register Fail"

#define ALERT_CHANGE_PASS_SUCCESS @"Change Password Success"
#define ALERT_CHANGE_PASS_FAIL @"Change Password Fail"

#define ALERT_TEAM_POLICY @"You must agree with Team & Condition and Privacy Policy"
#define ALERT_AGE_POLICY @"You must have at least 18 years old or have parent's permission"

#define ALERT_NETWORK_ERR @"Network Error!"

#endif
