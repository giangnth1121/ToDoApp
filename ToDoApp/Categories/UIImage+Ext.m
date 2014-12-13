//
//  UIImage+Ext.m
//  SwiftArchitecture
//
//  Created by Tan Le on 7/11/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import "UIImage+Ext.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (Ext)

+ (UIImage*)squareImage:(UIImage *)inputImage {
    
    int width = inputImage.size.width;
	int height = inputImage.size.height;
	CGRect newframe ;
	
	CGPoint centerPoint = CGPointMake(width/2, height/2);
	if (width > height) {
		
		newframe = CGRectMake(centerPoint.x - height/2, 0, height, height);
	}
	else {
        
		newframe = CGRectMake(0, centerPoint.y - width/2, width, width);
	}
	CGRect rect = newframe;
    
	// Create bitmap image from original image data,
	CGImageRef imageRef = CGImageCreateWithImageInRect([inputImage CGImage], rect);
	UIImage *outputImg = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	
	return outputImg;
}

+ (UIImage *)round:(UIImage *)image
               to:(float)radius
      borderColor:(UIColor *)color
       borderWith:(CGFloat )width {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CALayer *layer = [CALayer layer];
    layer = [imageView layer];
    
    layer.masksToBounds = YES;
    layer.cornerRadius = radius;
    
    layer.borderColor = [color CGColor];
    layer.borderWidth = width;
    
    UIGraphicsBeginImageContext(imageView.bounds.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image
             convertToSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return destImage;
}

+ (UIImage *)resizableImage:(UIImage *)images {
    
    UIImage *img;
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version >= 6) {
        
        img =  [images resizableImageWithCapInsets:UIEdgeInsetsMake((images.size.height - 1)/2, (images.size.width  - 1)/2 , (images.size.height - 1)/2, (images.size.width - 1)/2 ) resizingMode:UIImageResizingModeStretch];
    }
    else{
        
        if (version >= 5) {
            
            img = [images resizableImageWithCapInsets:UIEdgeInsetsMake((images.size.height - 1)/2, (images.size.width - 1)/2 , (images.size.height - 1)/2, (images.size.width - 1)/2)];
        }
        else{
            
            img = [images stretchableImageWithLeftCapWidth:(images.size.width - 1)/2 topCapHeight:(images.size.height - 1)/2];
        }
    }
    
    return img;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians {
    
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees {
    
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
