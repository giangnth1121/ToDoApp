//
//  UIButton+Bootstrap.h
//  UIButton+Bootstrap
//
//  Created by Oskar Groth on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//


/*
 *Example -- Example

 [self.defaultButton defaultStyle];
 [self.primaryButton primaryStyle];
 [self.successButton successStyle];
 [self.infoButton infoStyle];
 [self.warningButton warningStyle];
 [self.dangerButton dangerStyle];
 
 [self.bookmarkButton primaryStyle];
 [self.bookmarkButton addAwesomeIcon:FAIconBookmark beforeTitle:YES];
 
 [self.doneButton successStyle];
 [self.doneButton addAwesomeIcon:FAIconCheck beforeTitle:NO];
 
 [self.deleteButton dangerStyle];
 [self.deleteButton addAwesomeIcon:FAIconRemove beforeTitle:YES];
 
 [self.downloadButton defaultStyle];
 [self.downloadButton addAwesomeIcon:FAIconDownloadAlt beforeTitle:NO];
 
 [self.calendarButton infoStyle];
 [self.calendarButton addAwesomeIcon:FAIconMusic beforeTitle:NO];
 
 [self.favoriteButton warningStyle];
 [self.favoriteButton addAwesomeIcon:FAIconStar beforeTitle:NO];

 */

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"
@interface UIButton (Bootstrap)
- (void)addAwesomeIcon:(FAIcon)icon beforeTitle:(BOOL)before;
-(void)bootstrapStyle;
-(void)defaultStyle;
-(void)primaryStyle;
-(void)successStyle;
-(void)infoStyle;
-(void)warningStyle;
-(void)dangerStyle;
@end
