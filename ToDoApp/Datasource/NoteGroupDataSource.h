//
//  NoteGroupDataSource.h
//  TestApp
//
//  Created by Сергей on 29.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExternTabelDataSource.h"

@protocol NoteGroupDelegate <NSObject>
- (void)openNotesForGroup:(NSInteger)groupID groupName:(NSString*)name indexPath:(NSIndexPath*)indexPath;
@end

@interface NoteGroupDataSource : NSObject<ExternTabelDataSource>

@end
