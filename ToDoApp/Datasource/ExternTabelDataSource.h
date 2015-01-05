//
//  ExternTabelDataSource.h
//  TestApp
//
//  Created by Сергей on 29.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GradientBackground.h"

@protocol ExternTabelDataSource <NSObject,UITableViewDataSource, UITableViewDelegate>
- (void)setColorForView:(GradientBackground*)backGround inIndex:(NSInteger)index;
- (void)setContent:(NSArray*)content;
- (void)setNewName:(NSString*)name forIndex:(NSInteger)index;
- (void)addNewItem;
- (void)setDelegate:(id)delegate;
- (NSArray*)getContent;
- (void)setPresentationImage:(UIImageView*)image;
- (UIImageView*)getPresentationImage:(UIImageView*)image;
@end
