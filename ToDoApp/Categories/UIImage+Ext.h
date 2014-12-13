//
//  UIImage+Ext.h
//  SwiftArchitecture
//
//  Created by Tan Le on 7/11/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Ext)

+ (UIImage*)squareImage:(UIImage *)inputImage;
+ (UIImage *)round:(UIImage *)image
               to:(float)radius
      borderColor:(UIColor *)color
       borderWith:(CGFloat )width;
+ (UIImage *)imageWithImage:(UIImage *)image
             convertToSize:(CGSize)size;
+ (UIImage *)resizableImage:(UIImage *)images;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
