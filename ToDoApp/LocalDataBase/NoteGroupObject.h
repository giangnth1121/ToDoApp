//
//  NoteGroupObject.h
//  TestApp
//
//  Created by Сергей on 27.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteGroupObject : NSObject
@property (nonatomic) NSInteger groupID;
@property (nonatomic,copy) NSString* name;
@property (nonatomic) NSInteger noteCount;
@end
