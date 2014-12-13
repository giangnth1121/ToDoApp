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
#define kBaseServer                             @"http://vapemail.us/notecvn/cpapi/"

// API User
#define kLinkUserLogin                          @"user/login"
#define kLinkUserSignUp                         @"user/signup"
#define kLinkUserFacebookLogin                  @"user/loginFacebook"
#define kLinkUserSignUpFacebook                 @"user/signupFacbook"
#define kLinkUserLogout                         @"user/logout"
#define KLinkRegisterDevice                     @"user/registerDevice"

// API Note
#define kLinkNoteCreateNote                     @"note/createNote"
#define kLinkNoteCreateNoteSub                  @"note/createNoteSub"
#define kLinkNoteGetListNote                    @"note/getListNote"
#define kLinkNoteGetListNoteSub                 @"note/getListNoteSub"
#define kLinkNoteDeleteNote                     @"note/deleteNote"
#define kLinkNoteDeleteNoteSub                  @"note/deleteNoteSub"

#endif
