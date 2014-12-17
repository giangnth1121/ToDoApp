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
#define KEY_INFO                @"info"
#define KEY_CODE                @"code"
#define KEY_DATA                @"data"
#define KEY_MESSAGE             @"message"
#define ALERT_NETWORK_ERR       @"Network Error!"


#endif
