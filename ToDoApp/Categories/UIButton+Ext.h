//
//  UIButton+Ext.h
//  SwiftArchitecture
//
//  Created by Tan Le on 7/11/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.


#import <UIKit/UIKit.h>

@interface UIButton (Ext)

+ (UIButton *)setButtonWithFrame:(CGRect)buttonFrame
                 normalImageName:(NSString *)normalImageName
              highlightImageName:(NSString *)highlightImageName
                          target:(id)target
                          action:(SEL)action;

@end
