//
//  UIFont+Ext.m
//  SwiftArchitecture
//
//  Created by Tan Le on 7/11/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import "UIFont+Ext.h"

@implementation UIFont (Ext)

+ (void)printAllSystemFonts {

    printf("--------------------------------------------------------------------\n");
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames ){
        printf( "Family: %s \n", [familyName UTF8String] );
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames ){
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
    printf("--------------------------------------------------------------------\n");
}

+ (UIFont *)fontHelveticaNeue_Light:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
}

+ (UIFont *)fontHelveticaNeue_UltraLight:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:fontSize];
}

+ (UIFont *)fontHelveticaNeue_Medium:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
}

+ (UIFont *)fontHelveticaWithSize:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"Helvetica" size:fontSize];
}

+ (UIFont *)fontHelveticaBoldObliqueWithSize:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"Helvetica-BoldOblique" size:fontSize];
}

+ (UIFont *)fontHelveticaBoldWithSize:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
}

+ (UIFont *)fontHelveticaObliqueWithSize:(CGFloat)fontSize {
    
    return [UIFont fontWithName:@"Helvetica-Oblique" size:fontSize];
}

@end
