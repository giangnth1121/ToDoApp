//
//  NoteDataSource.h
//  TestApp
//
//  Created by Сергей on 28.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExternTabelDataSource.h"

@protocol NoteDataSourceDelegate <NSObject>

- (void)beginEditingInIndexPath:(NSIndexPath*)indexPath;

@end

@interface NoteDataSource : NSObject<ExternTabelDataSource>
@property (nonatomic) NSInteger groupID;

@end
