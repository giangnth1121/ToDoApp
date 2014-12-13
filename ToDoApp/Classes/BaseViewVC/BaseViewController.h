//
//  SWBaseViewController.h
//  SRPLS
//
//  Created by Tan Le on 7/20/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    
}

@property (nonatomic,assign) BOOL isDisplayLeftMenu;

- (void)setBackButtonWithImage:(NSString*)imageButtonName
              highlightedImage:(NSString*)highlightedImageButtonName
                        target:(id)target action:(SEL)action;

- (void)setRightButtonWithImage:(NSString*)imageButtonName
               highlightedImage:(NSString*)highlightedImageButtonName
                         target:(id)target action:(SEL)action;

- (void)setBackButtonWithImage:(NSString*)imageButtonName
                         title:(NSString*)title
              highlightedImage:(NSString*)highlightedImageButtonName
                        target:(id)target action:(SEL)action;

- (void)setRightButtonWithImage:(NSString*)imageButtonName
                          title:(NSString*)title
               highlightedImage:(NSString*)highlightedImageButtonName
                         target:(id)target action:(SEL)action;

- (void)initUI;
- (void)updateUI;
- (void)initData;
@end
