//
//  EditTabelCellProtocol.h
//  TestApp
//
//  Created by Сергей on 29.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GradientBackground.h"

@protocol EditTabelCellProtocol <NSObject>
- (void)updateTextView:(UITextView*)textView time:(UILabel*)time;
- (void)updateBackgroupd:(UIColor*)color;
- (NSIndexPath*)index;
- (GradientBackground*)getGradientBackgroundView;

@end
