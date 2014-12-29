//
//  NoteObject.h
//  TestApp
//
//  Created by Сергей on 23.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteObject : NSObject
@property (nonatomic) NSInteger noteID;
@property (nonatomic) NSInteger groupID;
@property (nonatomic,copy) NSString* text;
@property (nonatomic) BOOL isComplated;
@property (nonatomic,copy) NSString* date;

@end
