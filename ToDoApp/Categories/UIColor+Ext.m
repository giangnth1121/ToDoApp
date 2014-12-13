//
//  UIColor+Ext.m
//  newwindsoft
//
//  Created by Vu Hoang Minh on 5/28/13.
//  Copyright (c) 2013 newwindsoft . All rights reserved.
//

#import "UIColor+Ext.h"

@implementation UIColor (Ext)

+ (UIColor *)colorWithHex:(NSString *)colorHex alpha:(CGFloat)alpha{
    
    unsigned int red, green, blue;
	NSRange range;
	range.length = 2;
	range.location = 0;
	[[NSScanner scannerWithString:[colorHex substringWithRange:range]] scanHexInt:&red];
	range.location = 2;
	[[NSScanner scannerWithString:[colorHex substringWithRange:range]] scanHexInt:&green];
	range.location = 4;
	[[NSScanner scannerWithString:[colorHex substringWithRange:range]] scanHexInt:&blue];
    
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:alpha];
}
@end
