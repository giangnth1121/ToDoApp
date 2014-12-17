//
//  SWUtil.m
//  SRPLS
//
//  Created by Joy Aether Limited on 7/20/14.
//  Copyright (c) 2014 Joyaether.com. All rights reserved.
//

#import "Util.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface Util()

@property (atomic, readwrite) NSInteger loadingViewCount;

@end

@implementation Util

+ (Util *)sharedUtil {
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (void)dealloc {
    
}

#pragma mark Loading View
- (MBProgressHUD *)progressView
{
    if (!_progressView) {
        _progressView = [[MBProgressHUD alloc] initWithView:[Util appDelegate].window];
        if (IS_IPAD()) {
            _progressView.minSize = CGSizeMake(200.0f, 200.0f);
        }
        
        _progressView.animationType = MBProgressHUDAnimationFade;
        _progressView.dimBackground = NO;
        [[Util appDelegate].window addSubview:_progressView];
    }
    return _progressView;
}

- (void)showLoadingView {
    [self showLoadingViewWithTitle:@""];
}

- (void)showLoadingViewWithTitle:(NSString *)title {
    self.progressView.labelText = title;
    if (self.loadingViewCount == 0) {
        [[Util appDelegate].window bringSubviewToFront:self.progressView];
        [self.progressView show:NO];
    }
    self.loadingViewCount++;
}

- (void)hideLoadingView {
    if (self.loadingViewCount > 0) {
        if (self.loadingViewCount == 1) {
            [self.progressView hide:NO];
        }
        self.loadingViewCount--;
    }
}


+ (AppDelegate *)appDelegate {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    return appDelegate;
}

+ (UIViewController*)newUniversalViewControllerWithClassName:(NSString*)className {
   
    if ([className length] > 0) {
        // Nib name from className
        Class c = NSClassFromString(className);
        NSString *nibName = @"";
        
        if (IS_IPAD()) {
            
            nibName = [NSString stringWithFormat:@"%@_iPad", className];
        }
        else if (IS_IPHONE_5) {
        
            nibName = [NSString stringWithFormat:@"%@_iPhone", className];
        }
        else {
            
            nibName = [NSString stringWithFormat:@"%@_iPhone", className];

        }
        
        if([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] != nil) {
            //file found
            return [[c alloc] initWithNibName:nibName bundle:nil];
            
        } else {
            
            return [[UIViewController alloc] init];
        }
    }
    return nil;
}

+ (BOOL) checkNullValues:(id) value {
    
    if ([value isEqual:[NSNull null]] && [value isEqual:[NSNull null]]) {
        
        return TRUE;
        
    }
    
    if ([[NSString stringWithFormat:@"%@",value] isEqualToString:@"<null>"]) {
        
        return TRUE;
        
    }
    
    return FALSE;
    
}
#pragma mark - Alert
+ (void)showAlertError:(NSString *)title {
    
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alrt show];
}
+ (void)showAlert:(NSString *)title message:(NSString *)message delegate:(id)delegate {
    
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alrt show];
}

+ (void)showAlertWithMessage:(NSString *)message tag:(NSInteger)tag delegate:(id)delegate {
    UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:nil message:message delegate:delegate cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alrt.tag = tag;
    [alrt show];
}

+ (void)showAlertWithMessage:(NSString *)message delegate:(id)delegate {
    
    [self showAlertWithMessage:message tag:0 delegate:delegate];
}

#pragma mark - Get Color
+ (UIColor *) getColor: (NSString *) RGBcolor {
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[RGBcolor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[RGBcolor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[RGBcolor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
    
}

#pragma  mark -  Check Status login
+ (void) saveInfoUser:(NSDictionary *) dictInfo {
    
    [[NSUserDefaults standardUserDefaults] setValue:dictInfo forKey:@"InfoUser"];
    
}

+ (NSDictionary *) getInfoUser {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"InfoUser"];
    
}

+ (void) saveStatusLogin:(NSString *) flag {
    
    [[NSUserDefaults standardUserDefaults] setValue:flag forKey:@"login"];
    
}

+ (NSString *) getStatusLogin{
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]);
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    
}

+ (void) saveDataAvatar:(NSData *) data {
    
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"DataAvatar"];
    
}

#pragma mark - Underline Text
+ (NSAttributedString*) underlineStyleSingleWithText:(NSString *)text{
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    return attributedString;
}

+ (NSAttributedString*) underLineBottomSignleWithText:(NSString*)text{
    
    NSDictionary* attributes = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    return attributedString;
}

+ (NSString *) getDeviceToken {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    
}

+ (void) saveDeviceToken:(NSString *) token {
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"DeviceToken"];
    
}


@end
