//
//  SWUtil.m
//  SRPLS
//
//  Created by Tan Le on 7/20/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import "Util.h"
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
            
            nibName = [NSString stringWithFormat:@"%@-iPad", className];
        }
        else if (IS_IPHONE_5) {
        
            nibName = [NSString stringWithFormat:@"%@-568h", className];
        }
        else {
            
            nibName = [NSString stringWithFormat:@"%@", className];

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

- (void)showLoadingView {
    [self showLoadingViewWithTitle:@""];
}

- (void)showLoadingViewWithTitle:(NSString *)title {
    self.HUD.labelText = title;
    if (self.loadingViewCount == 0) {
        [[Util appDelegate].window bringSubviewToFront:self.HUD];
        [self.HUD show:NO];
    }
    self.loadingViewCount++;
}

- (void)showLoadingOnView:(UIView *)parentView withLable:(NSString *)label{
    
    self.HUD = [[MBProgressHUD alloc] initWithView:parentView];
	[parentView addSubview:_HUD];
    if ([label length]) {
        
        _HUD.labelText = label;
    }
    else{
        
        _HUD.labelText = @"";
    }
    [self.HUD show:YES];
}

- (void)hideLoadingView {
    if (self.loadingViewCount > 0) {
        if (self.loadingViewCount == 1) {
            [self.HUD hide:NO];
        }
        self.loadingViewCount--;
    }
}


+ (void)showMessage:(NSString *)message withTitle:(NSString *)title {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

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

+ (BOOL) checkNullValues:(id) value {
    
    if ([value isEqual:[NSNull null]] && [value isEqual:[NSNull null]]) {
        
        return TRUE;
        
    }
    
    if ([[NSString stringWithFormat:@"%@",value] isEqualToString:@"<null>"]) {
        
        return TRUE;
        
    }
    
    return FALSE;
    
}

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

+ (NSData *) getDataAvatar{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"DataAvatar"];
    return data;
    
}

+ (CGSize) getSizeText:(NSString *)text withWidth:(float)width andFont:(UIFont *) font {

    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:text
     attributes:@
     {
     NSFontAttributeName: font
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size;
}

+ (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize {
    
    //CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    UIGraphicsBeginImageContext(newSize);
    //UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(newImage,0.5f);
    
    return [UIImage imageWithData:imageData];
}

+ (UIImage *) convertImage:(UIImage *)image withWidth:(float) width {

    float oldWidth = image.size.width;
    float scaleFactor = width / oldWidth;
    
    float newHeight = image.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;

}

+ (UIImage *) convertImage:(UIImage *)image withHeight:(float) height {
    
    float oldHeight = image.size.height;
    float scaleFactor = height / oldHeight;
    
    float newWidth = image.size.width * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, height));
    [image drawInRect:CGRectMake(0, 0, newWidth, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

+ (NSAttributedString*) underlineStyleSingleWithText:(NSString *)text{
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    return attributedString;
}

+ (NSAttributedString*) underLineBottomSignleWithText:(NSString*)text{
//    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc]initWithString:text];
//    
//    [attributedString addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(0, string.length)];//Underline color
//    return attributedString;
    
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

+ (NSString *) getImageSaveParth:(NSString *) imageName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/ImageSell"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
    
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",imageName]];
    
    return filePath;
    
}

+ (BOOL) deleteAllImageSell {
    
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/ImageSell"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:&error];
    
    if(error) {
        
        return FALSE;
        
    }
    
    return TRUE;
}



@end
