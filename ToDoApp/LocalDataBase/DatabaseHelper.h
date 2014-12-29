//
//  DatabaseHelper.h
//  TestApp
//
//  Created by Сергей on 23.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteObject.h"
#import "NoteGroupObject.h"

@interface DatabaseHelper : NSObject
+ (instancetype)instance;
- (NSArray*)getNodesForGroup:(NSInteger)group;
- (void)updateNote:(NoteObject*)objext;
- (NSMutableArray*)getNodeGropus;
- (void)updateNoteGroup:(NoteGroupObject*)object;
@end
