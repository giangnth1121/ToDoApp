//
//  SWUtil.h
//  SRPLS
//
//  Created by Tan Le on 7/20/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppDelegate;
#import "GCDispatch.h"
#import "MBProgressHUD.h"

static inline NSString *stringCheckNull(NSString *str)
{
    if ([str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [str description];
}

static inline NSString *stringWithoutSpace(NSString *str)
{
    
    NSString *result = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return result;
}

@interface SWUtil : NSObject

@property (nonatomic,strong) MBProgressHUD *HUD;

+ (SWUtil *)sharedUtil;
+ (AppDelegate *)appDelegate;

/*
 * Making univesal Viewcontroller with two .xib UI
 */
+ (UIViewController*)newUniversalViewControllerWithClassName:(NSString*)className;

- (void)showLoadingOnView:(UIView *)parentView withLable:(NSString *)label;
- (void)hideLoadingView;

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title;


+ (UIColor *) getColor: (NSString *) RGBcolor;
+ (BOOL) checkNullValues:(id) value;

+ (void) saveInfoUser:(NSDictionary *) dictInfo;
+ (NSDictionary *) getInfoUser;

+ (void) saveStatusLogin:(NSString *) flag;
+ (NSString *) getStatusLogin;

+ (void) saveDataAvatar:(NSData *) data;
+ (NSData *) getDataAvatar;
+ (CGSize) getSizeText:(NSString *)text withWidth:(float)width andFont:(UIFont *) font;
+ (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;
+ (UIImage *) convertImage:(UIImage *)image withWidth:(float) width;
+ (UIImage *) convertImage:(UIImage *)image withHeight:(float) height;
+ (NSAttributedString*) underlineStyleSingleWithText:(NSString *)text;
+ (NSAttributedString*) underLineBottomSignleWithText:(NSString*)text;
+ (NSString *) getDeviceToken;
+ (void) saveDeviceToken:(NSString *) token;
+ (NSString *) getImageSaveParth:(NSString *) imageName;
+ (BOOL) deleteAllImageSell;
+ (void) checkNumberNotifyAndMessageNotRead;

@end
