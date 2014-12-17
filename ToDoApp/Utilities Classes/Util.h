//
//  SWUtil.h
//  SRPLS
//
//  Created by Joy Aether Limited on 7/20/14.
//  Copyright (c) 2014 Joyaether.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@class AppDelegate;
#import "GCDispatch.h"
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
@interface Util : NSObject

@property (strong, nonatomic) MBProgressHUD *progressView;

- (void)showLoadingView;
- (void)showLoadingViewWithTitle:(NSString *)title;
- (void)hideLoadingView;

+ (Util *)sharedUtil;
+ (AppDelegate *)appDelegate;

+ (void)showAlert:(NSString *)title message:(NSString *)message delegate:(id)delegate;
+ (void)showAlertWithMessage:(NSString *)message delegate:(id)delegate;
+ (void)showAlertWithMessage:(NSString *)message tag:(NSInteger)tag delegate:(id)delegate;
+ (void)showAlertError:(NSString *)title;
/*
 * Making univesal Viewcontroller with two .xib UI
 */
+ (UIViewController*)newUniversalViewControllerWithClassName:(NSString*)className;

+ (UIColor *) getColor: (NSString *) RGBcolor;
+ (BOOL) checkNullValues:(id) value;

+ (void) saveInfoUser:(NSDictionary *) dictInfo;
+ (NSDictionary *) getInfoUser;

+ (void) saveStatusLogin:(NSString *) flag;
+ (NSString *) getStatusLogin;

+ (CGSize) getSizeText:(NSString *)text withWidth:(float)width andFont:(UIFont *) font;
+ (UIImage *) convertImage:(UIImage *)image withHeight:(float) height;
+ (NSAttributedString*) underlineStyleSingleWithText:(NSString *)text;
+ (NSAttributedString*) underLineBottomSignleWithText:(NSString*)text;
+ (NSString *) getDeviceToken;
+ (void) saveDeviceToken:(NSString *) token;



@end
